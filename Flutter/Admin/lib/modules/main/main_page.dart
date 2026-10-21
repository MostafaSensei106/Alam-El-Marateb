import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaisel/kaisel.dart';

import '../../core/router/app_router.dart';
import '../accounting/ui/page/accounting_page.dart';
import '../catalog/ui/page/catalog_page.dart';
import '../crm/ui/page/crm_page.dart';
import '../dashboard/ui/page/dashboard_page.dart';
import '../delivery/ui/page/delivery_page.dart';
import '../hr/ui/page/hr_page.dart';
import '../identity/ui/page/identity_page.dart';
import '../inventory/ui/page/inventory_page.dart';
import '../marketing/ui/page/marketing_page.dart';
import '../operations/ui/page/operations_page.dart';
import '../profile/ui/page/profile_page.dart';
import '../purchasing/ui/page/purchasing_page.dart';
import '../sales/ui/page/sales_page.dart';
import '../settings/ui/page/settings_page.dart';
import 'ui/page/admin_shell.dart';

/// Hosts the fourteen admin branches and the shared workspace chrome.
///
/// The branch order must match [AdminModuleId] so the rail index, the account
/// menu shortcuts and the router all resolve to the same page.
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return KaiselBranchedShell.specs(
      branches: [
        KaiselBranchSpec<DashboardRoute>(
          initial: const DashboardRoot(),
          builder: (context, route) => switch (route) {
            DashboardRoot() => const DashboardPage(),
          },
        ),
        KaiselBranchSpec<IdentityRoute>(
          initial: const IdentityRoot(),
          builder: (context, route) => switch (route) {
            IdentityRoot() => const IdentityPage(),
          },
        ),
        KaiselBranchSpec<CatalogRoute>(
          initial: const CatalogRoot(),
          builder: (context, route) => switch (route) {
            CatalogRoot() => const CatalogPage(),
          },
        ),
        KaiselBranchSpec<InventoryRoute>(
          initial: const InventoryRoot(),
          builder: (context, route) => switch (route) {
            InventoryRoot() => const InventoryPage(),
          },
        ),
        KaiselBranchSpec<SalesRoute>(
          initial: const SalesRoot(),
          builder: (context, route) => switch (route) {
            SalesRoot() => const SalesPage(),
          },
        ),
        KaiselBranchSpec<OperationsRoute>(
          initial: const OperationsRoot(),
          builder: (context, route) => switch (route) {
            OperationsRoot() => const OperationsPage(),
          },
        ),
        KaiselBranchSpec<PurchasingRoute>(
          initial: const PurchasingRoot(),
          builder: (context, route) => switch (route) {
            PurchasingRoot() => const PurchasingPage(),
          },
        ),
        KaiselBranchSpec<CrmRoute>(
          initial: const CrmRoot(),
          builder: (context, route) => switch (route) {
            CrmRoot() => const CrmPage(),
          },
        ),
        KaiselBranchSpec<DeliveryRoute>(
          initial: const DeliveryRoot(),
          builder: (context, route) => switch (route) {
            DeliveryRoot() => const DeliveryPage(),
          },
        ),
        KaiselBranchSpec<HrRoute>(
          initial: const HrRoot(),
          builder: (context, route) => switch (route) {
            HrRoot() => const HrPage(),
          },
        ),
        KaiselBranchSpec<AccountingRoute>(
          initial: const AccountingRoot(),
          builder: (context, route) => switch (route) {
            AccountingRoot() => const AccountingPage(),
          },
        ),
        KaiselBranchSpec<MarketingRoute>(
          initial: const MarketingRoot(),
          builder: (context, route) => switch (route) {
            MarketingRoot() => const MarketingPage(),
          },
        ),
        KaiselBranchSpec<AdminProfileRoute>(
          initial: const AdminProfileRoot(),
          builder: (context, route) => switch (route) {
            AdminProfileRoot() => const ProfilePage(),
          },
        ),
        KaiselBranchSpec<AdminSettingsRoute>(
          initial: const AdminSettingsRoot(),
          builder: (context, route) => switch (route) {
            AdminSettingsRoot() => const SettingsPage(),
          },
        ),
      ],
      lazy: true,
      chromeBuilder: (context, active, branchContent, switchBranch) {
        return AdminShell(
          selectedIndex: active,
          onDestinationSelected: (index) {
            unawaited(HapticFeedback.vibrate());
            switchBranch(index);
          },
          onSelectModule: (module) {
            unawaited(HapticFeedback.vibrate());
            switchBranch(module.index);
          },
          child: branchContent,
        );
      },
    );
  }
}
