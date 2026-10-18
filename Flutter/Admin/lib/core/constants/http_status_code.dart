/// Provides named constants for commonly used HTTP status codes.
/// Use these values to compare or return HTTP response status codes.
/// Import this class from the constants package to use it in your application.
final class HttpStatusCodes {
  HttpStatusCodes._();

  /// HTTP 200: The request succeeded.
  static const int ok = 200;

  /// HTTP 201: The request succeeded and created a resource.
  static const int created = 201;

  /// HTTP 202: The request was accepted for processing, but processing is not complete.
  static const int accepted = 202;

  /// HTTP 203: The response was modified by a transforming proxy.
  static const int nonAuthoritativeInformation = 203;

  /// HTTP 204: The request succeeded and has no response content.
  static const int noContent = 204;

  /// HTTP 205: The request succeeded; the client should reset the document view.
  static const int resetContent = 205;

  /// HTTP 206: The server returned the requested range of content.
  static const int partialContent = 206;

  /// HTTP 207: The response contains status information for multiple resources.
  static const int multiStatus = 207;

  /// HTTP 300: The request has multiple possible responses.
  static const int multipleChoices = 300;

  /// HTTP 301: The resource has moved permanently to a new URI.
  static const int movedPermanently = 301;

  /// HTTP 302: The resource is temporarily available at another URI.
  static const int found = 302;

  /// HTTP 303: The response can be retrieved at another URI using GET.
  static const int seeOther = 303;

  /// HTTP 304: The resource has not changed since the last request.
  static const int notModified = 304;

  /// HTTP 305: The resource must be accessed through the specified proxy (deprecated).
  static const int useProxy = 305;

  /// HTTP 307: The request must be repeated at another URI using the same method.
  static const int temporaryRedirect = 307;

  /// HTTP 308: The resource has moved permanently; repeat the request using the same method.
  static const int permanentRedirect = 308;

  /// HTTP 400: The server cannot process the request because it is invalid.
  static const int badRequest = 400;

  /// HTTP 401: Authentication is required or has failed.
  static const int unauthorized = 401;

  /// HTTP 402: Payment is required to access the resource.
  static const int paymentRequired = 402;

  /// HTTP 403: The server understood the request but refuses to authorize it.
  static const int forbidden = 403;

  /// HTTP 404: The requested resource could not be found.
  static const int notFound = 404;

  /// HTTP 405: The request method is not allowed for this resource.
  static const int methodNotAllowed = 405;

  /// HTTP 406: The server cannot provide content matching the request's criteria.
  static const int notAcceptable = 406;

  /// HTTP 407: Authentication with the proxy is required.
  static const int proxyAuthenticationRequired = 407;

  /// HTTP 408: The server timed out waiting for the request.
  static const int requestTimeout = 408;

  /// HTTP 409: The request conflicts with the current state of the resource.
  static const int conflict = 409;

  /// HTTP 410: The requested resource is no longer available.
  static const int gone = 410;

  /// HTTP 411: The request must include a valid Content-Length header.
  static const int lengthRequired = 411;

  /// HTTP 412: A request precondition was not met.
  static const int preconditionFailed = 412;

  /// HTTP 413: The request content is larger than the server will accept.
  static const int payloadTooLarge = 413;

  /// HTTP 414: The request URI is longer than the server will accept.
  static const int uriTooLong = 414;

  /// HTTP 415: The request content format is not supported.
  static const int unsupportedMediaType = 415;

  /// HTTP 416: The requested range cannot be provided.
  static const int rangeNotSatisfiable = 416;

  /// HTTP 417: The server cannot meet the request's Expect header requirements.
  static const int expectationFailed = 417;

  /// HTTP 418: The server refuses to brew coffee because it is a teapot.
  static const int imATeapot = 418;

  /// HTTP 421: The request was sent to a server unable to produce a response.
  static const int misdirectedRequest = 421;

  /// HTTP 422: The request content is understood but cannot be processed.
  static const int unprocessableEntity = 422;

  /// HTTP 423: The resource is locked.
  static const int locked = 423;

  /// HTTP 424: The request failed because a dependent request failed.
  static const int failedDependency = 424;

  /// HTTP 425: The server is unwilling to process a request that might be replayed.
  static const int tooEarly = 425;

  /// HTTP 426: The client must upgrade to a different protocol.
  static const int upgradeRequired = 426;

  /// HTTP 428: The server requires a conditional request.
  static const int preconditionRequired = 428;

  /// HTTP 429: The client has sent too many requests in a given time.
  static const int tooManyRequests = 429;

  /// HTTP 431: The request headers are too large for the server to process.
  static const int requestHeaderFieldsTooLarge = 431;

  /// HTTP 451: The resource is unavailable for legal reasons.
  static const int unavailableForLegalReasons = 451;

  /// HTTP 500: The server encountered an unexpected condition.
  static const int internalServerError = 500;

  /// HTTP 501: The server does not support the functionality required by the request.
  static const int notImplemented = 501;

  /// HTTP 502: The server received an invalid response from an upstream server.
  static const int badGateway = 502;

  /// HTTP 503: The server is temporarily unable to handle the request.
  static const int serviceUnavailable = 503;

  /// HTTP 504: The server timed out waiting for an upstream server.
  static const int gatewayTimeout = 504;

  /// HTTP 505: The server does not support the request's HTTP version.
  static const int httpVersionNotSupported = 505;

  /// HTTP 506: A server configuration error caused content negotiation to fail.
  static const int variantAlsoNegotiates = 506;

  /// HTTP 507: The server cannot store the representation needed to complete the request.
  static const int insufficientStorage = 507;

  /// HTTP 508: The server detected an infinite loop while processing the request.
  static const int loopDetected = 508;

  /// HTTP 510: Further extensions to the request are required.
  static const int notExtended = 510;

  /// HTTP 511: Network authentication is required to access the resource.
  static const int networkAuthenticationRequired = 511;

  /// HTTP 599: A non-standard network connect timeout error.
  static const int networkConnectTimeoutError = 599;

  /// Sentinel value indicating that the HTTP status code is unknown or unavailable.
  static const int unknown = -1;
}
