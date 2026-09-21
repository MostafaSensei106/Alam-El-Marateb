import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstraction over connectivity checks.
///
/// [isConnected] checks whether a network adapter is enabled (WiFi, mobile).
/// [hasInternetAccess] performs a real reachability probe (DNS lookup).
/// (Port of Hadidi-Win `BaseNetworkInfo`, dependency-free for the monorepo.)
abstract interface class BaseNetworkInfo {
  /// Stream of adapter-level connectivity changes.
  Stream<List<ConnectivityResult>> get connectivityChanged;

  /// `true` when at least one network adapter is active.
  /// Does NOT guarantee internet access.
  Future<bool> get isConnected;

  /// `true` when the device can actually reach the internet.
  Future<bool> get hasInternetAccess;
}

final class NetworkInfo implements BaseNetworkInfo {
  NetworkInfo(this._connectivity);

  final Connectivity _connectivity;

  /// How long a DNS-lookup result stays valid before re-probing.
  static const _cacheDuration = Duration(seconds: 5);
  DateTime? _lastCheckTime;
  bool _lastCheckResult = false;

  @override
  Stream<List<ConnectivityResult>> get connectivityChanged =>
      _connectivity.onConnectivityChanged;

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result.isNotEmpty && result.first != ConnectivityResult.none;
  }

  @override
  Future<bool> get hasInternetAccess async {
    // 1. Fast path: no adapter on → skip DNS lookup.
    if (!await isConnected) return false;

    // 2. Fresh cache → reuse.
    final now = DateTime.now();
    if (_lastCheckTime != null &&
        now.difference(_lastCheckTime!) < _cacheDuration) {
      return _lastCheckResult;
    }

    // 3. Real DNS probe.
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));
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
