import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  '128,540 $currency',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Text(
                '${l10n.dashboardAverageOrder} · 1,150 $currency',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          SizedBox(
            height: 190,
            width: double.infinity,
            child: CustomPaint(
              painter: _RevenueChartPainter(
                lineColor: colorScheme.primary,
                fillColor: colorScheme.primary.withValues(alpha: 0.18),
                gridColor: colorScheme.outlineVariant.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Smooth area chart drawn from a fixed sample series.
final class _RevenueChartPainter extends CustomPainter {
  const _RevenueChartPainter({
    required this.lineColor,
    required this.fillColor,
    required this.gridColor,
  });

  final Color lineColor;
  final Color fillColor;
  final Color gridColor;

  static const List<double> _points = [
    0.30,
    0.45,
    0.36,
    0.62,
    0.54,
    0.80,
    0.70,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var index = 0; index <= 3; index++) {
      final y = size.height * index / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final points = <Offset>[
      for (var index = 0; index < _points.length; index++)
        Offset(
          size.width * index / (_points.length - 1),
          size.height * (1 - _points[index]),
        ),
    ];

    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (var index = 1; index < points.length; index++) {
      final previous = points[index - 1];
      final current = points[index];
      final midX = (previous.dx + current.dx) / 2;
      line.cubicTo(midX, previous.dy, midX, current.dy, current.dx, current.dy);
    }

    final area = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [fillColor, fillColor.withValues(alpha: 0)],
        ).createShader(Offset.zero & size),
    );

    canvas.drawPath(
      line,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    final dotPaint = Paint()..color = lineColor;
    for (final point in points) {
      canvas.drawCircle(point, 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_RevenueChartPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.gridColor != gridColor;
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
        total: '1,250',
      ),
      (
        id: '#1041',
        customer: l10n.sampleCustomer2,
        status: l10n.dashboardStatusShipping,
        tone: AdminPillTone.primary,
        total: '740',
      ),
      (
        id: '#1040',
        customer: l10n.sampleCustomer3,
        status: l10n.dashboardStatusPending,
        tone: AdminPillTone.warning,
        total: '2,180',
      ),
      (
        id: '#1039',
        customer: l10n.sampleCustomer4,
        status: l10n.dashboardStatusPaid,
        tone: AdminPillTone.success,
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
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(l10n.dashboardOrder, style: headerStyle),
              ),
              Expanded(
                flex: 2,
                child: Text(l10n.dashboardStatus, style: headerStyle),
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
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
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
      ),
    );
  }
}

void _showComingSoon(BuildContext context) {
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text(context.localeKeys.screenComingSoon)));
}
