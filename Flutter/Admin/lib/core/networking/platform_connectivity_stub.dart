/// Non-web fallback: the platform cannot answer synchronously, so assume the
/// device is online and let the failure be classified by its cause instead.
bool get isDeviceOnline => true;
