import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core_network/core_network.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';

import 'network_state.dart';

@lazySingleton
class NetworkCubit extends Cubit<NetworkState> {
  NetworkCubit(this.networkInfo) : super(const NetworkState.initial()) {
    _subscription = networkInfo.connectivityChanged.listen(
      _onConnectivityEvent,
    );
    unawaited(_checkInitialConnectivity());
  }

  final BaseNetworkInfo networkInfo;
  late final StreamSubscription _subscription;

  /// Debounce timer to prevent rapid state flickering (e.g. in elevators).
  Timer? _debounceTimer;
  static const _debounceDuration = Duration(seconds: 2);

  /// Returns true if connected OR initial (optimistic online/syncing until verified offline).
  bool get isOnline =>
      state.maybeWhen(disconnected: () => false, orElse: () => true);

  Future<void> _checkInitialConnectivity() async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isClosed && state == const NetworkState.initial()) {
        _emitIfChanged(isConnected);
      }
    } catch (_) {
      // Ignore initial probe errors; state remains initial (optimistic online)
    }
  }

  /// Called by the Dio interceptor when a request succeeds or fails.
  void forceUpdateStatus({required bool isConnected}) {
    // Force updates bypass debounce — they come from actual HTTP results.
    _debounceTimer?.cancel();
    _emitIfChanged(isConnected);
  }

  void _onConnectivityEvent(List<ConnectivityResult> results) {
    final isConnected =
        results.isNotEmpty && results.first != ConnectivityResult.none;

    // Bypass debounce on initial stream event if state is still initial
    if (state == const NetworkState.initial()) {
      _debounceTimer?.cancel();
      _emitIfChanged(isConnected);
      return;
    }

    // Debounce subsequent connectivity stream events to avoid flickering.
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

    // Don't emit if state hasn't actually changed.
    if (state == newState) return;
    emit(newState);
  }

  @override
  Future<void> close() async {
    _debounceTimer?.cancel();
    await _subscription.cancel();
    return super.close();
  }
}
