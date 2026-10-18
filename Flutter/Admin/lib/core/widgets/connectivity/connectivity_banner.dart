import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:toastification/toastification.dart';

import '../../extensions/extensions.dart';
import '../../utils/network/logic/cubit/network_cubit.dart';
import '../../utils/network/logic/cubit/network_state.dart';

class ConnectivityBanner extends HookWidget {
  const ConnectivityBanner({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDisconnected = useState(false);
    final toastItem = useRef<ToastificationItem?>(null);

    return BlocSignalListener<NetworkCubit, NetworkState>(
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
              icon: Icon(LucideIcons.wifi_square_copy),
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
                icon: const Icon(LucideIcons.wifi_copy),
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
