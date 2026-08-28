import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:fitness_app/core/network/api_endpoints.dart';
import 'package:fitness_app/core/network/api_exception.dart';
import 'package:flutter/foundation.dart';

/// The single Dio instance every repository in the app talks through.
///
/// Centralizes what the API contract requires (`readme-v3Nm.md`):
/// * one base URL ([ApiEndpoints.baseUrl])
/// * the `X-API-KEY` header attached to every request automatically
/// * every failure mapped to a typed [ApiException] — callers never see a
///   raw [DioException], a [SocketException], or a parse error escape here.
///
/// Repositories should catch [ApiException] and fall back (cache, bundled
/// asset, etc.) rather than let it surface raw to the UI.
class ApiClient {
  ApiClient._internal() : _dio = Dio(_baseOptions()) {
    if (kDebugMode && ApiEndpoints.apiKey.isEmpty) {
      developer.log(
        'PILATES_API_KEY is not set — every request past /health will 401. '
        'Run with --dart-define=PILATES_API_KEY=<key>.',
        name: 'ApiClient',
      );
    }
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
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
  /// uploads to `/api/v1/scan/pose`) — still goes through the same base URL
  /// and headers.
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
    final message = _extractMessage(response?.data);

    switch (statusCode) {
      case 401:
        return UnauthorizedException(message ?? 'Missing or invalid API key.');
      case 403:
        return ForbiddenException(
          message ?? 'Access is temporarily blocked. Please try again later.',
        );
      case 404:
        return NotFoundException(
          message ?? 'The requested item could not be found.',
        );
      case 422:
        return ValidationException(
          message ?? 'The request was invalid.',
          errors: response?.data is Map
              ? (response!.data as Map)['errors'] as Map<String, dynamic>?
              : null,
        );
      case 429:
        return RateLimitedException(retryAfter: _retryAfter(response));
      case 504:
        return const RequestTimeoutException();
      default:
        if (statusCode >= 500) {
          return ServerException(
            message ?? 'Something went wrong on the server. Please try again.',
            statusCode: statusCode,
          );
        }
        return UnknownApiException(
          message ?? 'Something went wrong. Please try again.',
        );
    }
  }

  Duration? _retryAfter(Response? response) {
    final header = response?.headers.value('retry-after');
    final seconds = header == null ? null : int.tryParse(header);
    return seconds == null ? null : Duration(seconds: seconds);
  }

  /// Pulls a human-readable message out of either error shape the backend
  /// uses — `{"message": "..."}` or the pilates-specific `{"error": {"message": "..."}}`.
  String? _extractMessage(dynamic data) {
    if (data is Map) {
      final error = data['error'];
      if (error is Map && error['message'] is String) {
        return error['message'] as String;
      }
      if (data['message'] is String) {
        return data['message'] as String;
      }
    }
    return null;
  }
}
