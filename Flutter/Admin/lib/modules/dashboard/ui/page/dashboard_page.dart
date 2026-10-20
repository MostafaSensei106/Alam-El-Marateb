import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../main/ui/widgets/admin_charts.dart';
import '../../../main/ui/widgets/admin_data_grid.dart';
import '../../../main/ui/widgets/admin_page_frame.dart';

/// Landing dashboard with the store's headline numbers, revenue trend and
/// latest orders.
final class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;

    return AdminPageFrame(
      children: [
        AdminPageHeader(
          icon: LucideIcons.layoutDashboard,
          title: l10n.dashboardGreeting(l10n.adminDisplayName),
          description: l10n.dashboardSubtitle,
          badge: l10n.dashboardTodaySales,
        ),
        const SizedBox(height: AppSpacing.large),
        _KpiGrid(
          items: [
            _KpiData(
              label: l10n.dashboardRevenue,
              value: '128,540 ${l10n.currencyEgp}',
              change: l10n.dashboardRevenueChange,
              icon: LucideIcons.wallet,
              positive: true,
            ),
            _KpiData(
              label: l10n.dashboardOrders,
              value: '1,284',
              change: l10n.dashboardOrdersChange,
              icon: LucideIcons.shoppingBag,
              positive: true,
            ),
            _KpiData(
              label: l10n.dashboardCustomers,
              value: '8,920',
              change: l10n.dashboardCustomersChange,
              icon: LucideIcons.users,
              positive: true,
            ),
            _KpiData(
              label: l10n.dashboardLowStock,
              value: '6',
              change: l10n.dashboardLowStockChange,
              icon: LucideIcons.triangleAlert,
              positive: false,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.large),
        LayoutBuilder(
          builder: (context, constraints) {
            final chart = _RevenueCard(currency: l10n.currencyEgp);
            const actions = _QuickActionsCard();
            if (constraints.maxWidth >= 1000) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: chart),
                  const SizedBox(width: AppSpacing.large),
                  const Expanded(child: _QuickActionsCard()),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                chart,
                const SizedBox(height: AppSpacing.large),
                actions,
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.large),
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 720) {
              return const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _ChannelSplitCard()),
                  SizedBox(width: AppSpacing.large),
                  Expanded(child: _MonthlyTargetCard()),
                ],
              );
            }
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ChannelSplitCard(),
                SizedBox(height: AppSpacing.large),
                _MonthlyTargetCard(),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.large),
        const _RecentOrdersCard(),
      ],
    );
  }
}

final class _KpiData {
  const _KpiData({
    required this.label,
    required this.value,
    required this.change,
    required this.icon,
    required this.positive,
  });

  final String label;
  final String value;
  final String change;
  final IconData icon;
  final bool positive;
}

/// Responsive KPI grid: four, two or one card per row.
final class _KpiGrid extends StatelessWidget {
  const _KpiGrid({required this.items});

  final List<_KpiData> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 1000
            ? 4
            : constraints.maxWidth >= 640
            ? 2
            : 1;
        const spacing = AppSpacing.large;
        final itemWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final item in items)
              SizedBox(
                width: itemWidth,
                child: _KpiCard(data: item),
              ),
          ],
        );
      },
    );
  }
}

final class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.data});

  final _KpiData data;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final accent = data.positive
        ? const Color(0xFF1B8A5A)
        : const Color(0xFFB26A00);

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(AppRadii.medium),
                ),
                child: Icon(
                  data.icon,
                  size: 19,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const Spacer(),
              Icon(
                data.positive
                    ? LucideIcons.trendingUp
                    : LucideIcons.trendingDown,
                size: AppIconSizes.small,
                color: accent,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(
            data.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            data.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.xSmall),
          Text(
            data.change,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

final class _RevenueCard extends StatelessWidget {
  const _RevenueCard({required this.currency});

  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final points = <AdminChartPoint>[
      AdminChartPoint(label: l10n.weekdaySat, value: 86),
      AdminChartPoint(label: l10n.weekdaySun, value: 94),
      AdminChartPoint(label: l10n.weekdayMon, value: 78),
      AdminChartPoint(label: l10n.weekdayTue, value: 112),
      AdminChartPoint(label: l10n.weekdayWed, value: 104),
      AdminChartPoint(label: l10n.weekdayThu, value: 128),
      AdminChartPoint(label: l10n.weekdayFri, value: 121),
    ];

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSectionHeading(
            title: l10n.dashboardRevenueTrend,
            icon: LucideIcons.chartNoAxesCombined,
            trailing: AdminStatusPill(
              label: l10n.dashboardRevenueChange,
              tone: AdminPillTone.success,
              icon: LucideIcons.arrowUpRight,
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          Wrap(
            spacing: AppSpacing.medium,
            runSpacing: AppSpacing.xSmall,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              Text(
                '128,540 $currency',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${l10n.dashboardAverageOrder} · 1,150 $currency',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          AdminAreaChart(points: points, height: 190),
        ],
      ),
    );
  }
}

final class _ChannelSplitCard extends StatelessWidget {
  const _ChannelSplitCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;

    final points = <AdminChartPoint>[
      AdminChartPoint(
        label: l10n.dashboardChannelStore,
        value: 52,
        color: colorScheme.primary,
      ),
      AdminChartPoint(
        label: l10n.dashboardChannelOnline,
        value: 31,
        color: colorScheme.tertiary,
      ),
      AdminChartPoint(
        label: l10n.dashboardChannelWholesale,
        value: 17,
        color: const Color(0xFF1B8A5A),
      ),
    ];

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSectionHeading(
            title: l10n.dashboardChannelSplit,
            icon: LucideIcons.pieChart,
          ),
          const SizedBox(height: AppSpacing.medium),
          AdminDoughnutChart(points: points),
        ],
      ),
    );
  }
}

final class _MonthlyTargetCard extends StatelessWidget {
  const _MonthlyTargetCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSectionHeading(
            title: l10n.dashboardMonthlyTarget,
            icon: LucideIcons.target,
          ),
          const SizedBox(height: AppSpacing.medium),
          const AdminTargetGauge(
            value: 74,
            label: '',
            height: 186,
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            l10n.dashboardTargetHint,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

final class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSectionHeading(
            title: l10n.dashboardQuickActions,
            icon: LucideIcons.zap,
          ),
          const SizedBox(height: AppSpacing.large),
          _QuickActionButton(
            icon: LucideIcons.plus,
            label: l10n.dashboardNewSale,
          ),
          const SizedBox(height: AppSpacing.small),
          _QuickActionButton(
            icon: LucideIcons.packagePlus,
            label: l10n.dashboardAddProduct,
          ),
          const SizedBox(height: AppSpacing.small),
          _QuickActionButton(
            icon: LucideIcons.userPlus,
            label: l10n.dashboardNewCustomer,
          ),
          const SizedBox(height: AppSpacing.small),
          _QuickActionButton(
            icon: LucideIcons.truck,
            label: l10n.dashboardCreateTrip,
          ),
        ],
      ),
    );
  }
}

final class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _showComingSoon(context),
      icon: Icon(icon, size: AppIconSizes.small),
      label: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(label),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.medium,
          vertical: AppSpacing.medium,
        ),
        alignment: AlignmentDirectional.centerStart,
      ),
    );
  }
}

final class _RecentOrdersCard extends StatelessWidget {
  const _RecentOrdersCard();

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final orders = [
      (
        id: '#1042',
        customer: l10n.sampleCustomer1,
        status: l10n.dashboardStatusPaid,
        tone: AdminPillTone.success,
        color: const Color(0xFF1B8A5A),
        total: '1,250',
      ),
      (
        id: '#1041',
        customer: l10n.sampleCustomer2,
        status: l10n.dashboardStatusShipping,
        tone: AdminPillTone.primary,
        color: colorScheme.primary,
        total: '740',
      ),
      (
        id: '#1040',
        customer: l10n.sampleCustomer3,
        status: l10n.dashboardStatusPending,
        tone: AdminPillTone.warning,
        color: const Color(0xFFB26A00),
        total: '2,180',
      ),
      (
        id: '#1039',
        customer: l10n.sampleCustomer4,
        status: l10n.dashboardStatusPaid,
        tone: AdminPillTone.success,
        color: const Color(0xFF1B8A5A),
        total: '980',
      ),
    ];

    final headerStyle = textTheme.labelSmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
    );

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSectionHeading(
            title: l10n.dashboardRecentOrders,
            icon: LucideIcons.receiptText,
            trailing: TextButton(
              onPressed: () => _showComingSoon(context),
              child: Text(l10n.dashboardViewAll),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 640) {
                return AdminRecordsGrid(
                  height: 46 * orders.length + 50,
                  headers: [
                    l10n.dashboardOrder,
                    l10n.dashboardCustomer,
                    l10n.dashboardStatus,
                    l10n.dashboardTotal,
                  ],
                  records: [
                    for (final order in orders)
                      AdminRecord(
                        reference: order.id,
                        title: order.customer,
                        status: order.status,
                        statusColor: order.color,
                        value: '${order.total} ${l10n.currencyEgp}',
                      ),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          l10n.dashboardOrder,
                          style: headerStyle,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          l10n.dashboardStatus,
                          style: headerStyle,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          l10n.dashboardTotal,
                          textAlign: TextAlign.end,
                          style: headerStyle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.small),
                  for (final order in orders) ...[
                    Divider(height: 1, color: colorScheme.outlineVariant),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.medium,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order.id,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  order.customer,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: AdminStatusPill(
                                label: order.status,
                                tone: order.tone,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${order.total} ${l10n.currencyEgp}',
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

void _showComingSoon(BuildContext context) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(context.localeKeys.screenComingSoon)));
}
