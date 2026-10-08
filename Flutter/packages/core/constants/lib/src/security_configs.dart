/// Shared security settings for network requests and downloaded attachments.
///
/// These constants describe policies for the networking and download layers;
/// those layers must read and enforce each setting for it to take effect.
/// Keep values conservative and document any new setting with its purpose,
/// expected format, and enforcement requirements. Add a setting here when it
/// represents a shared policy, rather than a feature-specific option.
final class SecurityConfigs {
  /// Prevents creating instances; this class exposes only static settings.
  SecurityConfigs._();

  /// Whether SSL/TLS certificate pinning is enabled.
  ///
  /// Pinning is supported on Android and iOS. It is disabled by default because
  /// outdated pins can break connections when certificates or keys rotate. Set
  /// this to `true` only when the HTTP client enforces the fingerprints below
  /// and there is a process to maintain them.
  static const bool enableCertificatePinning = false;

  /// Base64-encoded SHA-256 fingerprints accepted by the pinning implementation.
  ///
  /// Maintain fingerprints for the pinned hosts, including a backup pin if the
  /// client supports one. Update them before certificate or key rotation. This
  /// list has no effect while [enableCertificatePinning] is `false`.
  static const List<String> allowedSHAFingerprints = [
    'mPD8kqJumUlVLREAQ3wb1fCTgmFbvBRH/NBnoba+N1Y=', // Fingerprint for alamelmarateb.com
  ];

  /// Hostnames allowed for API requests and attachment downloads.
  ///
  /// Validate each parsed URL before connecting. Compare normalized hostnames
  /// case-insensitively and require an exact match; substring matching could
  /// allow an attacker-controlled hostname. Add only hosts the app must access.
  static const List<String> trustedDomains = [
    'alamelmarateb.com',
    'api.alamelmarateb.com',
  ];

  /// Maximum accepted attachment download size in bytes (15 MiB).
  ///
  /// Enforce this limit while streaming data. A response's content-length may
  /// be missing or inaccurate and should not be the only size check.
  static const int maxDownloadSizeBytes = 15 * 1024 * 1024;

  /// File extensions accepted for downloaded attachments.
  ///
  /// Compare a normalized lowercase extension without its leading dot. This
  /// allowlist does not replace content validation or safe filename handling.
  static const Set<String> allowedFileExtensions = {
    'pdf',
    'gif',
    'png',
    'jpg',
    'jpeg',
    'webp',
    'xls',
    'xlsx',
    'csv',
  };

  /// Marker used by consumers to indicate that a request requires an
  /// authentication token. Consumers must enforce the requirement; this
  /// constant alone does not authenticate a request.
  static const String requireToken = 'requireToken';
}
