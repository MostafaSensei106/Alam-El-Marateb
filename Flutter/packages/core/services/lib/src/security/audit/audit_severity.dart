/// Severity of a security audit event.
///
/// - [info]: routine, expected (login view, copy, launch).
/// - [warning]: blocked/denied attempt worth triaging (SSRF block, denied bio).
/// - [critical]: integrity failure (decrypt failure, wipe failure).
enum AuditSeverity { info, warning, critical }
