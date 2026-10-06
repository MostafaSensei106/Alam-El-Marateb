import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'interface/base_network_info.dart';

/// Production connectivity probe: adapter status + DNS reachability
/// (cached 5s). Register manually in each app's composition root.
class ConnectivityNetworkInfo implements BaseNetworkInfo {
  ConnectivityNetworkInfo([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  // ── Cache ──────────────────────────────────────────────────────────────
  /// How long a DNS-lookup result stays valid before we re-probe.
  static const _cacheDuration = Duration(seconds: 5);
  DateTime? _lastCheckTime;
  bool _lastCheckResult = false;

  // ── Adapter-level ──────────────────────────────────────────────────────

  @override
  Stream<List<ConnectivityResult>> get connectivityChanged =>
      _connectivity.onConnectivityChanged;

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result.isNotEmpty && result.first != ConnectivityResult.none;
  }

  // ── Actual internet reachability ───────────────────────────────────────

  @override
  Future<bool> get hasInternetAccess async {
    // 1. Fast path: if no adapter is on, skip the DNS lookup.
    if (!await isConnected) {
      return false;
    }

    // 2. Return cached result if it's still fresh.
    final now = DateTime.now();
    if (_lastCheckTime != null &&
        now.difference(_lastCheckTime!) < _cacheDuration) {
      return _lastCheckResult;
    }

    // 3. Perform a real DNS lookup.
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      _lastCheckResult =
          result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      _lastCheckResult = false;
    } on TimeoutException catch (_) {
      _lastCheckResult = false;
    } catch (_) {
      _lastCheckResult = false;
    }

    _lastCheckTime = now;
    return _lastCheckResult;
  }
}
