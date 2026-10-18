import 'package:flutter/widgets.dart';

/// Observes app lifecycle and wipes in-memory secrets when the app
/// goes to background.
///
/// Usage:
/// ```dart
/// final guard = SessionMemoryGuard(onBackgrounded: () async {
///   await userSessionService.onAppBackgrounded();
/// });
/// WidgetsBinding.instance.addObserver(guard);
/// ```
final class SessionMemoryGuard extends WidgetsBindingObserver {
  SessionMemoryGuard({required this.onBackgrounded});

  final Future<void> Function() onBackgrounded;

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      await onBackgrounded();
    }
  }
}
