import 'package:core_utils/core_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../utils/network/logic/cubit/network_cubit.dart';
import '../../utils/network/logic/cubit/network_state.dart';

class ConnectivityBanner extends HookWidget {
  const ConnectivityBanner({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDisconnected = useState(false);
    final toastItem = useRef<ToastificationItem?>(null);

    return BlocListener<NetworkCubit, NetworkState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        state.whenOrNull(
          disconnected: () {
            isDisconnected.value = true;
            toastItem.value = toastification.show(
              context: context,
              type: ToastificationType.error,
              style: ToastificationStyle.fillColored,
              title: Text(context.localeKeys.noInternetConnection),
              icon: const Icon(Iconsax.wifi_square_copy),
              alignment: Alignment.topCenter,
              showProgressBar: false,
            );
          },
          connected: () {
            if (isDisconnected.value) {
              isDisconnected.value = false;

              // Dismiss the error toast if it's still showing
              if (toastItem.value != null) {
                toastification.dismiss(toastItem.value!);
              }

              // Show the success toast
              toastification.show(
                context: context,
                type: ToastificationType.success,
                style: ToastificationStyle.fillColored,
                title: Text(context.localeKeys.internetConnectionRestored),
                icon: const Icon(Iconsax.wifi_copy),
                alignment: Alignment.topCenter,
                autoCloseDuration: const Duration(seconds: 3),
              );
            }
          },
        );
      },
      child: child,
    );
  }
}
