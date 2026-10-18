import 'security_event.dart';

/// Domain port for the security audit trail (Clean Architecture).
///
/// Implementations MUST:
/// - never persist or forward raw secrets (see `RedactionPolicy`);
/// - never throw (logging is best-effort observability, not control flow);
/// - be injectable so every consumer is unit-testable with a fake.
abstract interface class BaseAuditLogger {
  void audit(SecurityEvent event);

  void report(
    Object error,
    StackTrace stackTrace, {
    required String context,
    Map<String, Object?>? fields,
  });
}
