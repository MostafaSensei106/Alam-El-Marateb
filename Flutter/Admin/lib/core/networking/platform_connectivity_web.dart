import 'package:web/web.dart' as web;

/// `true` while the browser reports an active network adapter.
///
/// A `false` value reliably means the device is offline. A `true` value only
/// means an adapter exists — the request may still have been blocked (CORS,
/// mixed content, firewall, unreachable host) or the server may be down.
bool get isDeviceOnline => web.window.navigator.onLine;

/// `true` when the page itself was loaded over HTTPS.
///
/// Used to detect mixed content: an HTTPS page may not call a plain HTTP
/// endpoint, and browsers reject such requests before they reach the network.
bool get isBrowserPageSecure => web.window.location.protocol == 'https:';

/// The page's origin (`scheme://host[:port]`), or `null` when the browser
/// cannot provide a usable one (for example an `about:blank` or `file:` page
/// has the opaque origin `"null"`).
///
/// Used to decide whether a request is cross-origin, which is the precondition
/// for a CORS failure.
String? get browserPageOrigin {
  final origin = web.window.location.origin;
  if (origin.isEmpty || origin == 'null') return null;
  return origin;
}
