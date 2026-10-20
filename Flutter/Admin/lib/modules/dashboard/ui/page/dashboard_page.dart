import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../main/navigation/admin_module.dart';
import '../../../main/navigation/admin_modules.dart';
import '../../../main/ui/widgets/admin_page_frame.dart';
import '../../data/dashboard_sample_data.dart';
import '../../domain/dashboard_models.dart';
import '../widgets/dashboard_customer_360.dart';
import '../widgets/dashboard_customer_cards.dart';
import '../widgets/dashboard_insight_cards.dart';
import '../widgets/dashboard_operations_cards.dart';
import '../widgets/dashboard_shared.dart';
import '../widgets/dashboard_summary_cards.dart';

/// Landing dashboard with the store's headline numbers, revenue trend and
/// latest orders.
final class DashboardPage extends HookWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final period = useState(DashboardPeriod.last30);
    final branchId = useState(DashboardSampleData.allBranches);
    final updatedAt = useState(_timeLabel(DateTime.now()));

    final snapshot = DashboardSampleData.snapshot(
      l10n: l10n,
      period: period.value,
      branchId: branchId.value,
    );
    final branches = DashboardSampleData.branches(l10n);
    final currency = l10n.currencyEgp;

    final revenueKpi = snapshot.kpis.firstWhere(
      (kpi) => kpi.id == DashboardKpiId.revenue,
    );
    final orders = snapshot.branches.fold<int>(
      0,
      (total, branch) => total + branch.orders,
    );

    final quickActions = [
      DashboardQuickAction(
        label: l10n.dashboardNewSale,
        icon: LucideIcons.plus,
        moduleId: AdminModuleId.sales,
      ),
      DashboardQuickAction(
        label: l10n.dashboardAddProduct,
        icon: LucideIcons.packagePlus,
        moduleId: AdminModuleId.inventory,
      ),
      DashboardQuickAction(
        label: l10n.dashboardNewCustomer,
        icon: LucideIcons.userPlus,
        moduleId: AdminModuleId.crm,
      ),
      DashboardQuickAction(
        label: l10n.dashboardNewPurchase,
        icon: LucideIcons.truck,
        moduleId: AdminModuleId.purchasing,
      ),
      DashboardQuickAction(
        label: l10n.dashboardStockTransfer,
        icon: LucideIcons.arrowLeftRight,
        moduleId: AdminModuleId.inventory,
      ),
      DashboardQuickAction(
        label: l10n.dashboardCreateTrip,
        icon: LucideIcons.map,
        moduleId: AdminModuleId.delivery,
      ),
    ];

    void showModuleHint(String moduleLabel) {
      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(l10n.dashboardOpenModuleHint(moduleLabel)),
          ),
        );
    }

    void openCustomer(DashboardCustomer customer) {
      showDashboardCustomer360(
        context,
        customer: customer,
        currency: currency,
      );
    }

    void openCustomerById(String customerId) {
      for (final customer in snapshot.customers) {
        if (customer.id == customerId) {
          openCustomer(customer);
          return;
        }
      }
    }

    void refresh() {
      final now = DateTime.now();
      updatedAt.value = _timeLabel(now);
      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(l10n.dashboardUpdated(updatedAt.value))),
        );
    }

    return AdminPageFrame(
      children: [
        AdminPageHeader(
          icon: LucideIcons.layoutDashboard,
          title: l10n.dashboardGreeting(l10n.adminDisplayName),
          description: l10n.dashboardSubtitle,
          badge: l10n.dashboardTodaySales,
        ),
        const SizedBox(height: AppSpacing.large),
        DashboardFilterBar(
          period: period.value,
          branchId: branchId.value,
          branches: branches,
          updatedAt: updatedAt.value,
          onPeriodChanged: (value) => period.value = value,
          onBranchChanged: (value) => branchId.value = value,
          onRefresh: refresh,
        ),
        const SizedBox(height: AppSpacing.large),
        DashboardKpiGrid(kpis: snapshot.kpis),
        const SizedBox(height: AppSpacing.large),
        DashboardSplit(
          leading: DashboardRevenueCard(
            series: snapshot.revenueSeries,
            orders: orders,
            growth: revenueKpi.changePercent,
            currency: currency,
          ),
          trailing: DashboardQuickActions(
            actions: quickActions,
            onAction: (action) =>
                showModuleHint(dashboardModuleLabel(action, l10n)),
          ),
        ),
        const SizedBox(height: AppSpacing.large),
        DashboardSplit(
          leading: DashboardBranchPerformanceCard(
            branches: snapshot.branches,
            currency: currency,
          ),
          trailing: DashboardStockCard(
            warehouses: snapshot.warehouses,
            stockValue: snapshot.stockValue,
            stockQuantity: snapshot.stockQuantity,
            lowStockCount: snapshot.lowStockCount,
            currency: currency,
          ),
        ),
        const SizedBox(height: AppSpacing.large),
        DashboardOperationsAlerts(
          lowStock: snapshot.lowStockCount,
          pendingTransfers: snapshot.pendingTransfers,
          openAudits: snapshot.openAudits,
          onOpenModule: (moduleId) =>
              showModuleHint(AdminModules.byId(l10n, moduleId).label),
        ),
        const SizedBox(height: AppSpacing.large),
        DashboardSplit(
          leading: DashboardRfmCard(
            slices: snapshot.rfm,
            currency: currency,
          ),
          trailing: DashboardGeoCard(
            cells: snapshot.geo,
            currency: currency,
          ),
        ),
        const SizedBox(height: AppSpacing.large),
        DashboardSplit(
          leading: DashboardVelocityCard(rows: snapshot.velocity),
          trailing: DashboardTopProductsCard(
            products: snapshot.topProducts,
            currency: currency,
          ),
        ),
        const SizedBox(height: AppSpacing.large),
        DashboardSplit(
          leading: DashboardTopCustomersCard(
            customers: snapshot.customers,
            currency: currency,
            onOpenCustomer: openCustomer,
          ),
          trailing: DashboardRecentOrdersCard(
            orders: snapshot.recentOrders,
            currency: currency,
            onOpenCustomer: openCustomerById,
          ),
        ),
        const SizedBox(height: AppSpacing.large),
        DashboardSplit(
          leading: DashboardInquiriesCard(inquiries: snapshot.inquiries),
          trailing: DashboardTopAskedCard(products: snapshot.topAsked),
        ),
        const SizedBox(height: AppSpacing.large),
        DashboardAuditTrailCard(events: snapshot.audit),
        const SizedBox(height: AppSpacing.large),
        const DashboardSampleNote(),
      ],
    );
  }
}

String _timeLabel(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}
