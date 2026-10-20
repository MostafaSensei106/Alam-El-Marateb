import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../main/ui/widgets/admin_page_frame.dart';
import '../../domain/dashboard_models.dart';
import 'dashboard_shared.dart';

/// Customer segments with customer count, monetary value and share.
final class DashboardRfmCard extends StatelessWidget {
  const DashboardRfmCard({
    required this.slices,
    required this.currency,
    super.key,
  });

  final List<RfmSlice> slices;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DashboardSection(
      title: l10n.dashboardRfm,
      subtitle: l10n.dashboardRfmHint,
      icon: LucideIcons.usersRound,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < slices.length; index++) ...[
            if (index > 0) const SizedBox(height: AppSpacing.medium),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.dashboardRfmLabel(slices[index].segment),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(width: AppSpacing.small),
                Text(
                  dashboardPercent(slices[index].share),
                  style: textTheme.labelMedium,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xSmall),
            DashboardProgressBar(
              value: slices[index].share,
              height: 4,
              color: dashboardPillColor(
                l10n.dashboardRfmTone(slices[index].segment),
                colorScheme,
              ),
            ),
            const SizedBox(height: AppSpacing.xSmall),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.dashboardRfmCustomers}: '
                    '${dashboardInteger(slices[index].customers)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.small),
                Text(
                  '${l10n.dashboardRfmMonetary}: '
                  '${dashboardMoney(slices[index].monetary, currency)}',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Delivery demand per governorate with revenue and share bars.
final class DashboardGeoCard extends StatelessWidget {
  const DashboardGeoCard({
    required this.cells,
    required this.currency,
    super.key,
  });

  final List<GeoCell> cells;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return DashboardSection(
      title: l10n.dashboardGeo,
      subtitle: l10n.dashboardGeoHint,
      icon: LucideIcons.mapPinned,
      trailing: cells.isEmpty
          ? null
          : AdminStatusPill(
              label: cells.first.governorate,
              tone: AdminPillTone.primary,
              icon: LucideIcons.mapPinned,
            ),
      child: cells.isEmpty
          ? DashboardEmptyState(
              icon: LucideIcons.mapPinned,
              title: l10n.sectionEmptyTitle,
              message: l10n.dashboardEmpty,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var index = 0; index < cells.length; index++) ...[
                  if (index > 0) const SizedBox(height: AppSpacing.medium),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          cells[index].governorate,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.small),
                      Text(
                        l10n.dashboardOrderCount(
                          dashboardInteger(cells[index].orders),
                        ),
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xSmall),
                  Row(
                    children: [
                      Expanded(
                        child: DashboardProgressBar(
                          value: cells[index].share,
                          height: 4,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.small),
                      SizedBox(
                        width: 44,
                        child: Text(
                          dashboardPercent(cells[index].share),
                          textAlign: TextAlign.end,
                          style: textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dashboardMoney(cells[index].revenue, currency),
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
    );
  }
}

/// Stock cover for variants across warehouses.
final class DashboardVelocityCard extends StatelessWidget {
  const DashboardVelocityCard({required this.rows, super.key});

  final List<VelocityRow> rows;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;

    return DashboardSection(
      title: l10n.dashboardVelocity,
      subtitle: l10n.dashboardVelocityHint,
      icon: LucideIcons.activity,
      child: DashboardTable(
        columns: [
          DashboardTableColumn(label: l10n.dashboardProduct, flex: 3),
          DashboardTableColumn(label: l10n.dashboardWarehouse, flex: 2),
          DashboardTableColumn(
            label: l10n.dashboardSold30d,
            align: AlignmentDirectional.centerEnd,
          ),
          DashboardTableColumn(
            label: l10n.dashboardCurrentQty,
            align: AlignmentDirectional.centerEnd,
          ),
          DashboardTableColumn(
            label: l10n.dashboardDaysOfCover,
            flex: 2,
            align: AlignmentDirectional.centerEnd,
          ),
        ],
        rows: [
          for (final row in rows)
            DashboardTableRow([
              DashboardTableCell(row.product, secondary: row.variant),
              DashboardTableCell(row.warehouse),
              DashboardTableCell(dashboardInteger(row.sold30d)),
              DashboardTableCell(dashboardInteger(row.currentQty)),
              DashboardTableCell(
                '',
                child: _CoverPill(row: row),
                align: AlignmentDirectional.centerEnd,
              ),
            ]),
        ],
      ),
    );
  }
}

final class _CoverPill extends StatelessWidget {
  const _CoverPill({required this.row});

  final VelocityRow row;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;

    if (row.currentQty == 0) {
      return AdminStatusPill(
        label: l10n.dashboardCoverOut,
        tone: AdminPillTone.warning,
        icon: LucideIcons.circleAlert,
      );
    }
    if (row.daysOfCover < 14) {
      return AdminStatusPill(
        label: l10n.dashboardCoverLow,
        tone: AdminPillTone.warning,
        icon: LucideIcons.triangleAlert,
      );
    }
    return AdminStatusPill(
      label: l10n.dashboardCoverHealthy,
      tone: AdminPillTone.success,
      icon: LucideIcons.circleCheck,
    );
  }
}

/// Best sellers by revenue with quantity and share.
final class DashboardTopProductsCard extends StatelessWidget {
  const DashboardTopProductsCard({
    required this.products,
    required this.currency,
    super.key,
  });

  final List<TopProduct> products;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;

    return DashboardSection(
      title: l10n.dashboardTopProducts,
      subtitle: l10n.dashboardTopProductsHint,
      icon: LucideIcons.packageSearch,
      child: DashboardTable(
        columns: [
          DashboardTableColumn(label: l10n.dashboardProduct, flex: 3),
          DashboardTableColumn(
            label: l10n.dashboardTopProductQty,
            align: AlignmentDirectional.centerEnd,
          ),
          DashboardTableColumn(
            label: l10n.dashboardTopProductRevenue,
            flex: 2,
            align: AlignmentDirectional.centerEnd,
          ),
          DashboardTableColumn(
            label: l10n.dashboardTopProductShare,
            flex: 2,
            align: AlignmentDirectional.centerEnd,
          ),
        ],
        rows: [
          for (final product in products)
            DashboardTableRow([
              DashboardTableCell(product.name, secondary: product.category),
              DashboardTableCell(dashboardInteger(product.quantity)),
              DashboardTableCell(dashboardMoney(product.revenue, currency)),
              DashboardTableCell(
                '',
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      dashboardPercent(product.share),
                      style: textTheme.labelSmall,
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      width: 64,
                      child: DashboardProgressBar(
                        value: product.share,
                        height: 4,
                      ),
                    ),
                  ],
                ),
                align: AlignmentDirectional.centerEnd,
              ),
            ]),
        ],
      ),
    );
  }
}

/// Most asked products with missed-sale counters.
final class DashboardTopAskedCard extends StatelessWidget {
  const DashboardTopAskedCard({required this.products, super.key});

  final List<TopAskedProduct> products;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final maxAsked = products.isEmpty
        ? 0
        : products.map((product) => product.asked).reduce(math.max);

    return DashboardSection(
      title: l10n.dashboardTopAsked,
      subtitle: l10n.dashboardTopAskedHint,
      icon: LucideIcons.messageCircleQuestion,
      child: DashboardTable(
        columns: [
          DashboardTableColumn(label: l10n.dashboardProduct, flex: 4),
          DashboardTableColumn(
            label: l10n.dashboardAsked,
            flex: 2,
            align: AlignmentDirectional.centerEnd,
          ),
          DashboardTableColumn(
            label: l10n.dashboardNoStockAsked,
            align: AlignmentDirectional.centerEnd,
          ),
          DashboardTableColumn(
            label: l10n.dashboardPriceAsked,
            align: AlignmentDirectional.centerEnd,
          ),
        ],
        rows: [
          for (final product in products)
            DashboardTableRow([
              DashboardTableCell(product.product),
              DashboardTableCell(
                '',
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      dashboardInteger(product.asked),
                      style: textTheme.labelMedium,
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      width: 56,
                      child: DashboardProgressBar(
                        value: maxAsked == 0
                            ? 0
                            : product.asked / maxAsked * 100,
                        height: 4,
                      ),
                    ),
                  ],
                ),
                align: AlignmentDirectional.centerEnd,
              ),
              DashboardTableCell(dashboardInteger(product.noStock)),
              DashboardTableCell(dashboardInteger(product.priceAsks)),
            ]),
        ],
      ),
    );
  }
}

/// Recent stock and sales changes in a compact timeline.
final class DashboardAuditTrailCard extends StatelessWidget {
  const DashboardAuditTrailCard({required this.events, super.key});

  final List<AuditEvent> events;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;

    return DashboardSection(
      title: l10n.dashboardAuditTrail,
      subtitle: l10n.dashboardAuditHint,
      icon: LucideIcons.history,
      trailing: AdminStatusPill(
        label: dashboardInteger(events.length),
        icon: LucideIcons.history,
      ),
      child: events.isEmpty
          ? DashboardEmptyState(
              icon: LucideIcons.history,
              title: l10n.sectionEmptyTitle,
              message: l10n.dashboardEmpty,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var index = 0; index < events.length; index++) ...[
                  if (index > 0)
                    Divider(
                      height: AppSpacing.large,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  _AuditEventRow(event: events[index]),
                ],
              ],
            ),
    );
  }
}

final class _AuditEventRow extends StatelessWidget {
  const _AuditEventRow({required this.event});

  final AuditEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tone = l10n.dashboardAuditTone(event.action);
    final color = dashboardPillColor(tone, colorScheme);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppRadii.medium),
          ),
          child: Icon(
            LucideIcons.clipboardList,
            size: AppIconSizes.small,
            color: color,
          ),
        ),
        const SizedBox(width: AppSpacing.small),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      l10n.dashboardAuditLabel(event.action),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.small),
                  Text(
                    event.at,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                event.detail,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
              const SizedBox(height: 2),
              Text(
                '${event.entity} · ${l10n.dashboardAuditBy(event.actor)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
