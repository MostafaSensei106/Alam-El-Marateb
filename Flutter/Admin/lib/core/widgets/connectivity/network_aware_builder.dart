import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';

import '../../utils/network/logic/cubit/network_cubit.dart';
import '../../utils/network/logic/cubit/network_state.dart';

/// A widget that builds its child based on the current network state.
/// Useful for full-screen offline states.
class NetworkAwareBuilder extends StatelessWidget {
  const NetworkAwareBuilder({
    required this.onlineBuilder,
    required this.offlineBuilder,
    super.key,
  });

  final WidgetBuilder onlineBuilder;
  final WidgetBuilder offlineBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocSignalBuilder<NetworkCubit, NetworkState>(
      builder: (context, state) {
        return state.maybeWhen(
          disconnected: () => offlineBuilder(context),
          orElse: () => onlineBuilder(context),
        );
      },
    );
  }
}
