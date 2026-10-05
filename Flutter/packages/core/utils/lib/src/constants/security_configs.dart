final class SecurityConfigs {
  SecurityConfigs._();

  /// Whether SSL/TLS certificate pinning is enabled (supported on Android and iOS).
  /// Keep this false by default unless pins are actively maintained, to avoid app breakage during domain cert rotation.
  static const bool enableCertificatePinning = false;

  /// Allowed SHA-256 fingerprints for SSL pinning.
  static const List<String> allowedSHAFingerprints = [
    'mPD8kqJumUlVLREAQ3wb1fCTgmFbvBRH/NBnoba+N1Y=', // Fingerprint for hadidi-win-back.inxhub.online
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
}
