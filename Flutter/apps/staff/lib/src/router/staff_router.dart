import 'package:alam_el_marateb_router/router.dart';
import 'package:auth/auth.dart';
import 'package:go_router/go_router.dart';

import '../pages/home_page.dart';

/// Staff router: `/login` (shared page) + `/home` (role page).
///
/// The redirect guard reads the synchronously-primed [AppAuthNotifier]
/// (see `primeAuthState()` in main) — no async storage reads during
/// navigation, no login flicker.
GoRouter buildStaffRouter() {
  return GoRouter(
    initialLocation: '/home',
    refreshListenable: AppAuthNotifier.instance,
    observers: [AppNavigatorObserver()],
    redirect: (context, state) {
      final authed = AppAuthNotifier.instance.isAuthenticated;
      final loggingIn = state.matchedLocation == '/login';
      if (!authed && !loggingIn) return '/login';
      if (authed && loggingIn) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(
          onAuthenticated: () => context.go('/home'),
        ),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const StaffHomePage(),
      ),
    ],
  );
}
