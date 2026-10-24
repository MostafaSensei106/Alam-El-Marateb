import 'package:web/web.dart' as web;

/// `true` while the browser reports an active network adapter.
///
/// A `false` value reliably means the device is offline. A `true` value only
/// means an adapter exists — the request may still have been blocked (CORS,
/// firewall, unreachable host) or the server may be down.
bool get isDeviceOnline => web.window.navigator.onLine;
