import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/finance/screens/finance_screen.dart';
import '../features/identity/screens/users_screen.dart';
import '../features/pricing/screens/price_sheets_screen.dart';
import '../session/auth_state.dart';

/// Admin console routes.
class AdminRouter {
  AdminRouter({required this._authState});

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
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: home,
        builder: (context, state) => const AdminHomeScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: 'pricing',
            builder: (context, state) => const PriceSheetsScreen(),
          ),
          GoRoute(
            path: 'finance',
            builder: (context, state) => const FinanceScreen(),
          ),
          GoRoute(
            path: 'users',
            builder: (context, state) => const UsersScreen(),
          ),
        ],
      ),
    ],
  );
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

enum AdminSection {
  dashboard('Dashboard', '/home/dashboard'),
  pricing('Pricing', '/home/pricing'),
  finance('Finance', '/home/finance'),
  users('Users', '/home/users');

  const AdminSection(this.label, this.path);
  final String label;
  final String path;
}

/// Admin console: section grid.
class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin console')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.6,
        ),
        itemCount: AdminSection.values.length,
        itemBuilder: (context, i) {
          final section = AdminSection.values[i];
          return Card(
            child: InkWell(
              onTap: () => context.go(section.path),
              child: Center(child: Text(section.label)),
            ),
          );
        },
      ),
    );
  }
}
