import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:fitness_app/core/network/api_endpoints.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:flutter/foundation.dart';

/// The single Dio instance every repository in the app talks through.
///
/// Centralizes what the API contract requires (see `apis/` —
/// `readme-cLqG (1).md`, `api-overview-QD3j.md`, `authentication-process-3eUk.md`,
/// `authentication-WlDp.md`, `environments-bsg8.md`):
/// * one base URL ([ApiEndpoints.baseUrl])
/// * the `X-API-KEY` header attached to every request automatically
/// * the app-signature layer (`X-App-Timestamp` / `X-App-Nonce` /
///   `X-App-Signature`) signed on every request once
///   [ApiEndpoints.appSignatureSecret] is set — the backend doesn't enforce
///   it yet, but signing now means enforcement can flip on server-side
///   without an app release
/// * every failure mapped to a typed [ApiException] — callers never see a
///   raw [DioException], a [SocketException], or a parse error escape here
///
/// Repositories should catch [ApiException] and fall back (cache, bundled
/// asset, etc.) rather than let it surface raw to the UI.
class ApiClient {
  ApiClient._internal() : _dio = Dio(_baseOptions()) {
    if (kDebugMode && ApiEndpoints.apiKey.isEmpty) {
      developer.log(
        'PILATES_API_KEY is not set — every request past /health will 401. '
        'Run with --dart-define=PILATES_API_KEY=<key>, or set it in .env.',
        name: 'ApiClient',
      );
    }
    if (kDebugMode && ApiEndpoints.appSignatureSecret.isEmpty) {
      developer.log(
        'PILATES_APP_SIGNATURE_SECRET is not set — requests go out unsigned. '
        'The backend does not enforce app-signature yet '
        '(ENFORCE_APP_SIGNATURE=false), but set it once ops shares the '
        'secret so enforcement can be flipped on without a client hotfix.',
        name: 'ApiClient',
      );
    }
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          _signRequest(options);
          if (kDebugMode) {
            developer.log(
              '→ ${options.method} ${options.uri}',
              name: 'ApiClient',
            );
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            developer.log(
              '← ${response.statusCode} ${response.requestOptions.uri}',
              name: 'ApiClient',
            );
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            developer.log(
              '✕ ${error.requestOptions.method} ${error.requestOptions.uri} — '
              '${error.type} ${error.response?.statusCode ?? ''}',
              name: 'ApiClient',
            );
          }
          handler.next(error);
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._internal();

  final Dio _dio;

  /// Escape hatch for calls this wrapper doesn't cover yet (e.g. multipart
  /// uploads to `/api/v1/scan/pose`) — still goes through the same base URL,
  /// headers, and app-signature interceptor as [get]/[post].
  Dio get dio => _dio;

  static BaseOptions _baseOptions() {
    return BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {
        'Accept': 'application/json',
        if (ApiEndpoints.apiKey.isNotEmpty) 'X-API-KEY': ApiEndpoints.apiKey,
      },
    );
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _guarded(
      () =>
          _dio.get<T>(path, queryParameters: queryParameters, options: options),
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _guarded(
      () => _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _guarded(
      () => _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return _guarded(
      () => _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      ),
    );
  }

  /// Checks connectivity up front (so a dead connection fails fast with a
  /// clear message instead of waiting out the full timeout), runs [request],
  /// and maps every possible failure — Dio's, or anything else — to
  /// [ApiException].
  Future<Response<T>> _guarded<T>(
    Future<Response<T>> Function() request,
  ) async {
    if (!await _hasConnection()) {
      throw const NoInternetException();
    }

    try {
      return await request();
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on ApiException {
      rethrow;
    } catch (error) {
      throw UnknownApiException('Unexpected error: $error');
    }
  }

  Future<bool> _hasConnection() async {
    try {
      final results = await Connectivity().checkConnectivity();
      return !results.every((result) => result == ConnectivityResult.none);
    } catch (_) {
      // The connectivity check itself failed — don't block the request on
      // it, let the real network call decide.
      return true;
    }
  }

  /// Adds `X-App-Timestamp` / `X-App-Nonce` / `X-App-Signature` per
  /// `apis/authentication-process-3eUk.md` §4. No-op when
  /// [ApiEndpoints.appSignatureSecret] is empty (the server ignores these
  /// headers while `ENFORCE_APP_SIGNATURE=false` anyway) or for [ApiEndpoints.health],
  /// which stays open with no auth at all.
  void _signRequest(RequestOptions options) {
    final secret = ApiEndpoints.appSignatureSecret;
    if (secret.isEmpty || options.path == ApiEndpoints.health) return;

    final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final nonce = _generateNonce();
    final canonical =
        '${options.method.toUpperCase()}|${options.path}|$timestamp|$nonce|'
        '${_canonicalBody(options)}';
    final signature = Hmac(
      sha256,
      utf8.encode(secret),
    ).convert(utf8.encode(canonical)).toString();

    options.headers['X-App-Timestamp'] = timestamp;
    options.headers['X-App-Nonce'] = nonce;
    options.headers['X-App-Signature'] = signature;
  }

  /// The body fragment of the canonical signing string, per
  /// `apis/authentication-process-3eUk.md` §5: a JSON body is always signed
  /// as the literal `{}` (never the real payload); a multipart body signs a
  /// compact, sorted-key JSON object of its *non-file* fields only; no body
  /// (or anything else) signs `{}`.
  String _canonicalBody(RequestOptions options) {
    final data = options.data;
    if (data is FormData) {
      final fields = <String, String>{
        for (final entry in data.fields) entry.key: entry.value,
      };
      final sortedKeys = fields.keys.toList()..sort();
      return jsonEncode({for (final key in sortedKeys) key: fields[key]});
    }
    return '{}';
  }

  /// A random per-request nonce in UUID-v4 shape, per the doc's
  /// "unique random string (UUID recommended)" — built from `Random.secure()`
  /// rather than pulling in the `uuid` package for one call site.
  String _generateNonce() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0F) | 0x40; // version 4
    bytes[8] = (bytes[8] & 0x3F) | 0x80; // variant 10xx
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  ApiException _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const RequestTimeoutException();
      case DioExceptionType.connectionError:
        return const NoInternetException();
      case DioExceptionType.badCertificate:
        return const UnknownApiException(
          'A secure connection to the server could not be established.',
        );
      case DioExceptionType.cancel:
        return const UnknownApiException('The request was cancelled.');
      case DioExceptionType.badResponse:
        return _mapStatusCode(error.response);
      case DioExceptionType.unknown:
        return const NoInternetException();
    }
  }

  ApiException _mapStatusCode(Response? response) {
    final statusCode = response?.statusCode ?? 0;
    final error = _extractError(response?.data);
    final message = error.message;
    final code = error.code;

    switch (statusCode) {
      case 401:
        return UnauthorizedException(
          message ?? 'Missing or invalid API key.',
          code,
        );
      case 403:
        return ForbiddenException(
          message ?? 'Access is temporarily blocked. Please try again later.',
          code,
        );
      case 404:
        return NotFoundException(
          message ?? 'The requested item could not be found.',
          code,
        );
      case 422:
        return ValidationException(
          message ?? 'The request was invalid.',
          errors: response?.data is Map
              ? (response!.data as Map)['errors'] as Map<String, dynamic>?
              : null,
          code: code,
        );
      case 429:
        return RateLimitedException(
          retryAfter: _retryAfter(response),
          message: message ?? 'Too many requests. Please try again shortly.',
          code: code,
        );
      case 504:
        return const RequestTimeoutException();
      default:
        if (statusCode >= 500) {
          return ServerException(
            message ?? 'Something went wrong on the server. Please try again.',
            statusCode: statusCode,
            code: code,
          );
        }
        return UnknownApiException(
          message ?? 'Something went wrong. Please try again.',
          code,
        );
    }
  }

  Duration? _retryAfter(Response? response) {
    final header = response?.headers.value('retry-after');
    final seconds = header == null ? null : int.tryParse(header);
    return seconds == null ? null : Duration(seconds: seconds);
  }

  /// Pulls a human-readable message (and, when present, a machine-readable
  /// code) out of whichever error shape the backend used for this route —
  /// `/api/v1/pilates/*`: `{"error":{"code":"NOT_FOUND","message":"..."}}`,
  /// everything else (admin, recommend, scan, generic): `{"success":false,"message":"..."}`.
  ({String? message, String? code}) _extractError(dynamic data) {
    if (data is Map) {
      final error = data['error'];
      if (error is Map) {
        return (
          message: error['message'] is String ? error['message'] as String : null,
          code: error['code'] is String ? error['code'] as String : null,
        );
      }
      if (data['message'] is String) {
        return (message: data['message'] as String, code: null);
      }
    }
    return (message: null, code: null);
  }
}
