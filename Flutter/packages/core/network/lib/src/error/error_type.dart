/// Root-cause classification so UI can tell offline/timeout/auth apart.
enum ErrorType {
  offline,
  network,
  timeout,
  unauthorized,
  forbidden,
  clientError,
  serverError,
  cancelled,
  certificate,
  unknown,
}
