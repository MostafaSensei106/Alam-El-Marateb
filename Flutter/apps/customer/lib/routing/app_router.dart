import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/cart/screens/cart_screen.dart';
import '../features/cart/screens/orders_screen.dart';
import '../features/catalog/screens/catalog_screen.dart';
import '../features/catalog/screens/product_details_screen.dart';
import '../features/portal/screens/account_screen.dart';
import '../session/auth_state.dart';

/// Customer routes with bottom-nav shell.
class CustomerRouter {
  CustomerRouter({required this._authState});

  final AuthState _authState;

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  late final GoRouter router = GoRouter(
    initialLocation: splash,
    refreshListenable: _authState,
    redirect: (context, state) {
      if (!_authState.isReady) {
        return splash;
      }
      final public = state.matchedLocation == login ||
          state.matchedLocation == register;
      if (!_authState.isLoggedIn) {
        return public ? null : login;
      }
      if (public || state.matchedLocation == splash) {
        return home;
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => CustomerShell(shell: shell),
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: home,
                builder: (context, state) => const CatalogScreen(),
                routes: <RouteBase>[
                  GoRoute(
                    path: 'product/:slug',
                    builder: (context, state) => ProductDetailsScreen(
                      slug: state.pathParameters['slug'] ?? '',
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/cart',
                builder: (context, state) => const CartScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/orders',
                builder: (context, state) => const OrdersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/account',
                builder: (context, state) => const AccountScreen(),
              ),
            ],
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
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class CustomerShell extends StatelessWidget {
  const CustomerShell({required this.shell, super.key});

  final StatefulNavigationShell shell;

  void _go(int index) => shell.goBranch(index, initialLocation: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: shell.currentIndex,
        onTap: _go,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
