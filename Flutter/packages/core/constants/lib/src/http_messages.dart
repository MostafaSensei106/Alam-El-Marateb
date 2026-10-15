/// Centralised HTTP / network error messages.
///
/// Every string the UI might display lives here — never scattered across
/// handler classes — so copy-writers and translators have a single file to edit.
abstract final class HttpMessages {
  static const noInternet =
      'No internet connection. Please check your network and try again.';
  static const sendTimeout =
      'Request timed out while sending data. Please try again.';
  static const requestCancelled = 'Request was cancelled.';
  static const badCertificate =
      'Secure connection failed. Please contact support.';

  static const badRequest = 'Bad request. Please check your input.';
  static const unauthorized = 'Session expired. Please sign in again.';
  static const forbidden = 'You don\'t have permission to perform this action.';
  static const notFound = 'The requested resource was not found.';
  static const requestTimeout = 'The server took too long to respond.';
  static const conflict = 'This request conflicts with the current state.';
  static const unprocessableEntity =
      'The submitted data is invalid. Please review and try again.';
  static const tooManyRequests =
      'Too many requests. Please slow down and try again shortly.';
  static const paymentRequired = 'Payment is required to access this resource.';
  static const methodNotAllowed =
      'This request method is not allowed for this resource.';
  static const gone = 'The requested resource is no longer available.';
  static const payloadTooLarge =
      'The request is too large. Please reduce its size and try again.';
  static const unsupportedMediaType = 'The request format is not supported.';
  static const locked = 'The requested resource is currently locked.';
  static const unavailableForLegalReasons =
      'This resource is unavailable for legal reasons.';

  // ── 5xx ───────────────────────────────────────────────────────────────────
  static const internalServerError =
      'Something went wrong on our end. Please try again later.';
  static const badGateway =
      'The server received an invalid response. Please try again.';
  static const serviceUnavailable =
      'Service is temporarily unavailable. Please try again later.';
  static const gatewayTimeout =
      'The server is taking too long to respond. Please try again.';
  static const notImplemented =
      'This functionality is not supported by the server.';
  static const httpVersionNotSupported =
      'The server does not support this HTTP version.';
  static const networkAuthenticationRequired =
      'Network authentication is required to access this resource.';

  static const unknownError = 'An unexpected error occurred. Please try again.';
}
