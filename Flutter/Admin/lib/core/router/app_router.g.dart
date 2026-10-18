// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $onboardingRoute,
  $forceUpdateRoute,
  $maintenanceModeRoute,
  $loginRoute,
  $registerRoute,
  $forgetPasswordRoute,
  $mainRoute,
  $productDetailsRoute,
  $languageRoute,
  $digitalWarrantyRoute,
  $maintenanceRequestRoute,
  $fAQsRoute,
  $helpAndSupportRoute,
  $privacyPolicyRoute,
  $termsAndConditionsRoute,
  $aboutHadidiWinRoute,
  $profileRoute,
  $editProfileRoute,
  $wishlistRoute,
  $myInvoicesRoute,
  $invoiceDetailsRoute,
  $trackOrderRoute,
  $orderDetailsRoute,
  $shipingAddressesRoute,
  $addShipingAddressRoute,
  $editShippingAddressRoute,
  $notificationRoute,
  $fullScreenImageViewerRoute,
  $pdfViewerPageRoute,
];

RouteBase get $onboardingRoute => GoRouteData.$route(
  path: '/onboarding',
  hasOverriddenOnExit: false,
  factory: $OnboardingRoute._fromState,
);

mixin $OnboardingRoute on GoRouteData {
  static OnboardingRoute _fromState(GoRouterState state) =>
      const OnboardingRoute();

  @override
  String get location => GoRouteData.$location('/onboarding');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $forceUpdateRoute => GoRouteData.$route(
  path: '/forceUpdate',
  hasOverriddenOnExit: false,
  factory: $ForceUpdateRoute._fromState,
);

mixin $ForceUpdateRoute on GoRouteData {
  static ForceUpdateRoute _fromState(GoRouterState state) =>
      ForceUpdateRoute(updateUrl: state.uri.queryParameters['update-url']);

  ForceUpdateRoute get _self => this as ForceUpdateRoute;

  @override
  String get location => GoRouteData.$location(
    '/forceUpdate',
    queryParams: {if (_self.updateUrl != null) 'update-url': _self.updateUrl},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $maintenanceModeRoute => GoRouteData.$route(
  path: '/maintenanceMode',
  hasOverriddenOnExit: false,
  factory: $MaintenanceModeRoute._fromState,
);

mixin $MaintenanceModeRoute on GoRouteData {
  static MaintenanceModeRoute _fromState(GoRouterState state) =>
      const MaintenanceModeRoute();

  @override
  String get location => GoRouteData.$location('/maintenanceMode');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute => GoRouteData.$route(
  path: '/login',
  hasOverriddenOnExit: false,
  factory: $LoginRoute._fromState,
);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $registerRoute => GoRouteData.$route(
  path: '/register',
  hasOverriddenOnExit: false,
  factory: $RegisterRoute._fromState,
);

mixin $RegisterRoute on GoRouteData {
  static RegisterRoute _fromState(GoRouterState state) => const RegisterRoute();

  @override
  String get location => GoRouteData.$location('/register');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $forgetPasswordRoute => GoRouteData.$route(
  path: '/forgotPassword',
  hasOverriddenOnExit: false,
  factory: $ForgetPasswordRoute._fromState,
);

mixin $ForgetPasswordRoute on GoRouteData {
  static ForgetPasswordRoute _fromState(GoRouterState state) =>
      const ForgetPasswordRoute();

  @override
  String get location => GoRouteData.$location('/forgotPassword');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $mainRoute => StatefulShellRouteData.$route(
  factory: $MainRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/home',
          hasOverriddenOnExit: false,
          factory: $HomeRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/estimator',
          hasOverriddenOnExit: false,
          factory: $EstimatorRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/products',
          hasOverriddenOnExit: false,
          factory: $ProductsRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/cart',
          hasOverriddenOnExit: false,
          factory: $CartRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/settings',
          hasOverriddenOnExit: false,
          factory: $SettingsRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $MainRouteExtension on MainRoute {
  static MainRoute _fromState(GoRouterState state) => const MainRoute();
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $EstimatorRoute on GoRouteData {
  static EstimatorRoute _fromState(GoRouterState state) =>
      const EstimatorRoute();

  @override
  String get location => GoRouteData.$location('/estimator');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProductsRoute on GoRouteData {
  static ProductsRoute _fromState(GoRouterState state) => const ProductsRoute();

  @override
  String get location => GoRouteData.$location('/products');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CartRoute on GoRouteData {
  static CartRoute _fromState(GoRouterState state) => const CartRoute();

  @override
  String get location => GoRouteData.$location('/cart');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $productDetailsRoute => GoRouteData.$route(
  path: '/product',
  hasOverriddenOnExit: false,
  factory: $ProductDetailsRoute._fromState,
);

mixin $ProductDetailsRoute on GoRouteData {
  static ProductDetailsRoute _fromState(GoRouterState state) =>
      ProductDetailsRoute($extra: state.extra as ProductItem);

  ProductDetailsRoute get _self => this as ProductDetailsRoute;

  @override
  String get location => GoRouteData.$location('/product');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $languageRoute => GoRouteData.$route(
  path: '/language',
  hasOverriddenOnExit: false,
  factory: $LanguageRoute._fromState,
);

mixin $LanguageRoute on GoRouteData {
  static LanguageRoute _fromState(GoRouterState state) => const LanguageRoute();

  @override
  String get location => GoRouteData.$location('/language');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $digitalWarrantyRoute => GoRouteData.$route(
  path: '/digtalWarranty',
  hasOverriddenOnExit: false,
  factory: $DigitalWarrantyRoute._fromState,
);

mixin $DigitalWarrantyRoute on GoRouteData {
  static DigitalWarrantyRoute _fromState(GoRouterState state) =>
      const DigitalWarrantyRoute();

  @override
  String get location => GoRouteData.$location('/digtalWarranty');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $maintenanceRequestRoute => GoRouteData.$route(
  path: '/maintenanceRequest',
  hasOverriddenOnExit: false,
  factory: $MaintenanceRequestRoute._fromState,
);

mixin $MaintenanceRequestRoute on GoRouteData {
  static MaintenanceRequestRoute _fromState(GoRouterState state) =>
      const MaintenanceRequestRoute();

  @override
  String get location => GoRouteData.$location('/maintenanceRequest');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $fAQsRoute => GoRouteData.$route(
  path: '/faq',
  hasOverriddenOnExit: false,
  factory: $FAQsRoute._fromState,
);

mixin $FAQsRoute on GoRouteData {
  static FAQsRoute _fromState(GoRouterState state) => const FAQsRoute();

  @override
  String get location => GoRouteData.$location('/faq');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $helpAndSupportRoute => GoRouteData.$route(
  path: '/helpAndSupport',
  hasOverriddenOnExit: false,
  factory: $HelpAndSupportRoute._fromState,
);

mixin $HelpAndSupportRoute on GoRouteData {
  static HelpAndSupportRoute _fromState(GoRouterState state) =>
      const HelpAndSupportRoute();

  @override
  String get location => GoRouteData.$location('/helpAndSupport');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $privacyPolicyRoute => GoRouteData.$route(
  path: '/privacyPolicy',
  hasOverriddenOnExit: false,
  factory: $PrivacyPolicyRoute._fromState,
);

mixin $PrivacyPolicyRoute on GoRouteData {
  static PrivacyPolicyRoute _fromState(GoRouterState state) =>
      const PrivacyPolicyRoute();

  @override
  String get location => GoRouteData.$location('/privacyPolicy');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $termsAndConditionsRoute => GoRouteData.$route(
  path: '/termsAndConditions',
  hasOverriddenOnExit: false,
  factory: $TermsAndConditionsRoute._fromState,
);

mixin $TermsAndConditionsRoute on GoRouteData {
  static TermsAndConditionsRoute _fromState(GoRouterState state) =>
      const TermsAndConditionsRoute();

  @override
  String get location => GoRouteData.$location('/termsAndConditions');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $aboutHadidiWinRoute => GoRouteData.$route(
  path: '/aboutHadidiWin',
  hasOverriddenOnExit: false,
  factory: $AboutHadidiWinRoute._fromState,
);

mixin $AboutHadidiWinRoute on GoRouteData {
  static AboutHadidiWinRoute _fromState(GoRouterState state) =>
      const AboutHadidiWinRoute();

  @override
  String get location => GoRouteData.$location('/aboutHadidiWin');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $profileRoute => GoRouteData.$route(
  path: '/userProfile',
  hasOverriddenOnExit: false,
  factory: $ProfileRoute._fromState,
);

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location('/userProfile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editProfileRoute => GoRouteData.$route(
  path: '/editProfile',
  hasOverriddenOnExit: false,
  factory: $EditProfileRoute._fromState,
);

mixin $EditProfileRoute on GoRouteData {
  static EditProfileRoute _fromState(GoRouterState state) =>
      const EditProfileRoute();

  @override
  String get location => GoRouteData.$location('/editProfile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $wishlistRoute => GoRouteData.$route(
  path: '/wishlist',
  hasOverriddenOnExit: false,
  factory: $WishlistRoute._fromState,
);

mixin $WishlistRoute on GoRouteData {
  static WishlistRoute _fromState(GoRouterState state) => const WishlistRoute();

  @override
  String get location => GoRouteData.$location('/wishlist');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $myInvoicesRoute => GoRouteData.$route(
  path: '/myInvoices',
  hasOverriddenOnExit: false,
  factory: $MyInvoicesRoute._fromState,
);

mixin $MyInvoicesRoute on GoRouteData {
  static MyInvoicesRoute _fromState(GoRouterState state) =>
      const MyInvoicesRoute();

  @override
  String get location => GoRouteData.$location('/myInvoices');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $invoiceDetailsRoute => GoRouteData.$route(
  path: '/invoiceDetails',
  hasOverriddenOnExit: false,
  factory: $InvoiceDetailsRoute._fromState,
);

mixin $InvoiceDetailsRoute on GoRouteData {
  static InvoiceDetailsRoute _fromState(GoRouterState state) =>
      InvoiceDetailsRoute(
        invoiceId: int.parse(state.uri.queryParameters['invoice-id']!),
      );

  InvoiceDetailsRoute get _self => this as InvoiceDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/invoiceDetails',
    queryParams: {'invoice-id': _self.invoiceId.toString()},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $trackOrderRoute => GoRouteData.$route(
  path: '/trackOrder',
  hasOverriddenOnExit: false,
  factory: $TrackOrderRoute._fromState,
);

mixin $TrackOrderRoute on GoRouteData {
  static TrackOrderRoute _fromState(GoRouterState state) =>
      const TrackOrderRoute();

  @override
  String get location => GoRouteData.$location('/trackOrder');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $orderDetailsRoute => GoRouteData.$route(
  path: '/orderDetails',
  hasOverriddenOnExit: false,
  factory: $OrderDetailsRoute._fromState,
);

mixin $OrderDetailsRoute on GoRouteData {
  static OrderDetailsRoute _fromState(GoRouterState state) => OrderDetailsRoute(
    orderId: int.parse(state.uri.queryParameters['order-id']!),
  );

  OrderDetailsRoute get _self => this as OrderDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/orderDetails',
    queryParams: {'order-id': _self.orderId.toString()},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $shipingAddressesRoute => GoRouteData.$route(
  path: '/shippingAddresses',
  hasOverriddenOnExit: false,
  factory: $ShipingAddressesRoute._fromState,
);

mixin $ShipingAddressesRoute on GoRouteData {
  static ShipingAddressesRoute _fromState(GoRouterState state) =>
      const ShipingAddressesRoute();

  @override
  String get location => GoRouteData.$location('/shippingAddresses');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $addShipingAddressRoute => GoRouteData.$route(
  path: '/addShipingAddress',
  hasOverriddenOnExit: false,
  factory: $AddShipingAddressRoute._fromState,
);

mixin $AddShipingAddressRoute on GoRouteData {
  static AddShipingAddressRoute _fromState(GoRouterState state) =>
      const AddShipingAddressRoute();

  @override
  String get location => GoRouteData.$location('/addShipingAddress');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editShippingAddressRoute => GoRouteData.$route(
  path: '/editShipingAddress',
  hasOverriddenOnExit: false,
  factory: $EditShippingAddressRoute._fromState,
);

mixin $EditShippingAddressRoute on GoRouteData {
  static EditShippingAddressRoute _fromState(GoRouterState state) =>
      EditShippingAddressRoute($extra: state.extra as ListShippingAddresseData);

  EditShippingAddressRoute get _self => this as EditShippingAddressRoute;

  @override
  String get location => GoRouteData.$location('/editShipingAddress');

  @override
  void go(BuildContext context) => context.go(location, extra: _self.$extra);

  @override
  Future<T?> push<T>(BuildContext context) =>
      context.push<T>(location, extra: _self.$extra);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location, extra: _self.$extra);

  @override
  void replace(BuildContext context) =>
      context.replace(location, extra: _self.$extra);
}

RouteBase get $notificationRoute => GoRouteData.$route(
  path: '/notifications',
  hasOverriddenOnExit: false,
  factory: $NotificationRoute._fromState,
);

mixin $NotificationRoute on GoRouteData {
  static NotificationRoute _fromState(GoRouterState state) =>
      const NotificationRoute();

  @override
  String get location => GoRouteData.$location('/notifications');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $fullScreenImageViewerRoute => GoRouteData.$route(
  path: '/fullScreenImageViewer',
  hasOverriddenOnExit: false,
  factory: $FullScreenImageViewerRoute._fromState,
);

mixin $FullScreenImageViewerRoute on GoRouteData {
  static FullScreenImageViewerRoute _fromState(GoRouterState state) =>
      FullScreenImageViewerRoute(
        imageUrl: state.uri.queryParameters['image-url']!,
        orderId: state.uri.queryParameters['order-id']!,
        caption: state.uri.queryParameters['caption'],
      );

  FullScreenImageViewerRoute get _self => this as FullScreenImageViewerRoute;

  @override
  String get location => GoRouteData.$location(
    '/fullScreenImageViewer',
    queryParams: {
      'image-url': _self.imageUrl,
      'order-id': _self.orderId,
      if (_self.caption != null) 'caption': _self.caption,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $pdfViewerPageRoute => GoRouteData.$route(
  path: '/pdfViewer',
  hasOverriddenOnExit: false,
  factory: $PdfViewerPageRoute._fromState,
);

mixin $PdfViewerPageRoute on GoRouteData {
  static PdfViewerPageRoute _fromState(GoRouterState state) =>
      PdfViewerPageRoute(
        pdfUrl: state.uri.queryParameters['pdf-url']!,
        orderId: state.uri.queryParameters['order-id']!,
        caption: state.uri.queryParameters['caption'],
      );

  PdfViewerPageRoute get _self => this as PdfViewerPageRoute;

  @override
  String get location => GoRouteData.$location(
    '/pdfViewer',
    queryParams: {
      'pdf-url': _self.pdfUrl,
      'order-id': _self.orderId,
      if (_self.caption != null) 'caption': _self.caption,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
