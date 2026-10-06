import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/screens/login_screen.dart';
import '../features/catalog/screens/catalog_screen.dart';
import '../features/delivery/screens/trips_screen.dart';
import '../features/inventory/screens/stocks_screen.dart';
import '../features/inventory/screens/transfers_screen.dart';
import '../features/pos/screens/pos_screen.dart';
import '../features/shifts/screens/shift_screen.dart';
import '../features/warranty/screens/warranty_screen.dart';
import '../session/auth_state.dart';
import '../shell/role_modules_registry.dart';

/// Staff routes: every feature module owns its path constants here.
class StaffRouter {
  StaffRouter({required this._authState});

  final AuthState _authState;

  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String catalog = '/home/catalog';
  static const String pos = '/home/pos';
  static const String shifts = '/home/shifts';
  static const String stocks = '/home/stocks';
  static const String transfers = '/home/transfers';
  static const String delivery = '/home/delivery';
  static const String warranty = '/home/warranty';

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
        builder: (context, state) => const StaffHomeScreen(),
        routes: <RouteBase>[
          GoRoute(
            path: 'catalog',
            builder: (context, state) => const CatalogScreen(),
          ),
          GoRoute(path: 'pos', builder: (context, state) => const PosScreen()),
          GoRoute(
            path: 'shifts',
            builder: (context, state) => const ShiftScreen(),
          ),
          GoRoute(
            path: 'stocks',
            builder: (context, state) => const StocksScreen(),
          ),
          GoRoute(
            path: 'transfers',
            builder: (context, state) => const TransfersScreen(),
          ),
          GoRoute(
            path: 'delivery',
            builder: (context, state) => const TripsScreen(),
          ),
          GoRoute(
            path: 'warranty',
            builder: (context, state) => const WarrantyScreen(),
          ),
        ],
      ),
    ],
  );

  static String pathFor(StaffModule module) => switch (module) {
    StaffModule.catalog => catalog,
    StaffModule.pos => pos,
    StaffModule.shifts => shifts,
    StaffModule.inventory => stocks,
    StaffModule.transfers => transfers,
    StaffModule.delivery => delivery,
    StaffModule.warranty => warranty,
  };
}

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

/// Home: module grid filtered by the user's backend roles.
class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({super.key});

  @override
  State<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {
  List<StaffModule> _modules = StaffModule.values;

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    try {
      final me = await GetIt.instance<AuthApi>().me();
      final roles = me.data?.roles ?? const <String>[];
      if (mounted) {
        setState(() => _modules = RoleModulesRegistry.forRoles(roles));
      }
    } on Exception {
      // Offline or expired session: keep the full grid; backend enforces.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.6,
        ),
        itemCount: _modules.length,
        itemBuilder: (context, i) {
          final module = _modules[i];
          return Card(
            child: InkWell(
              onTap: () => context.go(StaffRouter.pathFor(module)),
              child: Center(child: Text(module.label)),
            ),
          );
        },
      ),
    );
  }
}
