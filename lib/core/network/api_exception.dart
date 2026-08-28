/// Every failure mode [ApiClient] can produce, typed so callers can react
/// (retry, fall back to cache, show a specific message) instead of pattern
/// matching on strings.
///
/// Every repository that calls the API should catch [ApiException] — never
/// let a raw [DioException] (or anything else) escape the network layer.
sealed class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

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

/// 401 — missing or invalid `X-API-KEY`.
class UnauthorizedException extends ApiException {
  const UnauthorizedException([
    String message = 'Missing or invalid API key.',
  ]) : super(message);
}

/// 403 — IP temporarily blocked after too many rate-limit strikes.
class ForbiddenException extends ApiException {
  const ForbiddenException([
    String message = 'Access is temporarily blocked. Please try again later.',
  ]) : super(message);
}

/// 404 — unknown category / workout / exercise id.
class NotFoundException extends ApiException {
  const NotFoundException([
    String message = 'The requested item could not be found.',
  ]) : super(message);
}

/// 422 — request body failed validation.
class ValidationException extends ApiException {
  final Map<String, dynamic>? errors;
  const ValidationException(super.message, {this.errors});
}

/// 429 — rate limit exceeded; [retryAfter] mirrors the `Retry-After` header
/// when the server sends one.
class RateLimitedException extends ApiException {
  final Duration? retryAfter;
  const RateLimitedException({
    this.retryAfter,
    String message = 'Too many requests. Please try again shortly.',
  }) : super(message);
}

/// 5xx / 504 — upstream failed or timed out processing the request.
class ServerException extends ApiException {
  final int? statusCode;
  const ServerException(super.message, {this.statusCode});
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
  ]) : super(message);
}
