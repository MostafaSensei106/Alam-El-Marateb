import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../session/auth_state.dart';

/// App routes. Feature modules register their own sub-routes here
/// as they land (auth first) — the shell stays thin.
class CustomerRouter {
  CustomerRouter({required this._authState});

  final AuthState _authState;

  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';

  late final GoRouter router = GoRouter(
    initialLocation: splash,
    refreshListenable: _authState,
    redirect: (context, state) {
      if (!_authState.isReady) {
        return splash;
      }
      final loggingIn = state.matchedLocation == login;
      if (!_authState.isLoggedIn) {
        return loggingIn ? null : login;
      }
      if (loggingIn || state.matchedLocation == splash) {
        return home;
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(path: splash, builder: (context, state) => const SplashPage()),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginPlaceholderPage(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const CustomerHomePlaceholderPage(),
      ),
    ],
  );
}

/// Placeholder until design_system + modules/auth UI land.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

/// Placeholder: replaced by modules/auth login page in Slice 2.
class LoginPlaceholderPage extends StatelessWidget {
  const LoginPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Customer login — modules/auth UI lands here')),
    );
  }
}

/// Placeholder: staff shell + role_modules_registry plug in here.
class CustomerHomePlaceholderPage extends StatelessWidget {
  const CustomerHomePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Customer home — role modules plug in here')),
    );
  }
}
