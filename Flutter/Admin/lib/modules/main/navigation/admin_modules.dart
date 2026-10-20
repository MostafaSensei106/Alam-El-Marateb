import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../l10n/app_localizations.dart';
import 'admin_module.dart';

/// Builds the localized navigation catalog for the admin workspace.
///
/// Every top-level module owns one entry here. Feature pages request their own
/// entry through [byId] so the rail and the page can never drift apart.
abstract final class AdminModules {
  static List<AdminModule> all(AppLocalizations l10n) => [
    AdminModule(
      id: AdminModuleId.dashboard,
      label: l10n.navDashboard,
      title: l10n.dashboardTitle,
      description: l10n.dashboardDescription,
      icon: LucideIcons.layoutDashboard,
      subSections: [
        AdminSubSection(
          title: l10n.dashboardFeature1,
          icon: LucideIcons.chartNoAxesCombined,
          wireframe: AdminWireframeKind.stats,
        ),
        AdminSubSection(
          title: l10n.dashboardFeature2,
          icon: LucideIcons.chartColumn,
          wireframe: AdminWireframeKind.stats,
        ),
        AdminSubSection(
          title: l10n.dashboardFeature3,
          icon: LucideIcons.map,
          wireframe: AdminWireframeKind.map,
        ),
        AdminSubSection(
          title: l10n.dashboardFeature4,
          icon: LucideIcons.trendingUp,
          wireframe: AdminWireframeKind.table,
        ),
        AdminSubSection(
          title: l10n.dashboardFeature5,
          icon: LucideIcons.usersRound,
          wireframe: AdminWireframeKind.list,
        ),
      ],
    ),
    AdminModule(
      id: AdminModuleId.identity,
      label: l10n.navIdentity,
      title: l10n.identityTitle,
      description: l10n.identityDescription,
      icon: LucideIcons.shieldCheck,
      subSections: [
        AdminSubSection(
          title: l10n.identityFeature1,
          icon: LucideIcons.building2,
          wireframe: AdminWireframeKind.list,
        ),
        AdminSubSection(
          title: l10n.identityFeature2,
          icon: LucideIcons.usersRound,
          wireframe: AdminWireframeKind.table,
        ),
        AdminSubSection(
          title: l10n.identityFeature3,
          icon: LucideIcons.truck,
          wireframe: AdminWireframeKind.list,
        ),
      ],
    ),
    AdminModule(
      id: AdminModuleId.catalog,
      label: l10n.navCatalog,
      title: l10n.catalogTitle,
      description: l10n.catalogDescription,
      icon: LucideIcons.package,
      subSections: [
        AdminSubSection(
          title: l10n.catalogFeature1,
          icon: LucideIcons.package,
          wireframe: AdminWireframeKind.table,
        ),
        AdminSubSection(
          title: l10n.catalogFeature2,
          icon: LucideIcons.layers,
          wireframe: AdminWireframeKind.list,
        ),
        AdminSubSection(
          title: l10n.catalogFeature3,
          icon: LucideIcons.tag,
          wireframe: AdminWireframeKind.table,
        ),
        AdminSubSection(
          title: l10n.catalogFeature4,
          icon: LucideIcons.list,
          wireframe: AdminWireframeKind.table,
        ),
        AdminSubSection(
          title: l10n.catalogFeature5,
          icon: LucideIcons.shapes,
          wireframe: AdminWireframeKind.form,
        ),
      ],
    ),
    AdminModule(
      id: AdminModuleId.inventory,
      label: l10n.navInventory,
      title: l10n.inventoryTitle,
      description: l10n.inventoryDescription,
      icon: LucideIcons.warehouse,
      subSections: [
        AdminSubSection(
          title: l10n.inventoryFeature1,
          icon: LucideIcons.warehouse,
          wireframe: AdminWireframeKind.list,
        ),
        AdminSubSection(
          title: l10n.inventoryFeature2,
          icon: LucideIcons.boxes,
          wireframe: AdminWireframeKind.table,
        ),
        AdminSubSection(
          title: l10n.inventoryFeature3,
          icon: LucideIcons.arrowLeftRight,
          wireframe: AdminWireframeKind.form,
        ),
        AdminSubSection(
          title: l10n.inventoryFeature4,
          icon: LucideIcons.clipboardCheck,
          wireframe: AdminWireframeKind.table,
        ),
        AdminSubSection(
          title: l10n.inventoryFeature5,
          icon: LucideIcons.layers,
          wireframe: AdminWireframeKind.stats,
        ),
      ],
    ),
    AdminModule(
      id: AdminModuleId.sales,
      label: l10n.navSales,
      title: l10n.salesTitle,
      description: l10n.salesDescription,
      icon: LucideIcons.shoppingCart,
      subSections: [
        AdminSubSection(
          title: l10n.salesFeature1,
          icon: LucideIcons.scanBarcode,
          wireframe: AdminWireframeKind.form,
        ),
        AdminSubSection(
          title: l10n.salesFeature2,
          icon: LucideIcons.creditCard,
          wireframe: AdminWireframeKind.list,
        ),
        AdminSubSection(
          title: l10n.salesFeature3,
          icon: LucideIcons.clock,
          wireframe: AdminWireframeKind.calendar,
        ),
        AdminSubSection(
          title: l10n.salesFeature4,
          icon: LucideIcons.receipt,
          wireframe: AdminWireframeKind.table,
        ),
        AdminSubSection(
          title: l10n.salesFeature5,
          icon: LucideIcons.ticket,
          wireframe: AdminWireframeKind.board,
        ),
        AdminSubSection(
          title: l10n.salesFeature6,
          icon: LucideIcons.percent,
          wireframe: AdminWireframeKind.table,
        ),
      ],
    ),
    AdminModule(
      id: AdminModuleId.purchasing,
      label: l10n.navPurchasing,
      title: l10n.purchasingTitle,
      description: l10n.purchasingDescription,
      icon: LucideIcons.clipboardList,
      subSections: [
        AdminSubSection(
          title: l10n.purchasingFeature1,
          icon: LucideIcons.usersRound,
          wireframe: AdminWireframeKind.list,
        ),
        AdminSubSection(
          title: l10n.purchasingFeature2,
          icon: LucideIcons.clipboardList,
          wireframe: AdminWireframeKind.form,
        ),
        AdminSubSection(
          title: l10n.purchasingFeature3,
          icon: LucideIcons.ship,
          wireframe: AdminWireframeKind.table,
        ),
        AdminSubSection(
          title: l10n.purchasingFeature4,
          icon: LucideIcons.receipt,
          wireframe: AdminWireframeKind.table,
        ),
      ],
    ),
    AdminModule(
      id: AdminModuleId.crm,
      label: l10n.navCrm,
      title: l10n.crmTitle,
      description: l10n.crmDescription,
      icon: LucideIcons.headset,
      subSections: [
        AdminSubSection(
          title: l10n.crmFeature1,
          icon: LucideIcons.badgeCheck,
          wireframe: AdminWireframeKind.table,
        ),
        AdminSubSection(
          title: l10n.crmFeature2,
          icon: LucideIcons.wrench,
          wireframe: AdminWireframeKind.board,
        ),
        AdminSubSection(
          title: l10n.crmFeature3,
          icon: LucideIcons.star,
          wireframe: AdminWireframeKind.list,
        ),
        AdminSubSection(
          title: l10n.crmFeature4,
          icon: LucideIcons.messageSquare,
          wireframe: AdminWireframeKind.list,
        ),
      ],
    ),
    AdminModule(
      id: AdminModuleId.delivery,
      label: l10n.navDelivery,
      title: l10n.deliveryTitle,
      description: l10n.deliveryDescription,
      icon: LucideIcons.truck,
      subSections: [
        AdminSubSection(
          title: l10n.deliveryFeature1,
          icon: LucideIcons.clipboardList,
          wireframe: AdminWireframeKind.board,
        ),
        AdminSubSection(
          title: l10n.deliveryFeature2,
          icon: LucideIcons.user,
          wireframe: AdminWireframeKind.list,
        ),
        AdminSubSection(
          title: l10n.deliveryFeature3,
          icon: LucideIcons.route,
          wireframe: AdminWireframeKind.map,
        ),
        AdminSubSection(
          title: l10n.deliveryFeature4,
          icon: LucideIcons.mapPin,
          wireframe: AdminWireframeKind.map,
        ),
        AdminSubSection(
          title: l10n.deliveryFeature5,
          icon: LucideIcons.image,
          wireframe: AdminWireframeKind.detail,
        ),
      ],
    ),
    AdminModule(
      id: AdminModuleId.hr,
      label: l10n.navHr,
      title: l10n.hrTitle,
      description: l10n.hrDescription,
      icon: LucideIcons.users,
      subSections: [
        AdminSubSection(
          title: l10n.hrFeature1,
          icon: LucideIcons.users,
          wireframe: AdminWireframeKind.list,
        ),
        AdminSubSection(
          title: l10n.hrFeature2,
          icon: LucideIcons.calendarDays,
          wireframe: AdminWireframeKind.calendar,
        ),
        AdminSubSection(
          title: l10n.hrFeature3,
          icon: LucideIcons.wallet,
          wireframe: AdminWireframeKind.table,
        ),
        AdminSubSection(
          title: l10n.hrFeature4,
          icon: LucideIcons.handCoins,
          wireframe: AdminWireframeKind.table,
        ),
      ],
    ),
    AdminModule(
      id: AdminModuleId.accounting,
      label: l10n.navAccounting,
      title: l10n.accountingTitle,
      description: l10n.accountingDescription,
      icon: LucideIcons.calculator,
      subSections: [
        AdminSubSection(
          title: l10n.accountingFeature1,
          icon: LucideIcons.network,
          wireframe: AdminWireframeKind.list,
        ),
        AdminSubSection(
          title: l10n.accountingFeature2,
          icon: LucideIcons.bookOpen,
          wireframe: AdminWireframeKind.table,
        ),
        AdminSubSection(
          title: l10n.accountingFeature3,
          icon: LucideIcons.landmark,
          wireframe: AdminWireframeKind.list,
        ),
        AdminSubSection(
          title: l10n.accountingFeature4,
          icon: LucideIcons.fileText,
          wireframe: AdminWireframeKind.table,
        ),
        AdminSubSection(
          title: l10n.accountingFeature5,
          icon: LucideIcons.chartNoAxesCombined,
          wireframe: AdminWireframeKind.stats,
        ),
      ],
    ),
    AdminModule(
      id: AdminModuleId.marketing,
      label: l10n.navMarketing,
      title: l10n.marketingTitle,
      description: l10n.marketingDescription,
      icon: LucideIcons.megaphone,
      subSections: [
        AdminSubSection(
          title: l10n.marketingFeature1,
          icon: LucideIcons.ferrisWheel,
          wireframe: AdminWireframeKind.board,
        ),
        AdminSubSection(
          title: l10n.marketingFeature2,
          icon: LucideIcons.gift,
          wireframe: AdminWireframeKind.table,
        ),
      ],
    ),
    AdminModule(
      id: AdminModuleId.profile,
      label: l10n.navProfile,
      title: l10n.profileTitle,
      description: l10n.profileDescription,
      icon: LucideIcons.circleUser,
      subSections: [
        AdminSubSection(
          title: l10n.profileFeature1,
          icon: LucideIcons.user,
          wireframe: AdminWireframeKind.detail,
        ),
        AdminSubSection(
          title: l10n.profileFeature2,
          icon: LucideIcons.user,
          wireframe: AdminWireframeKind.form,
        ),
        AdminSubSection(
          title: l10n.profileFeature3,
          icon: LucideIcons.keyRound,
          wireframe: AdminWireframeKind.form,
        ),
        AdminSubSection(
          title: l10n.profileFeature4,
          icon: LucideIcons.shieldCheck,
          wireframe: AdminWireframeKind.list,
        ),
      ],
    ),
    AdminModule(
      id: AdminModuleId.settings,
      label: l10n.navSettings,
      title: l10n.settingsTitle,
      description: l10n.settingsDescription,
      icon: LucideIcons.settings,
      subSections: [
        AdminSubSection(
          title: l10n.settingsFeature1,
          icon: LucideIcons.palette,
          wireframe: AdminWireframeKind.form,
        ),
        AdminSubSection(
          title: l10n.settingsFeature2,
          icon: LucideIcons.bell,
          wireframe: AdminWireframeKind.list,
        ),
        AdminSubSection(
          title: l10n.settingsFeature3,
          icon: LucideIcons.slidersHorizontal,
          wireframe: AdminWireframeKind.form,
        ),
        AdminSubSection(
          title: l10n.settingsFeature4,
          icon: LucideIcons.info,
          wireframe: AdminWireframeKind.detail,
        ),
      ],
    ),
  ];

  /// Returns the entry for [id] in the current locale.
  static AdminModule byId(AppLocalizations l10n, AdminModuleId id) =>
      all(l10n)[id.index];
}
