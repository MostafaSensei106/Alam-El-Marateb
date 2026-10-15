import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_state.freezed.dart';

@freezed
class NetworkState with _$NetworkState {
  const factory NetworkState.initial() = _Initial;
  const factory NetworkState.connected() = _Connected;
  const factory NetworkState.disconnected() = _Disconnected;
}

extension NetworkStateX on NetworkState {
  bool get isOnline => maybeWhen(disconnected: () => false, orElse: () => true);
  bool get isOffline => this is _Disconnected;
  bool get isInitial => this is _Initial;
}
