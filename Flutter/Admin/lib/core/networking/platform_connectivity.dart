/// Synchronous, best-effort device-connectivity probe.
///
/// On the web this reads the browser's `navigator.onLine` flag — the only
/// connectivity signal available synchronously while classifying an error.
/// On every other platform it reports `true`, so the mapper never blames the
/// user's network when the platform cannot answer.
library;

export 'platform_connectivity_stub.dart'
    if (dart.library.js_interop) 'platform_connectivity_web.dart';
