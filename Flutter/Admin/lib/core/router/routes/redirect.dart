import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../constants/pref_keys.dart';
import '../../di/di.dart';
import '../../services/session/user_session_service.dart';
import '../../services/shared_prefs/base_pref_storage_service.dart';
import '../app_auth_notifier.dart';
import '../app_router.dart';

/// Routes that require user authentication.
final Set<String> _protectedRoutes = {
  AppRouter.userProfile,
  AppRouter.profile,
  AppRouter.editProfile,
  AppRouter.changePassword,
  AppRouter.changePhoneNumber,
  AppRouter.shippingAddresses,
  AppRouter.addShipingAddress,
  AppRouter.editShipingAddress,
  AppRouter.wishlist,
  AppRouter.myInvoices,
  AppRouter.invoiceDetails,
  AppRouter.trackOrder,
  AppRouter.orderDetails,
  AppRouter.digitalWarranty,
  AppRouter.maintenanceRequest,
  AppRouter.notifications,
  AppRouter.payment,
};

/// Routes restricted to unauthenticated users (Auth flow).
final Set<String> _authOnlyRoutes = {AppRouter.login, AppRouter.register};

/// Resolves the very first route the app should land on, at startup only.
Future<String> getStartLocation() async {
  final pref = getIt<BasePrefStorageService>();

  final hasSeenOnboarding =
      await pref.getData<bool>(key: PrefKeys.hasSeenOnboarding) ?? false;

  if (!hasSeenOnboarding) {
    // Prime as unauthenticated for onboarding
    AppAuthNotifier.instance.notifyAuthChanged(false);
    return AppRouter.onboarding;
  }

  // Hydrate session and prime memory cache BEFORE router builds
  final sessionService = getIt<BaseUserSessionService>();
  final isAuth = await sessionService.isAuthenticated();

  AppAuthNotifier.instance.notifyAuthChanged(isAuth);

  if (isAuth) {
    return AppRouter.home;
  }

  return AppRouter.login;
}

/// Global Auth Guard hook for GoRouter.
/// Runs synchronously on every navigation, reading cached auth state from [AppAuthNotifier].
String? authGuard(BuildContext context, GoRouterState state) {
  final location = state.matchedLocation;
  final isAuthenticated = AppAuthNotifier.instance.isAuthenticated;

  // System & Override Routes (Never block these)
  if (location == AppRouter.forceUpdate ||
      location == AppRouter.maintenanceMode ||
      location == AppRouter.onboarding) {
    return null;
  }

  final isProtected = _protectedRoutes.any(
    (route) => location == route || location.startsWith('$route/'),
  );

  final isAuthOnly = _authOnlyRoutes.any(
    (route) => location == route || location.startsWith('$route/'),
  );

  // 1. Unauthenticated user trying to access a protected route
  if (!isAuthenticated && isProtected) {
    // Preserve full target URI (including query parameters) for post-login redirect
    final targetUri = Uri.encodeComponent(state.uri.toString());
    return '${AppRouter.login}?from=$targetUri';
  }

  // 2. Authenticated user trying to access auth-only routes (like /login)
  if (isAuthenticated && isAuthOnly) {
    final from = state.uri.queryParameters['from'];
    if (from != null && from.isNotEmpty) {
      return Uri.decodeComponent(from);
    }
    return AppRouter.home;
  }

  return null;
}
