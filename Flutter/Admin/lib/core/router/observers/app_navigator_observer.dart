import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Production-ready [NavigatorObserver] for tracking screen views,
/// tab switches, and route transitions in GoRouter.
final class AppNavigatorObserver extends NavigatorObserver {
  AppNavigatorObserver({this.enableLogging = kDebugMode});

  /// Controls whether logging is active. Defaults to [kDebugMode].
  final bool enableLogging;

  static const String _logName = 'AppNav';

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (!enableLogging) return;

    final current = _extractRouteName(route);
    final previous = _extractRouteName(previousRoute);

    dev.log('➡️ PUSH: $current ${'(from: $previous)'}', name: _logName);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (!enableLogging) return;

    final current = _extractRouteName(route);
    final previous = _extractRouteName(previousRoute);

    dev.log('⬅️ POP: $current ${'(returned to: $previous)'}', name: _logName);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (!enableLogging) return;

    final newName = _extractRouteName(newRoute);
    final oldName = _extractRouteName(oldRoute);

    dev.log('🔄 REPLACE: $oldName ➔ $newName', name: _logName);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (!enableLogging) return;

    final removed = _extractRouteName(route);
    dev.log('❌ REMOVE: $removed', name: _logName);
  }

  /// Safely extracts route name, handling GoRouter paths, named routes, and Dialogs.
  String _extractRouteName(Route<dynamic>? route) {
    if (route == null) return 'none';

    final name = route.settings.name;
    if (name != null && name.isNotEmpty) {
      return name;
    }

    // Fallback for Dialogs / BottomSheets or unnamed GoRouter routes
    final typeName = route.runtimeType.toString();
    return route.settings.arguments != null
        ? '$typeName(args: ${route.settings.arguments})'
        : typeName;
  }
}
