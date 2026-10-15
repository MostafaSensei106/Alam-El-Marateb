/// Pure, testable redaction policy for audit payloads.
///
/// Defense-in-depth: even though [SecurityEvent] only carries whitelisted
/// fields, errors and legacy maps may still contain secrets — this policy
/// strips them before they reach any sink.
final class RedactionPolicy {
  const RedactionPolicy();

  static const redactedValue = '***';

  /// Markers matched as substrings (long enough to avoid collisions).
  static const _longMarkers = {
    'password',
    'passwd',
    'token',
    'authorization',
    'bearer',
    'secret',
    'encryptionkey',
    'privatekey',
    'fcm',
    'apns',
  };

  /// Short markers matched on token boundaries only.
  static const _shortMarkers = {'otp', 'pin', 'pwd'};

  static const _sensitiveSubstrings = {..._longMarkers, ..._shortMarkers};

  static final _bearerPattern = RegExp(
    r'Bearer\s+[A-Za-z0-9\-._~+/=]+',
    caseSensitive: false,
  );

  bool isSensitiveKey(String key) {
    final lower = key.toLowerCase();
    // Long markers: substring match (authorization, encryptionkey, ...).
    if (_longMarkers.any(lower.contains)) return true;
    // Short markers (pin/otp/pwd): match only on token boundaries so
    // innocent names like `couponCode` never get redacted. Split camelCase
    // before lowercasing to preserve the boundaries.
    final tokens = RegExp(r'[A-Z]?[a-z]+|[A-Z]+(?![a-z])|\d+')
        .allMatches(key)
        .map((m) => m.group(0)!.toLowerCase());
    return tokens.any(_shortMarkers.contains);
  }

  Map<String, Object?> redactMap(Map<String, Object?>? data) {
    if (data == null || data.isEmpty) return const {};
    return data.map(
      (key, value) =>
          MapEntry(key, isSensitiveKey(key) ? redactedValue : value),
    );
  }

  /// Returns a safe-to-log representation of [error].
  /// Secrets anywhere in the message collapse to a fixed marker.
  Object redactError(Object error) {
    final text = error.toString();
    final lower = text.toLowerCase();
    final hit =
        _sensitiveSubstrings.any(lower.contains) ||
        _bearerPattern.hasMatch(text);
    return hit ? 'Redacted security error' : error;
  }

  String redactText(String text) {
    final withBearer = text.replaceAll(
      _bearerPattern,
      'Bearer ${RedactionPolicy.redactedValue}',
    );
    // 'bearer' itself is handled above; only other secret markers collapse
    // the whole line.
    final lower = withBearer.toLowerCase();
    const nonBearerMarkers = {
      'password',
      'passwd',
      'pwd',
      'token',
      'authorization',
      'otp',
      'pin',
      'secret',
      'encryptionkey',
      'privatekey',
      'fcm',
      'apns',
    };
    if (nonBearerMarkers.any(lower.contains)) {
      return 'Redacted security error';
    }
    return withBearer;
  }
}
