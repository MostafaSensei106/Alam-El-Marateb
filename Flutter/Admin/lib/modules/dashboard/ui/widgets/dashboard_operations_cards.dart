import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../main/navigation/admin_module.dart';
import '../../../main/ui/widgets/admin_page_frame.dart';
import '../../domain/dashboard_models.dart';
import 'dashboard_shared.dart';

/// Revenue, profit, orders and share for every branch.
final class DashboardBranchPerformanceCard extends StatelessWidget {
  const DashboardBranchPerformanceCard({
    required this.branches,
    required this.currency,
    super.key,
  });

  final List<BranchPerformance> branches;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;

    return DashboardSection(
      title: l10n.dashboardBranchPerformance,
      subtitle: l10n.dashboardBranchHint,
      icon: LucideIcons.building2,
      child: DashboardTable(
        columns: [
          DashboardTableColumn(label: l10n.dashboardBranchFilter, flex: 3),
          DashboardTableColumn(
            label: l10n.dashboardRevenue,
            flex: 2,
            align: AlignmentDirectional.centerEnd,
          ),
          DashboardTableColumn(
            label: l10n.dashboardBranchProfit,
            flex: 2,
            align: AlignmentDirectional.centerEnd,
          ),
          DashboardTableColumn(
            label: l10n.dashboardBranchOrders,
            flex: 2,
            align: AlignmentDirectional.centerEnd,
          ),
          DashboardTableColumn(
            label: l10n.dashboardShare,
            align: AlignmentDirectional.centerEnd,
          ),
        ],
        rows: [
          for (final branch in branches)
            DashboardTableRow([
              DashboardTableCell(branch.name, secondary: branch.city),
              DashboardTableCell(dashboardMoney(branch.revenue, currency)),
              DashboardTableCell(dashboardMoney(branch.profit, currency)),
              DashboardTableCell(dashboardInteger(branch.orders)),
              DashboardTableCell(dashboardPercent(branch.share)),
            ]),
        ],
        emptyMessage: l10n.dashboardNoBranches,
      ),
    );
  }
}

/// Stock quantity and valuation held by each warehouse.
final class DashboardStockCard extends StatelessWidget {
  const DashboardStockCard({
    required this.warehouses,
    required this.stockValue,
    required this.stockQuantity,
    required this.lowStockCount,
    required this.currency,
    super.key,
  });

  final List<WarehouseStock> warehouses;
  final double stockValue;
  final int stockQuantity;
  final int lowStockCount;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;

    return DashboardSection(
      title: l10n.dashboardStockByWarehouse,
      subtitle: l10n.dashboardStockHint,
      icon: LucideIcons.warehouse,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.small,
            children: [
              AdminStatusPill(
                label: l10n.dashboardStockTotal,
                tone: AdminPillTone.primary,
                icon: LucideIcons.banknote,
              ),
              AdminStatusPill(
                label: l10n.dashboardStockQuantity(
                  dashboardInteger(stockQuantity),
                ),
                icon: LucideIcons.boxes,
              ),
              AdminStatusPill(
                label: l10n.dashboardWarehouses(
                  dashboardInteger(warehouses.length),
                ),
                icon: LucideIcons.warehouse,
              ),
              if (lowStockCount > 0)
                AdminStatusPill(
                  label:
                      '${dashboardInteger(lowStockCount)} ${l10n.dashboardLowStock}',
                  tone: AdminPillTone.warning,
                  icon: LucideIcons.triangleAlert,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              dashboardMoney(stockValue, currency),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          DashboardTable(
            columns: [
              DashboardTableColumn(label: l10n.dashboardWarehouse, flex: 3),
              DashboardTableColumn(
                label: l10n.dashboardUnits,
                flex: 2,
                align: AlignmentDirectional.centerEnd,
              ),
              DashboardTableColumn(
                label: l10n.dashboardStockTotal,
                flex: 3,
                align: AlignmentDirectional.centerEnd,
              ),
              DashboardTableColumn(
                label: l10n.dashboardLowStock,
                flex: 2,
                align: AlignmentDirectional.centerEnd,
              ),
            ],
            rows: [
              for (final warehouse in warehouses)
                DashboardTableRow([
                  DashboardTableCell(warehouse.name, secondary: warehouse.city),
                  DashboardTableCell(dashboardInteger(warehouse.quantity)),
                  DashboardTableCell(dashboardMoney(warehouse.value, currency)),
                  DashboardTableCell(
                    dashboardInteger(warehouse.lowStock),
                    child: warehouse.lowStock == 0
                        ? Text(
                            dashboardInteger(warehouse.lowStock),
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        : AdminStatusPill(
                            label: dashboardInteger(warehouse.lowStock),
                            tone: AdminPillTone.warning,
                            icon: LucideIcons.triangleAlert,
                          ),
                    align: AlignmentDirectional.centerEnd,
                  ),
                ]),
            ],
          ),
        ],
      ),
    );
  }
}

/// Three operational counters that link to the inventory module.
final class DashboardOperationsAlerts extends StatelessWidget {
  const DashboardOperationsAlerts({
    required this.lowStock,
    required this.pendingTransfers,
    required this.openAudits,
    required this.onOpenModule,
    super.key,
  });

  final int lowStock;
  final int pendingTransfers;
  final int openAudits;
  final ValueChanged<AdminModuleId> onOpenModule;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;

    final alerts = [
      _DashboardAlertData(
        label: l10n.dashboardLowStockAlert,
        hint: l10n.dashboardLowStockAlertHint,
        value: lowStock,
        icon: LucideIcons.triangleAlert,
        color: const Color(0xFFB26A00),
      ),
      _DashboardAlertData(
        label: l10n.dashboardPendingTransfers,
        hint: l10n.dashboardPendingTransfersHint,
        value: pendingTransfers,
        icon: LucideIcons.truck,
        color: colorScheme.primary,
      ),
      _DashboardAlertData(
        label: l10n.dashboardOpenAudits,
        hint: l10n.dashboardOpenAuditsHint,
        value: openAudits,
        icon: LucideIcons.clipboardList,
        color: colorScheme.tertiary,
      ),
    ];

    return DashboardSection(
      title: l10n.dashboardOperations,
      subtitle: l10n.dashboardOperationsHint,
      icon: LucideIcons.activity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final columns = width >= 900
              ? 3
              : width >= 560
              ? 2
              : 1;
          const gap = AppSpacing.medium;
          final itemWidth = (width - gap * (columns - 1)) / columns;

          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: [
              for (final alert in alerts)
                SizedBox(
                  width: itemWidth,
                  child: _DashboardAlertTile(
                    data: alert,
                    onTap: () => onOpenModule(AdminModuleId.inventory),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

final class _DashboardAlertData {
  const _DashboardAlertData({
    required this.label,
    required this.hint,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String hint;
  final int value;
  final IconData icon;
  final Color color;
}

final class _DashboardAlertTile extends StatelessWidget {
  const _DashboardAlertTile({required this.data, required this.onTap});

  final _DashboardAlertData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.large),
      child: AdminSurfaceCard(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: data.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppRadii.medium),
              ),
              child: Icon(
                data.icon,
                size: AppIconSizes.small,
                color: data.color,
              ),
            ),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dashboardInteger(data.value),
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    data.hint,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              LucideIcons.chevronRight,
              size: AppIconSizes.small,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
