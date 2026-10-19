import 'dart:async';

import '../../constants/pref_keys.dart';
import '../../di/di.dart';
import '../../services/session/user_session_service.dart';
import '../../services/shared_prefs/base_pref_storage_service.dart';
import '../app_auth_notifier.dart';
import '../app_router.dart';

bool _isProtectedRoute(AppRoute route) {
  return route is UserProfileRoute ||
      route is ProfileRoute ||
      route is EditProfileRoute ||
      route is ChangePasswordRoute ||
      route is ChangePhoneNumberRoute ||
      route is ShippingAddressesRoute ||
      route is AddShippingAddressRoute ||
      route is EditShippingAddressRoute ||
      route is WishlistRoute ||
      route is MyInvoicesRoute ||
      route is InvoiceDetailsRoute ||
      route is TrackOrderRoute ||
      route is OrderDetailsRoute ||
      route is DigitalWarrantyRoute ||
      route is MaintenanceRequestRoute ||
      route is NotificationsRoute ||
      route is PaymentRoute;
}

bool _isAuthOnlyRoute(AppRoute route) {
  return route is LoginRoute || route is RegisterRoute;
}

Future<AppRoute> getStartRoute() async {
  final pref = getIt<BasePrefStorageService>();

  final hasSeenOnboarding =
      await pref.getData<bool>(key: PrefKeys.hasSeenOnboarding) ?? false;

  if (!hasSeenOnboarding) {
    AppAuthNotifier.instance.notifyAuthChanged(false);
    return const LoginRoute();
  }

  final sessionService = getIt<BaseUserSessionService>();
  final isAuth = await sessionService.isAuthenticated();

  AppAuthNotifier.instance.notifyAuthChanged(isAuth);

  if (isAuth) {
    return const HomeRoute();
  }

  return const LoginRoute();
}

List<AppRoute> authGuard(List<AppRoute> current, List<AppRoute> proposed) {
  if (proposed.isEmpty) return proposed;

  final target = proposed.last;
  final isAuthenticated = AppAuthNotifier.instance.isAuthenticated;

  // System & Override Routes (Never block these)
  if (target is ForceUpdateRoute || target is MaintenanceModeRoute) {
    return proposed;
  }

  final isProtected = _isProtectedRoute(target);
  final isAuthOnly = _isAuthOnlyRoute(target);

  if (!isAuthenticated && isProtected) {
    return [LoginRoute(redirectTarget: target)];
  }

  if (isAuthenticated && isAuthOnly) {
    return [const HomeRoute()];
  }

  return proposed;
}
