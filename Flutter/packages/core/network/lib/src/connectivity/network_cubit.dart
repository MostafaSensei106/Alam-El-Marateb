import 'dart:async';

import 'package:bloc_signals/bloc_signals.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

import 'package:alam_el_marateb_network/src/connectivity/base_network_info.dart';
import 'package:alam_el_marateb_network/src/connectivity/network_state.dart';

@lazySingleton
class NetworkCubit extends CubitSignal<NetworkState> {
  NetworkCubit(this.networkInfo)
    : super(initialState: const NetworkState.initial()) {
    _subscription = networkInfo.connectivityChanged.listen(
      _onConnectivityEvent,
    );
    unawaited(_checkInitialConnectivity());
  }

  final BaseNetworkInfo networkInfo;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  /// Debounce timer to prevent rapid state flickering (e.g. in elevators).
  Timer? _debounceTimer;
  static const _debounceDuration = Duration(seconds: 2);

  /// Returns true if connected OR initial (optimistic online until verified offline).
  bool get isOnline =>
      stateValue.maybeWhen(disconnected: () => false, orElse: () => true);

  Future<void> _checkInitialConnectivity() async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isClosed && stateValue == const NetworkState.initial()) {
        _emitIfChanged(isConnected);
      }
    } catch (_) {
      // Ignore initial probe errors; state remains initial (optimistic online)
    }
  }

  /// Called by the Dio interceptor when a request succeeds or fails.
  void forceUpdateStatus({required bool isConnected}) {
    _debounceTimer?.cancel();
    _emitIfChanged(isConnected);
  }

  void _onConnectivityEvent(List<ConnectivityResult> results) {
    final isConnected =
        results.isNotEmpty && results.first != ConnectivityResult.none;

    if (stateValue == const NetworkState.initial()) {
      _debounceTimer?.cancel();
      _emitIfChanged(isConnected);
      return;
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      _emitIfChanged(isConnected);
    });
  }

  void _emitIfChanged(bool isConnected) {
    if (isClosed) return;

    final newState = isConnected
        ? const NetworkState.connected()
        : const NetworkState.disconnected();

    if (stateValue == newState) return;
    emit(newState);
  }

  @override
  Future<void> close() async {
    _debounceTimer?.cancel();
    await _subscription.cancel();
    return super.close();
  }
}
