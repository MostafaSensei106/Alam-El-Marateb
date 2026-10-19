import 'package:flutter/material.dart';
import 'package:kaisel/kaisel.dart';

import '../../modules/login/page/login_page.dart';
import 'observers/app_navigator_observer.dart';
import 'routes/redirect.dart';

part 'routes/auth_routes.dart';
part 'routes/main_routes.dart';

sealed class AppRoute extends KaiselRoute {
  const AppRoute();
}

final class ForceUpdateRoute extends AppRoute {
  const ForceUpdateRoute({this.updateUrl});
  final String? updateUrl;
  @override
  List<Object?> get props => [updateUrl];
}

final class MaintenanceModeRoute extends AppRoute {
  const MaintenanceModeRoute();
  @override
  List<Object?> get props => [];
}

// Main Shell Branches
final class HomeRoute extends AppRoute {
  const HomeRoute();
  @override
  List<Object?> get props => [];
}

final class EstimatorRoute extends AppRoute {
  const EstimatorRoute();
  @override
  List<Object?> get props => [];
}

final class ProductsRoute extends AppRoute {
  const ProductsRoute();
  @override
  List<Object?> get props => [];
}

final class CartRoute extends AppRoute {
  const CartRoute();
  @override
  List<Object?> get props => [];
}

final class ProfileRoute extends AppRoute {
  const ProfileRoute();
  @override
  List<Object?> get props => [];
}

final class UserProfileRoute extends AppRoute {
  const UserProfileRoute();
  @override
  List<Object?> get props => [];
}

final class ShippingAddressesRoute extends AppRoute {
  const ShippingAddressesRoute();
  @override
  List<Object?> get props => [];
}

final class AddShippingAddressRoute extends AppRoute {
  const AddShippingAddressRoute();
  @override
  List<Object?> get props => [];
}

final class EditShippingAddressRoute extends AppRoute {
  const EditShippingAddressRoute();
  @override
  List<Object?> get props => [];
}

final class ShowcaseRoute extends AppRoute {
  const ShowcaseRoute();
  @override
  List<Object?> get props => [];
}

final class PaymentRoute extends AppRoute {
  const PaymentRoute();
  @override
  List<Object?> get props => [];
}

final class EditProfileRoute extends AppRoute {
  const EditProfileRoute();
  @override
  List<Object?> get props => [];
}

final class ChangePasswordRoute extends AppRoute {
  const ChangePasswordRoute();
  @override
  List<Object?> get props => [];
}

final class ChangePhoneNumberRoute extends AppRoute {
  const ChangePhoneNumberRoute();
  @override
  List<Object?> get props => [];
}

final class NotificationsRoute extends AppRoute {
  const NotificationsRoute();
  @override
  List<Object?> get props => [];
}

final class WishlistRoute extends AppRoute {
  const WishlistRoute();
  @override
  List<Object?> get props => [];
}

// Orders & Services
final class MyInvoicesRoute extends AppRoute {
  const MyInvoicesRoute();
  @override
  List<Object?> get props => [];
}

final class InvoiceDetailsRoute extends AppRoute {
  const InvoiceDetailsRoute();
  @override
  List<Object?> get props => [];
}

final class TrackOrderRoute extends AppRoute {
  const TrackOrderRoute();
  @override
  List<Object?> get props => [];
}

final class OrderDetailsRoute extends AppRoute {
  const OrderDetailsRoute();
  @override
  List<Object?> get props => [];
}

final class FullScreenImageViewerRoute extends AppRoute {
  const FullScreenImageViewerRoute();
  @override
  List<Object?> get props => [];
}

final class PdfViewerRoute extends AppRoute {
  const PdfViewerRoute();
  @override
  List<Object?> get props => [];
}

final class DigitalWarrantyRoute extends AppRoute {
  const DigitalWarrantyRoute();
  @override
  List<Object?> get props => [];
}

final class MaintenanceRequestRoute extends AppRoute {
  const MaintenanceRequestRoute();
  @override
  List<Object?> get props => [];
}

final class ProductDetailsRoute extends AppRoute {
  const ProductDetailsRoute({this.productId});
  final String? productId;
  @override
  List<Object?> get props => [productId];
}

final class SettingsRoute extends AppRoute {
  const SettingsRoute();
  @override
  List<Object?> get props => [];
}

final class LanguageRoute extends AppRoute {
  const LanguageRoute();
  @override
  List<Object?> get props => [];
}

final class FaqRoute extends AppRoute {
  const FaqRoute();
  @override
  List<Object?> get props => [];
}

final class HelpAndSupportRoute extends AppRoute {
  const HelpAndSupportRoute();
  @override
  List<Object?> get props => [];
}

final class PrivacyPolicyRoute extends AppRoute {
  const PrivacyPolicyRoute();
  @override
  List<Object?> get props => [];
}

final class TermsAndConditionsRoute extends AppRoute {
  const TermsAndConditionsRoute();
  @override
  List<Object?> get props => [];
}

final class AboutHadidiWinRoute extends AppRoute {
  const AboutHadidiWinRoute();
  @override
  List<Object?> get props => [];
}

final class AppRouter {
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
      ForceUpdateRoute(:final updateUrl) => _RoutePlaceholder(
        label: 'Force update${updateUrl == null ? '' : ': $updateUrl'}',
      ),
      MaintenanceModeRoute() => const _RoutePlaceholder(label: 'Maintenance'),

      _ => const _RoutePlaceholder(label: 'Home'),
    },
  );
}

/// Temporary stand-in until the routed screens are implemented under
/// `lib/modules`.
final class _RoutePlaceholder extends StatelessWidget {
  const _RoutePlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text(label)));
}
