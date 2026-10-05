import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstraction over network-connectivity checks.
///
/// [isConnected] checks whether a network adapter is enabled (WiFi, mobile).
/// [hasInternetAccess] performs a real reachability probe (DNS lookup).
abstract interface class BaseNetworkInfo {
  /// Stream of adapter-level connectivity changes.
  Stream<List<ConnectivityResult>> get connectivityChanged;

  /// `true` when at least one network adapter (WiFi, mobile, ethernet) is active.
  ///
  /// **Does NOT guarantee internet access** — use [hasInternetAccess] for that.
  Future<bool> get isConnected;

  /// `true` when the device can actually reach the internet.
  ///
  /// Performs a lightweight DNS lookup with a short timeout. Results are cached
  /// briefly to avoid hammering the resolver on rapid successive calls.
  Future<bool> get hasInternetAccess;
}
