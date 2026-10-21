import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../main/ui/widgets/admin_page_frame.dart';
import '../../domain/dashboard_models.dart';

/// Localized period labels used by the dashboard filter bar.
extension DashboardPeriodKeys on AppLocalizations {
  String dashboardPeriodLabel(DashboardPeriod period) => switch (period) {
    DashboardPeriod.last7 => dashboardLast7Days,
    DashboardPeriod.last30 => dashboardLast30Days,
    DashboardPeriod.last90 => dashboardLast90Days,
  };
}

/// Order labels and tones shared by the recent-orders table and the profile.
extension DashboardOrderKeys on AppLocalizations {
  String dashboardOrderStatus(OrderStatus status) => switch (status) {
    OrderStatus.paid => dashboardStatusPaid,
    OrderStatus.pending => statusPending,
    OrderStatus.shipping => dashboardStatusShipping,
    OrderStatus.delivered => statusDelivered,
    OrderStatus.cancelled => statusCancelled,
  };

  AdminPillTone dashboardOrderTone(OrderStatus status) => switch (status) {
    OrderStatus.paid => AdminPillTone.success,
    OrderStatus.pending => AdminPillTone.warning,
    OrderStatus.shipping => AdminPillTone.primary,
    OrderStatus.delivered => AdminPillTone.success,
    OrderStatus.cancelled => AdminPillTone.muted,
  };
}

/// Customer segmentation labels.
extension DashboardRfmKeys on AppLocalizations {
  String dashboardRfmLabel(RfmSegment segment) => switch (segment) {
    RfmSegment.champions => dashboardRfmChampions,
    RfmSegment.loyal => dashboardRfmLoyal,
    RfmSegment.potential => dashboardRfmPotential,
    RfmSegment.newCustomers => dashboardRfmNew,
    RfmSegment.atRisk => dashboardRfmAtRisk,
    RfmSegment.lost => dashboardRfmLost,
  };

  AdminPillTone dashboardRfmTone(RfmSegment segment) => switch (segment) {
    RfmSegment.champions => AdminPillTone.success,
    RfmSegment.loyal => AdminPillTone.primary,
    RfmSegment.potential => AdminPillTone.primary,
    RfmSegment.newCustomers => AdminPillTone.primary,
    RfmSegment.atRisk => AdminPillTone.warning,
    RfmSegment.lost => AdminPillTone.muted,
  };
}

/// Loyalty tier labels.
extension DashboardTierKeys on AppLocalizations {
  String dashboardTierLabel(LoyaltyTier tier) => switch (tier) {
    LoyaltyTier.bronze => dashboardTierBronze,
    LoyaltyTier.silver => dashboardTierSilver,
    LoyaltyTier.gold => dashboardTierGold,
    LoyaltyTier.platinum => dashboardTierPlatinum,
  };
}

/// Sales-floor inquiry outcome labels.
extension DashboardInquiryKeys on AppLocalizations {
  String dashboardInquiryLabel(InquiryOutcome outcome) => switch (outcome) {
    InquiryOutcome.bought => dashboardInquiryBought,
    InquiryOutcome.price => dashboardInquiryPrice,
    InquiryOutcome.noStock => dashboardInquiryNoStock,
    InquiryOutcome.justAsking => dashboardInquiryJustAsking,
  };

  AdminPillTone dashboardInquiryTone(InquiryOutcome outcome) =>
      switch (outcome) {
        InquiryOutcome.bought => AdminPillTone.success,
        InquiryOutcome.price => AdminPillTone.primary,
        InquiryOutcome.noStock => AdminPillTone.warning,
        InquiryOutcome.justAsking => AdminPillTone.muted,
      };
}

/// Warranty claim labels.
extension DashboardClaimKeys on AppLocalizations {
  String dashboardClaimLabel(ClaimStatus status) => switch (status) {
    ClaimStatus.open => dashboardClaimOpen,
    ClaimStatus.inspection => dashboardClaimInspection,
    ClaimStatus.resolved => dashboardClaimResolved,
  };

  AdminPillTone dashboardClaimTone(ClaimStatus status) => switch (status) {
    ClaimStatus.open => AdminPillTone.warning,
    ClaimStatus.inspection => AdminPillTone.primary,
    ClaimStatus.resolved => AdminPillTone.success,
  };
}

/// Audit trail action labels.
extension DashboardAuditKeys on AppLocalizations {
  String dashboardAuditLabel(AuditAction action) => switch (action) {
    AuditAction.transfer => dashboardAuditTransfer,
    AuditAction.adjustment => dashboardAuditAdjustment,
    AuditAction.priceChange => dashboardAuditPrice,
    AuditAction.shiftClosed => dashboardAuditShift,
    AuditAction.warranty => dashboardAuditWarranty,
    AuditAction.purchaseReceipt => dashboardAuditPurchase,
  };

  AdminPillTone dashboardAuditTone(AuditAction action) => switch (action) {
    AuditAction.transfer => AdminPillTone.primary,
    AuditAction.adjustment => AdminPillTone.warning,
    AuditAction.priceChange => AdminPillTone.primary,
    AuditAction.shiftClosed => AdminPillTone.muted,
    AuditAction.warranty => AdminPillTone.warning,
    AuditAction.purchaseReceipt => AdminPillTone.success,
  };
}

/// Color that matches [AdminStatusPill] tones for bars and markers.
Color dashboardPillColor(AdminPillTone tone, ColorScheme colorScheme) =>
    switch (tone) {
      AdminPillTone.primary => colorScheme.primary,
      AdminPillTone.success => const Color(0xFF1B8A5A),
      AdminPillTone.warning => const Color(0xFFB26A00),
      AdminPillTone.muted => colorScheme.onSurfaceVariant,
    };

/// Icon shown beside each headline KPI.
IconData dashboardKpiIcon(DashboardKpiId id) => switch (id) {
  DashboardKpiId.revenue => LucideIcons.banknote,
  DashboardKpiId.profit => LucideIcons.trendingUp,
  DashboardKpiId.orders => LucideIcons.shoppingBag,
  DashboardKpiId.averageOrder => LucideIcons.receipt,
  DashboardKpiId.customers => LucideIcons.usersRound,
  DashboardKpiId.lowStock => LucideIcons.triangleAlert,
};

/// Surface card with a consistent dashboard heading.
final class DashboardSection extends StatelessWidget {
  const DashboardSection({
    required this.title,
    required this.child,
    super.key,
    this.subtitle,
    this.icon,
    this.trailing,
    this.padding,
  });

  final String title;
  final Widget child;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      padding: padding ?? const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSectionHeading(
            title: title,
            subtitle: subtitle,
            icon: icon,
            trailing: trailing,
          ),
          const SizedBox(height: AppSpacing.medium),
          child,
        ],
      ),
    );
  }
}

/// Two dashboard cards side by side on wide screens and stacked otherwise.
final class DashboardSplit extends StatelessWidget {
  const DashboardSplit({
    required this.leading,
    required this.trailing,
    super.key,
    this.breakpoint = 860,
    this.leadingFlex = 3,
    this.trailingFlex = 2,
  });

  final Widget leading;
  final Widget trailing;
  final double breakpoint;
  final int leadingFlex;
  final int trailingFlex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= breakpoint) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: leadingFlex, child: leading),
              const SizedBox(width: AppSpacing.medium),
              Expanded(flex: trailingFlex, child: trailing),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            leading,
            const SizedBox(height: AppSpacing.medium),
            trailing,
          ],
        );
      },
    );
  }
}

/// Column description for [DashboardTable].
final class DashboardTableColumn {
  const DashboardTableColumn({
    required this.label,
    this.flex = 1,
    this.align = AlignmentDirectional.centerStart,
  });

  final String label;
  final int flex;
  final AlignmentGeometry align;
}

/// One value inside a [DashboardTableRow].
final class DashboardTableCell {
  const DashboardTableCell(
    this.value, {
    this.secondary,
    this.child,
    this.align,
  });

  final String value;
  final String? secondary;
  final Widget? child;
  final AlignmentGeometry? align;
}

/// One record rendered by [DashboardTable].
final class DashboardTableRow {
  const DashboardTableRow(this.cells);

  final List<DashboardTableCell> cells;
}

/// Responsive table that stacks label/value pairs when space is tight.
final class DashboardTable extends StatelessWidget {
  const DashboardTable({
    required this.columns,
    required this.rows,
    super.key,
    this.onRowTap,
    this.breakpoint = 720,
    this.emptyMessage,
  });

  final List<DashboardTableColumn> columns;
  final List<DashboardTableRow> rows;
  final ValueChanged<int>? onRowTap;
  final double breakpoint;
  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.localeKeys;

    if (rows.isEmpty) {
      return DashboardEmptyState(
        icon: LucideIcons.inbox,
        title: l10n.sectionEmptyTitle,
        message: emptyMessage ?? l10n.dashboardEmpty,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= breakpoint;
        final divider = Divider(
          height: 1,
          thickness: AppControlSizes.dividerThickness,
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (wide) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xSmall,
                  vertical: AppSpacing.small,
                ),
                child: Row(
                  children: [
                    for (final column in columns)
                      Expanded(
                        flex: column.flex,
                        child: Align(
                          alignment: column.align,
                          child: Text(
                            column.label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              divider,
            ],
            for (var index = 0; index < rows.length; index++) ...[
              if (index > 0) divider,
              _DashboardTableRecord(
                row: rows[index],
                columns: columns,
                wide: wide,
                onTap: onRowTap == null ? null : () => onRowTap!(index),
              ),
            ],
          ],
        );
      },
    );
  }
}

final class _DashboardTableRecord extends StatelessWidget {
  const _DashboardTableRecord({
    required this.row,
    required this.columns,
    required this.wide,
    this.onTap,
  });

  final DashboardTableRow row;
  final List<DashboardTableColumn> columns;
  final bool wide;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadii.medium);

    return InkWell(
      onTap: onTap,
      borderRadius: radius,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xSmall,
          vertical: AppSpacing.small,
        ),
        child: wide ? _wideRow(context) : _compactRow(context),
      ),
    );
  }

  Widget _wideRow(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < columns.length; index++)
          Expanded(
            flex: columns[index].flex,
            child: Align(
              alignment: row.cells[index].align ?? columns[index].align,
              child: _cellContent(context, row.cells[index]),
            ),
          ),
      ],
    );
  }

  Widget _compactRow(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final labelStyle = Theme.of(context).textTheme.labelSmall
        ?.copyWith(color: colorScheme.onSurfaceVariant);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < columns.length; index++)
          Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : AppSpacing.xSmall),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    columns[index].label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: labelStyle,
                  ),
                ),
                const SizedBox(width: AppSpacing.small),
                Expanded(
                  flex: 3,
                  child: Align(
                    alignment:
                        row.cells[index].align ??
                        AlignmentDirectional.centerEnd,
                    child: _cellContent(context, row.cells[index]),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _cellContent(BuildContext context, DashboardTableCell cell) {
    if (cell.child != null) {
      return cell.child!;
    }
    return _DashboardCellValue(value: cell.value, secondary: cell.secondary);
  }
}

final class _DashboardCellValue extends StatelessWidget {
  const _DashboardCellValue({required this.value, this.secondary});

  final String value;
  final String? secondary;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (secondary == null) {
      return Text(
        value,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: textTheme.bodySmall,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall,
        ),
        const SizedBox(height: 1),
        Text(
          secondary!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Thin progress bar used for shares and stock cover.
final class DashboardProgressBar extends StatelessWidget {
  const DashboardProgressBar({
    required this.value,
    super.key,
    this.color,
    this.height = 6,
  });

  /// Percentage from `0` to `100`.
  final double value;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fraction = (value.clamp(0, 100)) / 100;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.pill),
      child: Container(
        height: height,
        color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        alignment: AlignmentDirectional.centerStart,
        child: FractionallySizedBox(
          widthFactor: fraction,
          heightFactor: 1,
          child: ColoredBox(color: color ?? colorScheme.primary),
        ),
      ),
    );
  }
}

/// Empty or no-result block used by every dashboard table.
final class DashboardEmptyState extends StatelessWidget {
  const DashboardEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.large),
      child: Column(
        children: [
          Icon(icon, size: AppIconSizes.large, color: colorScheme.primary),
          const SizedBox(height: AppSpacing.small),
          Text(title, style: textTheme.titleSmall, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.xSmall),
          Text(
            message,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (action != null) ...[
            const SizedBox(height: AppSpacing.medium),
            action!,
          ],
        ],
      ),
    );
  }
}

/// Search field used by the paginated customer list.
final class DashboardSearchField extends StatelessWidget {
  const DashboardSearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onClear,
    super.key,
    this.showClear = false,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final bool showClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        isDense: true,
        hintText: hint,
        prefixIcon: const Icon(LucideIcons.search, size: AppIconSizes.small),
        suffixIcon: showClear
            ? IconButton(
                onPressed: onClear,
                tooltip: context.localeKeys.sectionClearSearch,
                icon: const Icon(LucideIcons.x, size: AppIconSizes.small),
              )
            : null,
      ),
    );
  }
}

/// Compact pagination footer reused by dashboard lists.
final class DashboardPagination extends StatelessWidget {
  const DashboardPagination({
    required this.page,
    required this.pageCount,
    required this.pageSize,
    required this.total,
    required this.onPageChanged,
    required this.onPageSizeChanged,
    super.key,
    this.pageSizeOptions = const <int>[4, 8, 12],
  });

  final int page;
  final int pageCount;
  final int pageSize;
  final int total;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPageSizeChanged;
  final List<int> pageSizeOptions;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final from = total == 0 ? 0 : page * pageSize + 1;
    final to = math.min((page + 1) * pageSize, total);

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 560;
        final veryCompact = constraints.maxWidth < 420;
        final pageLabel = compact
            ? '${page + 1}/$pageCount'
            : l10n.paginationPageOf(page + 1, pageCount);
        final iconButtonStyle = IconButton.styleFrom(
          minimumSize: const Size(32, 32),
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );

        final controls = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!veryCompact) ...[
              Text(
                l10n.paginationPerPage,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.xSmall),
            ],
            DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: pageSize,
                isDense: true,
                iconSize: AppIconSizes.small,
                style: textTheme.labelMedium,
                items: [
                  for (final size in pageSizeOptions)
                    DropdownMenuItem(value: size, child: Text('$size')),
                ],
                onChanged: (value) {
                  if (value != null) onPageSizeChanged(value);
                },
              ),
            ),
            const SizedBox(width: AppSpacing.small),
            Text(
              pageLabel,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: AppSpacing.xSmall),
            IconButton(
              onPressed: page > 0 ? () => onPageChanged(page - 1) : null,
              tooltip: l10n.paginationPrevious,
              style: iconButtonStyle,
              icon: Icon(
                isRtl ? LucideIcons.chevronRight : LucideIcons.chevronLeft,
                size: AppIconSizes.small,
              ),
            ),
            IconButton(
              onPressed: page < pageCount - 1
                  ? () => onPageChanged(page + 1)
                  : null,
              tooltip: l10n.paginationNext,
              style: iconButtonStyle,
              icon: Icon(
                isRtl ? LucideIcons.chevronLeft : LucideIcons.chevronRight,
                size: AppIconSizes.small,
              ),
            ),
          ],
        );

        final summary = Text(
          l10n.paginationShowing(from, to, total),
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              summary,
              const SizedBox(height: AppSpacing.xSmall),
              Align(alignment: AlignmentDirectional.centerEnd, child: controls),
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: summary),
            const SizedBox(width: AppSpacing.small),
            controls,
          ],
        );
      },
    );
  }
}

/// Bordered label/value tile used inside the customer profile.
final class DashboardFact extends StatelessWidget {
  const DashboardFact({
    required this.label,
    required this.value,
    super.key,
    this.icon,
    this.color,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final accent = color ?? colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.large),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: AppIconSizes.small, color: accent),
            const SizedBox(width: AppSpacing.small),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
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
      ),
    );
  }
}
