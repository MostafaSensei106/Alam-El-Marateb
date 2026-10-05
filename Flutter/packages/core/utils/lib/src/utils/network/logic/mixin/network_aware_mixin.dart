import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/network_cubit.dart';
import '../cubit/network_state.dart';

/// A mixin that allows any [Cubit] to observe network changes and react dynamically.
///
/// Implements an Observer pattern subscribing to [NetworkCubit].
/// Provides initial state resolution, lifecycle hooks ([onOnline], [onOffline]),
/// synchronous status queries ([isOnline]), and operation guards ([checkNetworkAndBlockIfOffline]).
mixin NetworkAwareMixin<State> on Cubit<State> {
  NetworkCubit? _networkCubit;
  StreamSubscription<NetworkState>? _networkSubscription;

  /// Returns the attached [NetworkCubit] instance, if observing.
  NetworkCubit? get networkCubit => _networkCubit;

  /// Returns whether the device is currently online.
  ///
  /// Evaluates [NetworkCubit]'s current state. Returns `true` if connected or initial/syncing,
  /// and `false` ONLY if explicitly disconnected.
  /// Includes fallback for unstubbed mock instances in unit tests.
  bool get isOnline {
    if (_networkCubit == null) return true;
    try {
      return _networkCubit!.isOnline;
    } catch (_) {
      return true;
    }
  }

  /// Starts observing network state changes from the provided [networkCubit].
  ///
  /// Immediately checks the initial state and invokes [onOffline] if already disconnected.
  void observeNetwork(NetworkCubit networkCubit) {
    if (isClosed) return;
    if (_networkCubit == networkCubit && _networkSubscription != null) {
      return;
    }
    unawaited(_networkSubscription?.cancel());
    _networkCubit = networkCubit;

    // Check initial state upon subscription
    if (!isOnline) {
      onOffline();
    }

    _networkSubscription = networkCubit.stream.listen((NetworkState state) {
      if (isClosed) return;
      state.when(
        initial: () {
          // Treat initial as online/syncing
        },
        connected: onOnline,
        disconnected: onOffline,
      );
    });
  }

  /// Lifecycle hook called when the network becomes available.
  /// Override this method in your Cubit to perform data re-fetching or recovery actions.
  void onOnline() {}

  /// Lifecycle hook called when the network is disconnected or when an offline operation is blocked.
  /// Override this method in your Cubit to handle offline UI state or error notifications.
  void onOffline() {}

  /// Checks network connectivity before proceeding with an operation.
  ///
  /// Returns `true` if online. If offline, returns `false`.
  bool checkNetworkAndBlockIfOffline() {
    return _networkCubit == null ||
        _networkCubit!.state.maybeWhen(
          connected: () => true,
          orElse: () => false,
        );
  }

  /// Overridable guard method to check if a network request is currently loading/in-progress.
  /// Used to guard against concurrent multi-tap request triggers.
  bool isRequestInProgress() => false;

  /// Combined guard for network operations and mutations.
  /// Returns `false` if a request is already in progress or if the network is offline.
  bool guardSubmission() {
    if (isRequestInProgress()) return false;
    return checkNetworkAndBlockIfOffline();
  }

  @override
  Future<void> close() async {
    await _networkSubscription?.cancel();
    _networkSubscription = null;
    _networkCubit = null;
    return super.close();
  }
}
