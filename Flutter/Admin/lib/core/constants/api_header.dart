/// Defines common HTTP header names and related values used by the API.
final class ApiHeader {
  ApiHeader._();

  /// The header specifying the media type of the request body.
  static const String contentType = 'Content-Type';

  /// The header specifying the media types accepted in the response.
  static const String accept = 'Accept';

  /// The header key used to communicate the preferred locale.
  static const String locale = 'locale';

  /// The header carrying authentication credentials.
  static const String authorization = 'Authorization';

  /// The media type for JSON data.
  static const String applicationJson = 'application/json';

  /// The media type for plain text.
  static const String textPlain = 'text/plain';

  /// The media type for multipart form data.
  static const String multipartFormData = 'multipart/form-data';

  /// The header identifying the originating client application.
  static const String xRequestedWith = 'X-Requested-With';

  /// The authorization scheme used for bearer tokens.
  static const String tokenType = 'Bearer';

  /// The header specifying the language preferred for the response.
  static const String acceptLanguage = 'Accept-Language';

  /// The header identifying the client software making the request.
  static const String userAgent = 'User-Agent';

  /// The header controlling caching behavior.
  static const String cacheControl = 'Cache-Control';

  /// The header controlling caching for legacy HTTP/1.0 clients.
  static const String pragma = 'Pragma';

  /// The header identifying the origin of a request.
  static const String origin = 'Origin';

  /// The header identifying the address of the resource that caused a request.
  static const String referer = 'Referer';

  /// The header used for conditional requests based on an entity tag.
  static const String ifNoneMatch = 'If-None-Match';

  /// The header containing the entity tag for a resource.
  static const String etag = 'ETag';

  /// The header used to provide an API key.
  static const String xApiKey = 'X-API-Key';

  /// The header reporting the original client IP address through proxies.
  static const String xForwardedFor = 'X-Forwarded-For';

  /// The header used to uniquely identify a request for tracing.
  static const String xRequestId = 'X-Request-ID';

  /// The header specifying accepted content encodings.
  static const String acceptEncoding = 'Accept-Encoding';

  /// The header specifying the request or response body length in bytes.
  static const String contentLength = 'Content-Length';
}
