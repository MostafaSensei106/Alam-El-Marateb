/// Centralised HTTP / network error messages.
///
/// Every string the UI might display lives here — never scattered across
/// handler classes — so copy-writers and translators have a single file to edit.
abstract final class HttpMessages {
  // ── Network ────────────────────────────────────────────────────────────────
  static const noInternet =
      'No internet connection. Please check your network and try again.';
  static const sendTimeout =
      'Request timed out while sending data. Please try again.';
  static const requestCancelled = 'Request was cancelled.';
  static const badCertificate =
      'Secure connection failed. Please contact support.';

  // ── 4xx ───────────────────────────────────────────────────────────────────
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

  // ── 5xx ───────────────────────────────────────────────────────────────────
  static const internalServerError =
      'Something went wrong on our end. Please try again later.';
  static const badGateway =
      'The server received an invalid response. Please try again.';
  static const serviceUnavailable =
      'Service is temporarily unavailable. Please try again later.';
  static const gatewayTimeout =
      'The server is taking too long to respond. Please try again.';

  // ── Fallback ───────────────────────────────────────────────────────────────
  static const unknownError = 'An unexpected error occurred. Please try again.';
}
