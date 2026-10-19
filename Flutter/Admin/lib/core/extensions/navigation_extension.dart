import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:kaisel/kaisel.dart';

/// Terse navigation helpers shared across the app.
extension AppNavigationExtensions on BuildContext {
  /// Pops the top-most dismissible layer.
  ///
  /// Mirrors Kaisel's back navigation: an imperative overlay ([Dialog], bottom
  /// sheet, [Drawer]) or a [PopScope] veto is handled first, and only then the
  /// enclosing Kaisel route stack is popped. Does nothing when there is
  /// nothing left to pop.
  ///
  /// Fire-and-forget by design, so call sites stay as terse as `context.pop()`.
  void pop<T extends Object?>([T? result]) => unawaited(_safePop(this, result));
}

Future<void> _safePop(BuildContext context, Object? result) async {
  try {
    await context.maybePop(result);
  } on FlutterError {
    // No Kaisel router above this context (e.g. isolated widget tests).
  }
}
