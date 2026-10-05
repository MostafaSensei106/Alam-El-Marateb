import 'package:core_utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




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
    return BlocBuilder<NetworkCubit, NetworkState>(
      builder: (context, state) {
        return state.maybeWhen(
          disconnected: () => offlineBuilder(context),
          orElse: () => onlineBuilder(context),
        );
      },
    );
  }
}
