import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

import 'package:alam_el_marateb_network/src/connectivity/base_network_info.dart';

@LazySingleton(as: BaseNetworkInfo)
class NetworkInfo implements BaseNetworkInfo {
  NetworkInfo(this.connectivity);
  final Connectivity connectivity;

  static const _cacheDuration = Duration(seconds: 5);
  DateTime? _lastCheckTime;
  bool _lastCheckResult = false;

  @override
  Stream<List<ConnectivityResult>> get connectivityChanged =>
      connectivity.onConnectivityChanged;

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result.isNotEmpty && result.first != ConnectivityResult.none;
  }

  @override
  Future<bool> get hasInternetAccess async {
    if (!await isConnected) return false;

    final now = DateTime.now();
    if (_lastCheckTime != null &&
        now.difference(_lastCheckTime!) < _cacheDuration) {
      return _lastCheckResult;
    }

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
