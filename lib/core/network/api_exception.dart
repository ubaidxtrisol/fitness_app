/// Every failure mode [ApiClient] can produce, typed so callers can react
/// (retry, fall back to cache, show a specific message) instead of pattern
/// matching on strings.
///
/// Every repository that calls the API should catch [ApiException] — never
/// let a raw [DioException] (or anything else) escape the network layer.
sealed class ApiException implements Exception {
  final String message;

  /// The backend's machine-readable error code, when it sent one — e.g.
  /// `NOT_FOUND` from the `/api/v1/pilates/*` error shape
  /// (`{"error":{"code":"NOT_FOUND","message":"..."}}`). Other routes
  /// (`{"success":false,"message":"..."}`, admin, recommend, scan) don't
  /// send a code, so this is often null — always fall back to [message]
  /// for display.
  final String? code;

  const ApiException(this.message, {this.code});

  @override
  String toString() => message;
}

/// No network at all — checked before the request is even sent.
class NoInternetException extends ApiException {
  const NoInternetException([
    String message = 'No internet connection. Please check your network and try again.',
  ]) : super(message);
}

/// The request took too long, in either direction.
class RequestTimeoutException extends ApiException {
  const RequestTimeoutException([
    String message = 'The request timed out. Please try again.',
  ]) : super(message);
}

/// 401 — missing/invalid `X-API-KEY`, or (once `ENFORCE_APP_SIGNATURE=true`
/// server-side) a missing/invalid/expired `X-App-Signature` proof — see
/// `apis/authentication-process-3eUk.md`. [message] already distinguishes
/// which one from the response body; [code] carries the raw code if sent.
class UnauthorizedException extends ApiException {
  const UnauthorizedException([
    String message = 'Missing or invalid API key.',
    String? code,
  ]) : super(message, code: code);
}

/// 403 — IP temporarily blocked after too many rate-limit strikes (2 strikes
/// → 24h IP block, per `apis/authentication-WlDp.md`).
class ForbiddenException extends ApiException {
  const ForbiddenException([
    String message = 'Access is temporarily blocked. Please try again later.',
    String? code,
  ]) : super(message, code: code);
}

/// 404 — unknown category / workout / exercise / program / challenge /
/// body-focus id.
class NotFoundException extends ApiException {
  const NotFoundException([
    String message = 'The requested item could not be found.',
    String? code,
  ]) : super(message, code: code);
}

/// 422 — request body failed validation.
class ValidationException extends ApiException {
  final Map<String, dynamic>? errors;
  const ValidationException(super.message, {this.errors, super.code});
}

/// 429 — rate limit exceeded; [retryAfter] mirrors the `Retry-After` header
/// when the server sends one. The backend's limits (per
/// `apis/authentication-WlDp.md`): 20 requests/60s for catalogue+recommend
/// routes, 5 requests/60s for `/api/v1/scan/pose`.
class RateLimitedException extends ApiException {
  final Duration? retryAfter;
  const RateLimitedException({
    this.retryAfter,
    String message = 'Too many requests. Please try again shortly.',
    String? code,
  }) : super(message, code: code);
}

/// 5xx / 504 — upstream failed or timed out processing the request.
class ServerException extends ApiException {
  final int? statusCode;
  const ServerException(super.message, {this.statusCode, super.code});
}

/// The response didn't parse into the shape the app expects.
class DataParsingException extends ApiException {
  const DataParsingException([
    String message = 'Received an unexpected response from the server.',
  ]) : super(message);
}

/// Anything else — cancellations, bad certificates, truly unknown Dio
/// errors. Kept narrow on purpose so it never masks a case that deserves
/// its own type.
class UnknownApiException extends ApiException {
  const UnknownApiException([
    String message = 'Something went wrong. Please try again.',
    String? code,
  ]) : super(message, code: code);
}
