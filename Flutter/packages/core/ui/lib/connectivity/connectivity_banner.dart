import 'package:alam_el_marateb_network/network.dart';
import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:toastification/toastification.dart';

/// Shows error/success toasts on connectivity transitions.
///
/// Texts fall back to English — the app passes localized strings.
class ConnectivityBanner extends HookWidget {
  const ConnectivityBanner({
    required this.child,
    this.offlineText = 'No internet connection',
    this.restoredText = 'Internet connection restored',
    super.key,
  });

  final Widget child;
  final String offlineText;
  final String restoredText;

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
              title: Text(offlineText),
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
                title: Text(restoredText),
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
