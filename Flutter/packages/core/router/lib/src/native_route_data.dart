import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class NativeRouteData extends GoRouteData {
  const NativeRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state);

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final platform = Theme.of(context).platform;
    final child = build(context, state);

    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return CupertinoPage<void>(
        key: state.pageKey,
        name: state.name,
        arguments: state.extra,
        restorationId: state.pageKey.value,
        child: child,
      );
    }

    return MaterialPage<void>(
      key: state.pageKey,
      name: state.name,
      arguments: state.extra,
      restorationId: state.pageKey.value,
      child: child,
    );
  }
}
