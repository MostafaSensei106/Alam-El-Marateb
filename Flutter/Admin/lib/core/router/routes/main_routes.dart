part of '../app_router.dart';

sealed class MainRoute extends AppRoute {
  const MainRoute();
}

final class MainRouteEntry extends MainRoute {
  const MainRouteEntry();

  @override
  List<Object?> get props => [];
}

sealed class DashboardRoute extends KaiselRoute {
  const DashboardRoute();
}

final class DashboardRoot extends DashboardRoute {
  const DashboardRoot();

  @override
  List<Object?> get props => [];
}

sealed class IdentityRoute extends KaiselRoute {
  const IdentityRoute();
}

final class IdentityRoot extends IdentityRoute {
  const IdentityRoot();

  @override
  List<Object?> get props => [];
}

sealed class CatalogRoute extends KaiselRoute {
  const CatalogRoute();
}

final class CatalogRoot extends CatalogRoute {
  const CatalogRoot();

  @override
  List<Object?> get props => [];
}

sealed class InventoryRoute extends KaiselRoute {
  const InventoryRoute();
}

final class InventoryRoot extends InventoryRoute {
  const InventoryRoot();

  @override
  List<Object?> get props => [];
}

sealed class SalesRoute extends KaiselRoute {
  const SalesRoute();
}

final class SalesRoot extends SalesRoute {
  const SalesRoot();

  @override
  List<Object?> get props => [];
}

sealed class OperationsRoute extends KaiselRoute {
  const OperationsRoute();
}

final class OperationsRoot extends OperationsRoute {
  const OperationsRoot();

  @override
  List<Object?> get props => [];
}

sealed class PurchasingRoute extends KaiselRoute {
  const PurchasingRoute();
}

final class PurchasingRoot extends PurchasingRoute {
  const PurchasingRoot();

  @override
  List<Object?> get props => [];
}

sealed class CrmRoute extends KaiselRoute {
  const CrmRoute();
}

final class CrmRoot extends CrmRoute {
  const CrmRoot();

  @override
  List<Object?> get props => [];
}

sealed class DeliveryRoute extends KaiselRoute {
  const DeliveryRoute();
}

final class DeliveryRoot extends DeliveryRoute {
  const DeliveryRoot();

  @override
  List<Object?> get props => [];
}

sealed class HrRoute extends KaiselRoute {
  const HrRoute();
}

final class HrRoot extends HrRoute {
  const HrRoot();

  @override
  List<Object?> get props => [];
}

sealed class AccountingRoute extends KaiselRoute {
  const AccountingRoute();
}

final class AccountingRoot extends AccountingRoute {
  const AccountingRoot();

  @override
  List<Object?> get props => [];
}

sealed class MarketingRoute extends KaiselRoute {
  const MarketingRoute();
}

final class MarketingRoot extends MarketingRoute {
  const MarketingRoot();

  @override
  List<Object?> get props => [];
}

sealed class AdminProfileRoute extends KaiselRoute {
  const AdminProfileRoute();
}

final class AdminProfileRoot extends AdminProfileRoute {
  const AdminProfileRoot();

  @override
  List<Object?> get props => [];
}

sealed class AdminSettingsRoute extends KaiselRoute {
  const AdminSettingsRoute();
}

final class AdminSettingsRoot extends AdminSettingsRoute {
  const AdminSettingsRoot();

  @override
  List<Object?> get props => [];
}
