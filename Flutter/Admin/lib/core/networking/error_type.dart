/// Classifies the root cause of an API failure so the UI layer can
/// distinguish "no internet" from "server error" from "timeout", etc.
///
/// The cases are deliberately granular: a failed request carries very little
/// information, so the mapper infers as much as it can from the underlying
/// exception. Anything it cannot prove falls back to [network] or [unknown]
/// rather than blaming the user's connection.
enum ErrorType {
  /// Device has no network adapter enabled (WiFi off, airplane mode).
  ///
  /// Only reported when the platform can prove there is no connectivity
  /// (for example the browser's `navigator.onLine` is `false`).
  offline,

  /// Generic transport failure that could not be classified further.
  network,

  /// Request timed out (connect, send, or receive timeout).
  ///
  /// Kept for backward compatibility; new code emits the specific
  /// [connectionTimeout], [sendTimeout] and [receiveTimeout] cases.
  timeout,

  /// Server responded with a 4xx client error.
  clientError,

  /// Server responded with a 5xx server error.
  serverError,

  /// Request was cancelled.
  cancelled,

  /// TLS/certificate error.
  certificate,

  /// Data serialization or model mapping mismatch (FormatException, TypeError).
  serialization,

  /// Anything else.
  unknown,

  /// The host name could not be resolved (DNS lookup failed).
  dnsFailure,

  /// The host resolved but actively refused the connection (port closed or
  /// service not running).
  connectionRefused,

  /// The host could not be reached at all (network unreachable, host down,
  /// firewall dropping packets).
  serverUnreachable,

  /// The browser blocked the request because the cross-origin preflight
  /// (`OPTIONS`) was rejected, or the response lacked the CORS headers.
  corsBlocked,

  /// An HTTPS page tried to call a plain `http://` endpoint, which browsers
  /// block as mixed content.
  mixedContentBlocked,

  /// The TCP/TLS connection could not be established in time.
  connectionTimeout,

  /// The request was sent but the server did not start responding in time.
  receiveTimeout,

  /// The request body could not be uploaded in time.
  sendTimeout,
}
