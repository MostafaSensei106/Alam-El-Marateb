import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// A pretty logger for GoRouter / Navigator
/// it will print push/pop/replace/remove info with the same pretty format
/// used by PrettyDioLogger.
final class AppNavigatorObserver extends NavigatorObserver {
  /// Default constructor
  AppNavigatorObserver({
    this.enabled = kDebugMode,
    this.maxWidth = 90,
    this.logPrint = print,
  });

  /// Enable logPrint
  final bool enabled;

  /// Width size per logPrint
  final int maxWidth;

  /// Log printer; defaults logPrint log to console.
  final void Function(Object object) logPrint;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (!enabled) return;

    final current = _extractRouteName(route);
    final previous = _extractRouteName(previousRoute);

    _printBoxed(header: 'Push ║ $current', text: 'from: $previous');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (!enabled) return;

    final current = _extractRouteName(route);
    final previous = _extractRouteName(previousRoute);

    _printBoxed(header: 'Pop ║ $current', text: 'returned to: $previous');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (!enabled) return;

    final newName = _extractRouteName(newRoute);
    final oldName = _extractRouteName(oldRoute);

    _printBoxed(header: 'Replace ║ $oldName ➔ $newName', text: '');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    if (!enabled) return;

    final removed = _extractRouteName(route);
    _printBoxed(header: 'Remove ║ $removed', text: '');
  }

  void _printBoxed({String? header, String? text}) {
    logPrint('');
    logPrint('╔╣ $header');
    logPrint('║  $text');
    _printLine('╚');
  }

  void _printLine([String pre = '', String suf = '╝']) =>
      logPrint('$pre${'═' * maxWidth}$suf');

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
