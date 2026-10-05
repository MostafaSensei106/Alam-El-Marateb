/// HTTP header names used across the API.
abstract final class ApiHeaders {
  static const String accept = 'Accept';
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';

  static const String authorization = 'Authorization';
  static const String bearerPrefix = 'Bearer ';

  /// First-party client gate (see backend ClientKeyFilter).
  static const String apiClient = 'X-Api-Client';
  static const String apiKey = 'X-Api-Key';

  static const String language = 'X-Lang';
  static const String traceId = 'X-Trace-Id';
  static const String idempotencyKey = 'Idempotency-Key';
  static const String ifNoneMatch = 'If-None-Match';
}
