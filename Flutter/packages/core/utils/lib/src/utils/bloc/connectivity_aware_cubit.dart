import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../network/logic/cubit/network_cubit.dart';
import '../network/logic/cubit/network_state.dart';

/// A mixin for Cubits that need to automatically retry their failed network requests
/// when connectivity is restored.
mixin ConnectivityAwareCubit<State> on Cubit<State> {
  StreamSubscription<NetworkState>? _networkSubscription;

  /// Call this in the Cubit's constructor to start listening to network changes.
  void watchConnectivity(NetworkCubit networkCubit) {
    _networkSubscription = networkCubit.stream.listen((state) {
      state.whenOrNull(
        connected: () {
          if (isNetworkFailureState(this.state)) {
            retryRequest();
          }
        },
      );
    });
  }

  /// Override this to define what should happen when connectivity is restored.
  void retryRequest();

  /// Override this to determine if the current state represents a network failure.
  bool isNetworkFailureState(State state);

  /// Override this to clean up resources when the Cubit is closed.
  @override
  Future<void> close() async {
    await _networkSubscription?.cancel();
    return super.close();
  }

  /// Call this in the Cubit's constructor to stop listening to network changes.
  Future<void> stopWatchingConnectivity() async {
    await _networkSubscription?.cancel();
  }

  /// Call this in the Cubit's constructor to start listening to network changes.
  Future<void> startWatchingConnectivity(NetworkCubit networkCubit) async {
    _networkSubscription = networkCubit.stream.listen((state) {
      state.whenOrNull(
        connected: () {
          if (isNetworkFailureState(this.state)) {
            retryRequest();
          }
        },
      );
    });
  }
}
