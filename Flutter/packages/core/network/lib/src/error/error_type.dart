/// Classifies the root cause of an API failure so the UI layer can
/// distinguish "no internet" from "server error" from "timeout", etc.
enum ErrorType {
  /// Device has no network adapter enabled (WiFi off, airplane mode).
  offline,

  /// Network adapter is on but request failed (DNS, socket, connection drop).
  network,

  /// Request timed out (connect, send, or receive timeout).
  timeout,

  /// Server responded with a 4xx client error.
  clientError,

  /// Server responded with a 5xx server error.
  serverError,

  /// Request was cancelled.
  cancelled,

  /// TLS/certificate error.
  certificate,

  /// Anything else.
  unknown,
}
