/// Centralised HTTP / network error messages.
///
/// Every string the UI might display lives here  never scattered across
/// handler classes  so copy-writers and translators have a single file to edit.
abstract final class HttpMessages {
  // ── Network & Transport ───────────────────────────────────────────────────
  /// Only used when the platform *proves* there is no connectivity.
  static const noInternet =
      'You appear to be offline. Connect to the internet and try again.';

  /// Generic transport failure. Deliberately avoids blaming the user's network
  /// because a browser reports CORS blocks, DNS failures and refused
  /// connections identically.
  static const connectionFailed =
      'Could not reach the server. It may be temporarily unavailable.';
  static const dnsFailure =
      'Could not find the server. Please check the address and your internet connection.';
  static const connectionRefused =
      'The server refused the connection. It may be offline or the port may be closed.';
  static const serverUnreachable =
      'The server could not be reached. It may be down or blocked by a firewall.';
  static const corsBlocked =
      'The request was blocked before it completed. The server may be unreachable, '
      'or the browser may have blocked it for security reasons (CORS).';
  static const mixedContentBlocked =
      'The page is secure but the request is not. An HTTPS page cannot call an HTTP server.';
  static const connectionTimeout =
      'Connection timed out. Please verify your connection and try again.';
  static const sendTimeout =
      'Request timed out while sending data. Please try again.';
  static const receiveTimeout =
      'Server took too long to respond. Please try again.';
  static const requestCancelled = 'Request was cancelled.';
  static const badCertificate =
      'Secure connection failed. Please contact support.';
  static const networkError =
      'Network communication failed. Please check your connection.';
  static const serializationError =
      'Failed to process server response. Please report this issue.';

  // ── 4xx Client Errors ─────────────────────────────────────────────────────
  static const badRequest = 'Bad request. Please check your input.';
  static const unauthorized = 'Session expired. Please sign in again.';
  static const paymentRequired = 'Payment is required to complete this action.';
  static const forbidden = 'You don\'t have permission to perform this action.';
  static const notFound = 'The requested resource was not found.';
  static const methodNotAllowed =
      'Request method is not allowed for this endpoint.';
  static const notAcceptable =
      'The server cannot provide content matching your request criteria.';
  static const proxyAuthenticationRequired =
      'Proxy authentication is required.';
  static const requestTimeout = 'The server took too long to respond.';
  static const conflict = 'This request conflicts with the current state.';
  static const gone = 'The requested resource is no longer available.';
  static const lengthRequired = 'Content-Length header is required.';
  static const preconditionFailed =
      'A precondition for this request was not met.';
  static const payloadTooLarge =
      'The submitted payload is too large for the server.';
  static const uriTooLong = 'The request URI is too long.';
  static const unsupportedMediaType =
      'The requested media format is not supported.';
  static const rangeNotSatisfiable =
      'The requested range cannot be provided by the server.';
  static const expectationFailed =
      'The expectation given in the Expect header could not be met.';
  static const imATeapot =
      'The server refuses to brew coffee because it is a teapot.';
  static const misdirectedRequest =
      'The request was directed to a server unable to produce a response.';
  static const unprocessableEntity =
      'The submitted data is invalid. Please review and try again.';
  static const locked = 'The requested resource is currently locked.';
  static const failedDependency =
      'The request failed due to a failure of a previous request.';
  static const tooEarly =
      'The server is unwilling to risk processing a request that might be replayed.';
  static const upgradeRequired =
      'Client protocol upgrade is required to proceed.';
  static const preconditionRequired =
      'The server requires the request to be conditional.';
  static const tooManyRequests =
      'Too many requests. Please slow down and try again shortly.';
  static const requestHeaderFieldsTooLarge =
      'Request header fields are too large.';
  static const unavailableForLegalReasons =
      'This resource is unavailable for legal reasons.';

  // ── 5xx Server Errors ─────────────────────────────────────────────────────
  static const internalServerError =
      'Something went wrong on our end. Please try again later.';
  static const notImplemented =
      'The server does not support the functionality required for this request.';
  static const badGateway =
      'The server received an invalid response. Please try again.';
  static const serviceUnavailable =
      'Service is temporarily unavailable. Please try again later.';
  static const gatewayTimeout =
      'The server is taking too long to respond. Please try again.';
  static const httpVersionNotSupported =
      'The HTTP version used in the request is not supported.';
  static const variantAlsoNegotiates =
      'Internal server configuration error during content negotiation.';
  static const insufficientStorage =
      'The server is unable to store the representation needed to complete the request.';
  static const loopDetected =
      'The server detected an infinite loop while processing the request.';
  static const notExtended =
      'Further extensions to the request are required for the server to fulfill it.';
  static const networkAuthenticationRequired =
      'Network authentication is required to access this resource.';
  static const networkConnectTimeoutError =
      'Network connection timed out while establishing connection to upstream server.';

  // ── Fallback ───────────────────────────────────────────────────────────────
  static const unknownError = 'An unexpected error occurred. Please try again.';
}
