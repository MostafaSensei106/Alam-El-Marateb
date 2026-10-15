import 'audit_severity.dart';

/// Typed taxonomy of security-sensitive audit events.
///
/// Why a sealed class instead of `AppLogger.security('phone_launch')`:
/// - Stringly-typed events typo silently, break dashboards, and accept
///   arbitrary payloads (including secrets).
/// - Typed events carry ONLY non-sensitive, whitelisted fields — the compiler
///   rejects logging a token/password by construction.
/// - Analytics/forensics can `switch` exhaustively over events.
sealed class SecurityEvent {
  const SecurityEvent();

  String get name;
  AuditSeverity get severity;
  Map<String, Object?> get fields;
}

final class VaultKeyDerived extends SecurityEvent {
  const VaultKeyDerived();
  @override
  String get name => 'vault.key_derived';
  @override
  AuditSeverity get severity => AuditSeverity.info;
  @override
  Map<String, Object?> get fields => const {};
}

final class VaultEncrypted extends SecurityEvent {
  const VaultEncrypted(this.keyId);
  final String keyId;
  @override
  String get name => 'vault.encrypt';
  @override
  AuditSeverity get severity => AuditSeverity.info;
  @override
  Map<String, Object?> get fields => {'keyId': keyId};
}

final class VaultDecrypted extends SecurityEvent {
  const VaultDecrypted(this.keyId);
  final String keyId;
  @override
  String get name => 'vault.decrypt';
  @override
  AuditSeverity get severity => AuditSeverity.info;
  @override
  Map<String, Object?> get fields => {'keyId': keyId};
}

final class VaultWiped extends SecurityEvent {
  const VaultWiped(this.keyId);
  final String keyId;
  @override
  String get name => 'vault.wiped';
  @override
  AuditSeverity get severity => AuditSeverity.info;
  @override
  Map<String, Object?> get fields => {'keyId': keyId};
}

final class VaultKeysPurged extends SecurityEvent {
  const VaultKeysPurged(this.count);
  final int count;
  @override
  String get name => 'vault.keys_purged';
  @override
  AuditSeverity get severity => AuditSeverity.info;
  @override
  Map<String, Object?> get fields => {'count': count};
}

final class ClipboardSensitiveCopied extends SecurityEvent {
  const ClipboardSensitiveCopied();
  @override
  String get name => 'clipboard.sensitive_copied';
  @override
  AuditSeverity get severity => AuditSeverity.info;
  @override
  Map<String, Object?> get fields => const {};
}

final class ClipboardCleared extends SecurityEvent {
  const ClipboardCleared({required this.auto});
  final bool auto;
  @override
  String get name => 'clipboard.cleared';
  @override
  AuditSeverity get severity => AuditSeverity.info;
  @override
  Map<String, Object?> get fields => {'auto': auto};
}

final class BiometricGranted extends SecurityEvent {
  const BiometricGranted();
  @override
  String get name => 'biometric.granted';
  @override
  AuditSeverity get severity => AuditSeverity.info;
  @override
  Map<String, Object?> get fields => const {};
}

final class BiometricDenied extends SecurityEvent {
  const BiometricDenied();
  @override
  String get name => 'biometric.denied';
  @override
  AuditSeverity get severity => AuditSeverity.warning;
  @override
  Map<String, Object?> get fields => const {};
}

final class ExternalUrlLaunched extends SecurityEvent {
  const ExternalUrlLaunched(this.host);
  final String host;
  @override
  String get name => 'intent.url_launched';
  @override
  AuditSeverity get severity => AuditSeverity.info;
  @override
  Map<String, Object?> get fields => {'host': host};
}

final class ExternalUrlBlocked extends SecurityEvent {
  const ExternalUrlBlocked(this.host, this.reason);
  final String host;
  final String reason;
  @override
  String get name => 'intent.url_blocked';
  @override
  AuditSeverity get severity => AuditSeverity.warning;
  @override
  Map<String, Object?> get fields => {'host': host, 'reason': reason};
}

final class EmailClientLaunched extends SecurityEvent {
  const EmailClientLaunched();
  @override
  String get name => 'intent.email_launched';
  @override
  AuditSeverity get severity => AuditSeverity.info;
  @override
  Map<String, Object?> get fields => const {};
}

final class DialerLaunched extends SecurityEvent {
  const DialerLaunched();
  @override
  String get name => 'intent.dialer_launched';
  @override
  AuditSeverity get severity => AuditSeverity.info;
  @override
  Map<String, Object?> get fields => const {};
}

final class RemoteFileOpened extends SecurityEvent {
  const RemoteFileOpened(this.host);
  final String host;
  @override
  String get name => 'intent.file_opened';
  @override
  AuditSeverity get severity => AuditSeverity.info;
  @override
  Map<String, Object?> get fields => {'host': host};
}

final class CertPinningEnabled extends SecurityEvent {
  const CertPinningEnabled(this.fingerprintCount);
  final int fingerprintCount;
  @override
  String get name => 'transport.pinning_enabled';
  @override
  AuditSeverity get severity => AuditSeverity.info;
  @override
  Map<String, Object?> get fields => {'fingerprintCount': fingerprintCount};
}
