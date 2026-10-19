import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';

import '../../modules/login/page/login_page.dart';
import '../../modules/main/main_page.dart';
import 'observers/app_navigator_observer.dart';
import 'routes/redirect.dart';

part 'routes/auth_routes.dart';
part 'routes/main_routes.dart';

sealed class AppRoute extends KaiselRoute {
  const AppRoute();
}

final class AppRouter {
  AppRouter._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  static AppRoute _initialRoute = const LoginRoute();

  static void setInitialRoute(AppRoute route) {
    _initialRoute = route;
  }

  static final config = KaiselRouterConfig<AppRoute>(
    navigatorKey: navigatorKey,
    initial: _initialRoute,
    observers: () => [AppNavigatorObserver()],
    guards: [authGuard],
    builder: (context, route) => switch (route) {
      LoginRoute() => const LoginPage(),
      RegisterRoute() => const _RoutePlaceholder(label: 'Register'),
      ResetPasswordRoute() => const _RoutePlaceholder(label: 'Reset Password'),
      MainRouteEntry() => const MainPage(),
    },
  );
}

final class _RoutePlaceholder extends StatelessWidget {
  const _RoutePlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(label)));
  }
}
