final class SecurityConfigs {
  SecurityConfigs._();

  /// Whether SSL/TLS certificate pinning is enabled (supported on Android and iOS).
  /// Keep this false by default unless pins are actively maintained, to avoid app breakage during domain cert rotation.
  static const bool enableCertificatePinning = false;

  /// Allowed SHA-256 fingerprints for SSL pinning.
  /// Keep a backup pin ready before enabling pinning so cert rotation
  /// does not brick the app.
  static const List<String> allowedSHAFingerprints = [
    'mPD8kqJumUlVLREAQ3wb1fCTgmFbvBRH/NBnoba+N1Y=', // Fingerprint for hadidi-win-back.inxhub.online
  ];

  /// Backup pin slot: add the next cert's fingerprint here before rotation.
  static const List<String> backupSHAFingerprints = <String>[];

  /// All pins (primary + backup) used when pinning is enabled.
  static List<String> get allSHAFingerprints => [
    ...allowedSHAFingerprints,
    ...backupSHAFingerprints,
  ];

  /// Hostnames that are allowed for API and attachment downloads to prevent SSRF.
  static const List<String> trustedDomains = ['hadidi-win-back.inxhub.online'];

  /// Max file size allowed for downloads (15 MB).
  static const int maxDownloadSizeBytes = 15 * 1024 * 1024;

  /// Allowed file extensions for attachments.
  static const List<String> allowedFileExtensions = [
    'pdf',
    'png',
    'jpg',
    'jpeg',
    'webp',
    'doc',
    'docx',
    'xls',
    'xlsx',
  ];

  static const requireToken = 'requireToken';

  // ── Secure vault (AES-256-GCM + Argon2id) ──────────────────────────

  /// Prefix for vault entries stored in secure storage.
  static const String vaultKeyPrefix = 'vault_';

  /// Salt key for Argon2id key derivation.
  static const String vaultSaltKey = 'vault_argon2_salt';

  /// OWASP-aligned Argon2id parameters (memory in KiB).
  static const int argon2Parallelism = 2;
  static const int argon2MemoryKiB = 19456;
  static const int argon2Iterations = 2;
  static const int argon2HashLength = 32;

  // ── Clipboard ──────────────────────────────────────────────────────

  /// Auto-clear delay for sensitive clipboard content (30s per skill).
  static const Duration clipboardClearDelay = Duration(seconds: 30);

  // ── Biometric gate ─────────────────────────────────────────────────

  /// Reason shown in the system biometric prompt.
  static const String biometricReason =
      'Authenticate to view or change sensitive data';
}
