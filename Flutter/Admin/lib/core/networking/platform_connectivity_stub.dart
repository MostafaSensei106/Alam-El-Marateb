/// Non-web fallback: the platform cannot answer synchronously, so assume the
/// device is online and let the failure be classified by its cause instead.
bool get isDeviceOnline => true;

/// Native apps have no page origin, so nothing can be "mixed content".
bool get isBrowserPageSecure => false;

/// Native requests are never subject to the browser's same-origin policy, so
/// there is no page origin to compare against.
String? get browserPageOrigin => null;
