import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../main/navigation/admin_module.dart';
import '../../../main/navigation/admin_modules.dart';
import '../../../main/ui/widgets/admin_charts.dart';
import '../../../main/ui/widgets/admin_page_frame.dart';
import '../../domain/dashboard_models.dart';
import 'dashboard_shared.dart';

/// Branch id that disables branch filtering.
const String dashboardAllBranchesId = 'all';

/// Period, branch and refresh controls above the dashboard grid.
final class DashboardFilterBar extends StatelessWidget {
  const DashboardFilterBar({
    required this.period,
    required this.branchId,
    required this.branches,
    required this.updatedAt,
    required this.onPeriodChanged,
    required this.onBranchChanged,
    required this.onRefresh,
    super.key,
  });

  final DashboardPeriod period;
  final String branchId;
  final List<DashboardBranch> branches;
  final String updatedAt;
  final ValueChanged<DashboardPeriod> onPeriodChanged;
  final ValueChanged<String> onBranchChanged;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;

    final periodChips = Wrap(
      spacing: AppSpacing.small,
      runSpacing: AppSpacing.small,
      children: [
        for (final option in DashboardPeriod.values)
          ChoiceChip(
            label: Text(l10n.dashboardPeriodLabel(option)),
            selected: option == period,
            showCheckmark: false,
            elevation: 0,
            pressElevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            selectedColor: colorScheme.secondaryContainer,
            backgroundColor: colorScheme.surfaceContainerHighest,
            side: BorderSide(
              color: option == period
                  ? colorScheme.secondary
                  : colorScheme.outlineVariant.withValues(alpha: 0.6),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.pill),
            ),
            labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: option == period
                  ? colorScheme.onSecondaryContainer
                  : colorScheme.onSurfaceVariant,
            ),
            onSelected: (_) => onPeriodChanged(option),
          ),
      ],
    );

    final branchField = DropdownButtonFormField<String>(
      initialValue: branchId,
      isExpanded: true,
      decoration: InputDecoration(
        isDense: true,
        labelText: l10n.dashboardBranchFilter,
        prefixIcon: const Icon(
          LucideIcons.store,
          size: AppIconSizes.small,
        ),
      ),
      items: [
        DropdownMenuItem<String>(
          value: dashboardAllBranchesId,
          child: Text(
            l10n.dashboardAllBranches,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        for (final branch in branches)
          DropdownMenuItem<String>(
            value: branch.id,
            child: Text(
              branch.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: (value) {
        if (value != null) {
          onBranchChanged(value);
        }
      },
    );

    return AdminSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 880;
          final veryCompact = constraints.maxWidth < 380;
          final refreshButton = veryCompact
              ? IconButton.filledTonal(
                  onPressed: onRefresh,
                  tooltip: l10n.dashboardRefresh,
                  icon: const Icon(
                    LucideIcons.refreshCw,
                    size: AppIconSizes.small,
                  ),
                )
              : FilledButton.tonalIcon(
                  onPressed: onRefresh,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.medium,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: const Icon(
                    LucideIcons.refreshCw,
                    size: AppIconSizes.small,
                  ),
                  label: Text(l10n.dashboardRefresh),
                );
          final updated = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.clock,
                size: AppIconSizes.small,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: AppSpacing.xSmall),
              Flexible(
                child: Text(
                  l10n.dashboardUpdated(updatedAt),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                periodChips,
                const SizedBox(height: AppSpacing.medium),
                Row(
                  children: [
                    Expanded(child: branchField),
                    const SizedBox(width: AppSpacing.small),
                    refreshButton,
                  ],
                ),
                const SizedBox(height: AppSpacing.small),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: updated,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: periodChips),
              const SizedBox(width: AppSpacing.medium),
              SizedBox(width: 230, child: branchField),
              const SizedBox(width: AppSpacing.small),
              refreshButton,
              const SizedBox(width: AppSpacing.medium),
              updated,
            ],
          );
        },
      ),
    );
  }
}

/// Six headline numbers for the selected period and branch.
final class DashboardKpiGrid extends StatelessWidget {
  const DashboardKpiGrid({required this.kpis, super.key});

  final List<DashboardKpi> kpis;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1180
            ? 6
            : width >= 900
            ? 4
            : width >= 620
            ? 3
            : width >= 420
            ? 2
            : 1;
        final gap = AppSpacing.medium;
        final itemWidth = (width - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final kpi in kpis)
              SizedBox(
                width: itemWidth,
                child: _DashboardKpiCard(kpi: kpi),
              ),
          ],
        );
      },
    );
  }
}

final class _DashboardKpiCard extends StatelessWidget {
  const _DashboardKpiCard({required this.kpi});

  final DashboardKpi kpi;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AdminSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadii.medium),
                ),
                child: Icon(
                  dashboardKpiIcon(kpi.id),
                  size: AppIconSizes.small,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const Spacer(),
              AdminStatusPill(
                label: dashboardDelta(kpi.changePercent),
                tone: kpi.positive
                    ? AdminPillTone.success
                    : AdminPillTone.warning,
                icon: _trendIcon(kpi.trend),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(
            kpi.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              kpi.value,
              maxLines: 1,
              style: textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: AppSpacing.xSmall),
          Text(
            l10n.dashboardVsPrevious(dashboardDelta(kpi.changePercent)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

IconData _trendIcon(DashboardTrend trend) => switch (trend) {
  DashboardTrend.up => LucideIcons.arrowUpRight,
  DashboardTrend.down => LucideIcons.arrowDownRight,
  DashboardTrend.flat => LucideIcons.minus,
};

/// Revenue trend chart with profit, margin and order summary.
final class DashboardRevenueCard extends StatelessWidget {
  const DashboardRevenueCard({
    required this.series,
    required this.orders,
    required this.growth,
    required this.currency,
    super.key,
  });

  final List<RevenuePoint> series;
  final int orders;
  final double growth;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final revenue = series.fold<double>(0, (sum, point) => sum + point.revenue);
    final profit = series.fold<double>(0, (sum, point) => sum + point.profit);
    final margin = revenue == 0 ? 0.0 : profit / revenue * 100;

    final chart = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
            ),
            const SizedBox(width: AppSpacing.xSmall),
            Text(
              l10n.dashboardRevenue,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.centerEnd,
                child: Text(
                  dashboardMoney(revenue * 1000, currency),
                  style: textTheme.titleSmall,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.small),
        AdminAreaChart(
          height: 200,
          valueSuffix: 'k',
          points: [
            for (final point in series)
              AdminChartPoint(label: point.label, value: point.revenue),
          ],
        ),
      ],
    );

    final summary = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DashboardRevenueStat(
          icon: LucideIcons.trendingUp,
          label: l10n.dashboardProfit,
          value: dashboardMoney(profit * 1000, currency),
          color: colorScheme.tertiary,
        ),
        const Divider(height: AppSpacing.xLarge),
        _DashboardRevenueStat(
          icon: LucideIcons.shoppingBag,
          label: l10n.dashboardOrders,
          value: l10n.dashboardOrdersCount(dashboardInteger(orders)),
        ),
        const Divider(height: AppSpacing.xLarge),
        _DashboardRevenueStat(
          icon: LucideIcons.percent,
          label: l10n.dashboardMargin(dashboardPercent(margin)),
          value: l10n.dashboardVsPrevious(dashboardDelta(growth)),
        ),
      ],
    );

    return DashboardSection(
      title: l10n.dashboardRevenueProfit,
      subtitle: l10n.dashboardRevenueProfitHint,
      icon: LucideIcons.chartArea,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 780) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: chart),
                const SizedBox(width: AppSpacing.xLarge),
                Expanded(flex: 2, child: summary),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              chart,
              const SizedBox(height: AppSpacing.large),
              summary,
            ],
          );
        },
      ),
    );
  }
}

final class _DashboardRevenueStat extends StatelessWidget {
  const _DashboardRevenueStat({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final accent = color ?? colorScheme.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadii.medium),
          ),
          child: Icon(icon, size: AppIconSizes.small, color: accent),
        ),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Shortcut used by the quick actions card.
final class DashboardQuickAction {
  const DashboardQuickAction({
    required this.label,
    required this.icon,
    required this.moduleId,
  });

  final String label;
  final IconData icon;
  final AdminModuleId moduleId;
}

/// Counter and back-office shortcuts that point at the owning module.
final class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({
    required this.actions,
    required this.onAction,
    super.key,
  });

  final List<DashboardQuickAction> actions;
  final ValueChanged<DashboardQuickAction> onAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return DashboardSection(
      title: l10n.dashboardQuickActions,
      subtitle: l10n.dashboardQuickActionsHint,
      icon: LucideIcons.sparkles,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.small,
            children: [
              for (final action in actions)
                OutlinedButton.icon(
                  onPressed: () => onAction(action),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 40),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.medium,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: Icon(action.icon, size: AppIconSizes.small),
                  label: Text(action.label),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          Container(
            padding: const EdgeInsets.all(AppSpacing.medium),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(AppRadii.large),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  LucideIcons.listFilter,
                  size: AppIconSizes.small,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  child: Text(
                    l10n.dashboardActionHint(l10n.dashboardNewSale),
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Small footnote that marks the dashboard data as sample data.
final class DashboardSampleNote extends StatelessWidget {
  const DashboardSampleNote({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AdminSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            LucideIcons.scrollText,
            size: AppIconSizes.small,
            color: colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: Text(
              l10n.dashboardSampleNote,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Resolves a shortcut's owning module label without touching navigation.
String dashboardModuleLabel(DashboardQuickAction action, AppLocalizations l10n) =>
    AdminModules.byId(l10n, action.moduleId).label;
