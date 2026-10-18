import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'app_auth_notifier.dart';
import 'native_route_data.dart';
import 'observers/app_navigator_observer.dart';
import 'routes/redirect.dart';

part 'app_router.g.dart';
part 'routes/auth_routes.dart';
part 'routes/main_routes.dart';
part 'routes/settings_info_routes.dart';
part 'routes/user_routes.dart';

final class AppRouter {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static const String root = '/';
  static const String onboarding = '/onboarding';
  static const String forceUpdate = '/forceUpdate';
  static const String maintenanceMode = '/maintenanceMode';

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgotPassword';
  static const String resetPassword = '/resetPassword';
  static const String otp = '/otp';

  // Main Shell Branches
  static const String home = '/home';
  static const String estimator = '/estimator';
  static const String products = '/products';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String userProfile = '/userProfile';
  static const String shippingAddresses = '/shippingAddresses';
  static const String addShipingAddress = '/addShipingAddress';
  static const String editShipingAddress = '/editShipingAddress';
  static const String showcase = '/showcase';

  static const String payment = '/payment';

  // Profile & User Actions
  static const String editProfile = '/editProfile';
  static const String changePassword = '/changePassword';
  static const String changePhoneNumber = '/changePhoneNumber';
  static const String notifications = '/notifications';
  static const String wishlist = '/wishlist';

  // Orders & Services
  static const String myInvoices = '/myInvoices';
  static const String invoiceDetails = '/invoiceDetails';
  static const String trackOrder = '/trackOrder';
  static const String orderDetails = '/orderDetails';
  static const String fullScreenImageViewer = '/fullScreenImageViewer';
  static const String pdfViewer = '/pdfViewer';
  static const String digitalWarranty = '/digtalWarranty';
  static const String maintenanceRequest = '/maintenanceRequest';

  // Product Details
  static const String product = '/product';

  // Settings & Info
  static const String settings = '/settings';
  static const String language = '/language';
  static const String faq = '/faq';
  static const String helpAndSupport = '/helpAndSupport';

  // Legal
  static const String privacyPolicy = '/privacyPolicy';
  static const String termsAndConditions = '/termsAndConditions';
  static const String aboutHadidiWin = '/aboutHadidiWin';

  static final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: _initialLocation,
    debugLogDiagnostics: true,
    restorationScopeId: 'app_router',
    refreshListenable: AppAuthNotifier.instance,
    observers: [AppNavigatorObserver()],
    redirect: authGuard,
    routes: [...$appRoutes],
  );

  static late String _initialLocation;

  static void setInitialLocation(String value) {
    _initialLocation = value;
  }
}

@TypedGoRoute<OnboardingRoute>(path: AppRouter.onboarding)
final class OnboardingRoute extends NativeRouteData with $OnboardingRoute {
  const OnboardingRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OnboardingPage();
}

@TypedGoRoute<ForceUpdateRoute>(path: AppRouter.forceUpdate)
final class ForceUpdateRoute extends NativeRouteData with $ForceUpdateRoute {
  const ForceUpdateRoute({this.updateUrl});
  final String? updateUrl;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ForceUpdatePage(updateUrl: updateUrl);
}

@TypedGoRoute<MaintenanceModeRoute>(path: AppRouter.maintenanceMode)
final class MaintenanceModeRoute extends NativeRouteData
    with $MaintenanceModeRoute {
  const MaintenanceModeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const MaintenanceModePage();
}
