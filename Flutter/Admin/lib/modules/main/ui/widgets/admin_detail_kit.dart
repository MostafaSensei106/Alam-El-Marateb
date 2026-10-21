import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../navigation/admin_section_catalog.dart';
import 'admin_page_frame.dart';
import 'admin_workspace_shared.dart';

/// Building blocks shared by the bespoke module workspaces.
///
/// The generic [AdminSectionWorkspace] draws a four-column sample table. Real
/// modules carry wider schemas (stock balances, payment methods, price lists),
/// so they compose these smaller pieces instead of duplicating the same table,
/// metric strip and planned-state banner in every module.

/// Formats an integer with thousands separators.
String adminGroupDigits(num value) {
  final rounded = value.round();
  final negative = rounded < 0;
  final digits = rounded.abs().toString();
  final buffer = StringBuffer();

  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) buffer.write(',');
    buffer.write(digits[index]);
  }

  return '${negative ? '-' : ''}$buffer';
}

/// Formats a money amount using the active currency label.
String adminFormatAmount(BuildContext context, num value) =>
    '${adminGroupDigits(value)} ${context.localeKeys.currencyEgp}';

/// Formats a compact percentage such as `74%`.
String adminFormatPercent(double value) => '${value.round()}%';

/// Colors one status pill tone consistently across the bespoke workspaces.
Color adminToneColor(ColorScheme colorScheme, AdminPillTone tone) =>
    switch (tone) {
      AdminPillTone.primary => colorScheme.primary,
      AdminPillTone.success => const Color(0xFF1B8A5A),
      AdminPillTone.warning => const Color(0xFFB26A00),
      AdminPillTone.muted => colorScheme.onSurfaceVariant,
    };

/// One column of an [AdminDataTable].
final class AdminTableColumn {
  const AdminTableColumn({
    required this.label,
    this.flex = 1,
    this.alignEnd = false,
    this.hideBelow = 0,
  });

  final String label;
  final int flex;
  final bool alignEnd;

  /// Columns with a breakpoint wider than the available width are dropped so
  /// the table keeps fitting beside a collapsed navigation rail.
  final double hideBelow;
}

/// One row of an [AdminDataTable]. [cells] must match the column count.
final class AdminTableRow {
  const AdminTableRow(this.cells, {this.onTap});

  final List<Widget> cells;
  final VoidCallback? onTap;
}

/// Dense, theme-aware table with flexible columns and hairline row dividers.
final class AdminDataTable extends StatelessWidget {
  const AdminDataTable({
    required this.columns,
    required this.rows,
    super.key,
    this.rowHeight = 54,
  });

  final List<AdminTableColumn> columns;
  final List<AdminTableRow> rows;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AdminSurfaceCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final visible = <int>[
            for (var index = 0; index < columns.length; index++)
              if (constraints.maxWidth >= columns[index].hideBelow) index,
          ];

          Widget rowFrame({
            required int index,
            required Widget child,
            bool header = false,
          }) {
            final isLast = index == rows.length - 1;

            return DecoratedBox(
              decoration: BoxDecoration(
                border: header || isLast || rows.isEmpty
                    ? null
                    : Border(
                        bottom: BorderSide(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.45,
                          ),
                        ),
                      ),
              ),
              child: child,
            );
          }

          Widget cells({required List<Widget> children}) => Row(
            children: [
              for (final index in visible)
                Expanded(
                  flex: columns[index].flex,
                  child: Align(
                    alignment: columns[index].alignEnd
                        ? AlignmentDirectional.centerEnd
                        : AlignmentDirectional.centerStart,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xSmall,
                        vertical: AppSpacing.small,
                      ),
                      child: children[index],
                    ),
                  ),
                ),
            ],
          );

          final header = rowFrame(
            index: -1,
            header: true,
            child: cells(
              children: [
                for (final column in columns)
                  Text(
                    column.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              header,
              for (var index = 0; index < rows.length; index++)
                rowFrame(
                  index: index,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: rows[index].onTap,
                      borderRadius: BorderRadius.circular(AppRadii.small),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: rowHeight),
                        child: cells(
                          children: rows[index].cells,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// One option of an [AdminFilterChips] strip.
final class AdminFilterOption<T> {
  const AdminFilterOption({
    required this.value,
    required this.label,
    this.count,
  });

  final T value;
  final String label;
  final int? count;
}

/// Color-only filter pills. No borders and no check mark: the selected chip
/// simply swaps to the primary container color.
final class AdminFilterChips<T> extends StatelessWidget {
  const AdminFilterChips({
    required this.options,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<AdminFilterOption<T>> options;
  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Wrap(
      spacing: AppSpacing.small,
      runSpacing: AppSpacing.small,
      children: [
        for (final option in options)
          Material(
            color: option.value == selected
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppRadii.pill),
            child: InkWell(
              onTap: () => onSelected(option.value),
              borderRadius: BorderRadius.circular(AppRadii.pill),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium,
                  vertical: AppSpacing.small,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      option.label,
                      style: textTheme.labelMedium?.copyWith(
                        color: option.value == selected
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (option.count != null) ...[
                      const SizedBox(width: AppSpacing.xSmall),
                      Text(
                        adminGroupDigits(option.count!),
                        style: textTheme.labelSmall?.copyWith(
                          color: option.value == selected
                              ? colorScheme.onPrimaryContainer.withValues(
                                  alpha: 0.7,
                                )
                              : colorScheme.onSurfaceVariant.withValues(
                                  alpha: 0.7,
                                ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// One figure of an [AdminMetricStrip].
final class AdminMetric {
  const AdminMetric({
    required this.label,
    required this.value,
    required this.icon,
    this.tone = AdminPillTone.muted,
    this.hint,
  });

  final String label;
  final String value;
  final IconData icon;
  final AdminPillTone tone;
  final String? hint;
}

/// Responsive strip of compact KPI cards.
final class AdminMetricStrip extends StatelessWidget {
  const AdminMetricStrip({required this.metrics, super.key});

  final List<AdminMetric> metrics;

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 720.0;
        final columns = (width / 220).floor().clamp(1, metrics.length);
        final itemWidth =
            (width - AppSpacing.small * (columns - 1)) / columns;

        return Wrap(
          spacing: AppSpacing.small,
          runSpacing: AppSpacing.small,
          children: [
            for (final metric in metrics)
              SizedBox(
                width: itemWidth,
                child: _AdminMetricCard(metric: metric),
              ),
          ],
        );
      },
    );
  }
}

final class _AdminMetricCard extends StatelessWidget {
  const _AdminMetricCard({required this.metric});

  final AdminMetric metric;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tone = adminToneColor(colorScheme, metric.tone);

    return AdminSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: tone.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadii.small),
                ),
                child: Icon(metric.icon, size: AppIconSizes.small, color: tone),
              ),
              const SizedBox(width: AppSpacing.small),
              Expanded(
                child: Text(
                  metric.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            metric.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium?.copyWith(color: tone),
          ),
          if (metric.hint != null) ...[
            const SizedBox(height: AppSpacing.xSmall),
            Text(
              metric.hint!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

/// Responsive grid of cards.
///
/// Modules such as catalog categories, warehouses and promotions are card
/// grids rather than tables; this keeps their wrapping math in one place.
final class AdminCardGrid extends StatelessWidget {
  const AdminCardGrid({
    required this.children,
    super.key,
    this.minWidth = 240,
    this.spacing = AppSpacing.medium,
  });

  final List<Widget> children;
  final double minWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : minWidth;
        final columns = ((width + spacing) / (minWidth + spacing))
            .floor()
            .clamp(1, children.length);
        final itemWidth = (width - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children)
              SizedBox(width: itemWidth, child: child),
          ],
        );
      },
    );
  }
}

/// Banner used by sections whose endpoint is not available yet.
final class AdminPlannedNotice extends StatelessWidget {
  const AdminPlannedNotice({super.key, this.title, this.body});

  final String? title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tone = adminToneColor(colorScheme, AdminPillTone.warning);

    return AdminSurfaceCard(
      color: tone.withValues(alpha: 0.09),
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(LucideIcons.clock, size: AppIconSizes.medium, color: tone),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? l10n.plannedNoticeTitle,
                  style: textTheme.titleSmall?.copyWith(color: tone),
                ),
                const SizedBox(height: AppSpacing.xSmall),
                Text(
                  body ?? l10n.plannedNoticeBody,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
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

/// Deterministic product thumbnail used instead of remote imagery.
final class AdminProductThumb extends StatelessWidget {
  const AdminProductThumb({
    required this.seed,
    super.key,
    this.icon = LucideIcons.package,
    this.size = 40,
  });

  final int seed;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final palette = <(Color, Color)>[
      (colorScheme.primaryContainer, colorScheme.onPrimaryContainer),
      (colorScheme.secondaryContainer, colorScheme.onSecondaryContainer),
      (colorScheme.tertiaryContainer, colorScheme.onTertiaryContainer),
      (colorScheme.surfaceContainerHighest, colorScheme.onSurfaceVariant),
    ];
    final (background, foreground) = palette[seed.abs() % palette.length];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadii.small),
      ),
      child: Icon(icon, size: size * 0.45, color: foreground),
    );
  }
}

/// Slim capacity / usage bar without any border.
final class AdminMeterBar extends StatelessWidget {
  const AdminMeterBar({
    required this.value,
    super.key,
    this.color,
    this.height = 6,
  });

  /// Normalized value, clamped to `0..1`.
  final double value;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final safeValue = value.isFinite ? value.clamp(0.0, 1.0) : 0.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.pill),
      child: SizedBox(
        height: height,
        child: ColoredBox(
          color: colorScheme.surfaceContainerHighest,
          child: FractionallySizedBox(
            alignment: AlignmentDirectional.centerStart,
            widthFactor: safeValue,
            child: ColoredBox(color: color ?? colorScheme.primary),
          ),
        ),
      ),
    );
  }
}

/// Pagination snapshot shared by the bespoke workspaces.
///
/// Exposing plain values keeps the workspaces free of paging math while still
/// letting them drive [AdminPaginationBar].
final class AdminListState<T> {
  const AdminListState({
    required this.controller,
    required this.term,
    required this.filtered,
    required this.visible,
    required this.page,
    required this.pageCount,
    required this.pageSize,
    required this.from,
    required this.to,
    required this.total,
    required this.onPageChanged,
    required this.onPageSizeChanged,
  });

  final TextEditingController controller;
  final String term;
  final List<T> filtered;
  final List<T> visible;
  final int page;
  final int pageCount;
  final int pageSize;
  final int from;
  final int to;
  final int total;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPageSizeChanged;

  bool get hasQuery => term.isNotEmpty;
  bool get isEmpty => filtered.isEmpty;
  bool get isNotEmpty => filtered.isNotEmpty;
}

/// Local search + pagination for sample records.
///
/// Mirrors the interaction of [AdminSectionWorkspace]: typing filters the list,
/// clears back to page one and never touches the network.
AdminListState<T> useAdminRecordList<T>({
  required List<T> items,
  required String Function(T item) searchText,
  int initialPageSize = 6,
}) {
  final controller = useTextEditingController();
  final query = useValueListenable(controller);
  final page = useState(0);
  final pageSize = useState(initialPageSize);
  final term = query.text.trim().toLowerCase();

  final filtered = term.isEmpty
      ? items
      : items
            .where((item) => searchText(item).toLowerCase().contains(term))
            .toList(growable: false);

  final pageCount = math.max(1, (filtered.length / pageSize.value).ceil());
  final currentPage = math.min(page.value, pageCount - 1);
  final start = currentPage * pageSize.value;
  final end = math.min(start + pageSize.value, filtered.length);

  useEffect(() {
    page.value = 0;
    return null;
  }, [term]);

  return AdminListState<T>(
    controller: controller,
    term: term,
    filtered: filtered,
    visible: start >= filtered.length
        ? <T>[]
        : filtered.sublist(start, end),
    page: currentPage,
    pageCount: pageCount,
    pageSize: pageSize.value,
    from: filtered.isEmpty ? 0 : start + 1,
    to: end,
    total: filtered.length,
    onPageChanged: (value) => page.value = value,
    onPageSizeChanged: (value) {
      page.value = 0;
      pageSize.value = value;
    },
  );
}

/// Standard chrome for a bespoke module tab: header, optional metrics, search,
/// filters, body and paginator. Every module renders one of these per tab so
/// the density and rhythm stay identical across catalog, inventory and sales.
final class AdminWorkspaceScaffold extends StatelessWidget {
  const AdminWorkspaceScaffold({
    required this.title,
    required this.icon,
    required this.sectionId,
    required this.body,
    super.key,
    this.list,
    this.filters,
    this.metrics = const <AdminMetric>[],
    this.notice,
    this.summary,
    this.actions = const <Widget>[],
    this.emptyState,
    this.onCreate,
    this.searchHint,
  });

  final String title;
  final IconData icon;
  final String sectionId;
  final Widget body;

  /// Optional local list. When present the search bar and paginator render and
  /// an empty list swaps [body] for [emptyState].
  final AdminListState<dynamic>? list;
  final Widget? filters;
  final List<AdminMetric> metrics;
  final Widget? notice;
  final Widget? summary;
  final List<Widget> actions;
  final Widget? emptyState;
  final VoidCallback? onCreate;
  final String? searchHint;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final availability = AdminSectionCatalog.availabilityOf(sectionId);
    final planned = availability == AdminSectionAvailability.planned;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdminWorkspaceHeader(
          title: title,
          icon: icon,
          pills: [
            AdminAvailabilityPill(availability: availability),
            if (list != null)
              AdminStatusPill(
                label: l10n.sectionRecordsCount(list!.total),
                icon: LucideIcons.listFilter,
              ),
            ...actions,
            if (onCreate != null)
              FilledButton.icon(
                onPressed: planned ? null : onCreate,
                icon: const Icon(LucideIcons.plus, size: AppIconSizes.small),
                label: Text(l10n.wireframeNew),
              ),
          ],
        ),
        if (notice != null) ...[
          const SizedBox(height: AppSpacing.medium),
          notice!,
        ],
        if (metrics.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.medium),
          AdminMetricStrip(metrics: metrics),
        ],
        if (summary != null) ...[
          const SizedBox(height: AppSpacing.medium),
          summary!,
        ],
        if (list != null) ...[
          const SizedBox(height: AppSpacing.medium),
          AdminWorkspaceSearchBar(
            search: list!.controller,
            hasQuery: list!.hasQuery,
            onClear: list!.controller.clear,
            hintText: searchHint,
          ),
        ],
        if (filters != null) ...[
          const SizedBox(height: AppSpacing.small),
          filters!,
        ],
        if (list != null && list!.isEmpty) ...[
          const SizedBox(height: AppSpacing.medium),
          emptyState ??
              AdminWorkspaceEmptyState(
                icon: list!.hasQuery
                    ? LucideIcons.searchX
                    : LucideIcons.inbox,
                title: list!.hasQuery
                    ? l10n.sectionNoResultsTitle
                    : l10n.sectionEmptyTitle,
                subtitle: list!.hasQuery
                    ? l10n.sectionNoResultsMessage
                    : l10n.sectionEmptyMessage,
                action: list!.hasQuery
                    ? TextButton.icon(
                        onPressed: list!.controller.clear,
                        icon: const Icon(
                          LucideIcons.x,
                          size: AppIconSizes.small,
                        ),
                        label: Text(l10n.sectionClearSearch),
                      )
                    : null,
              ),
        ] else ...[
          const SizedBox(height: AppSpacing.medium),
          body,
        ],
        if (list != null && list!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.medium),
          AdminPaginationBar(
            page: list!.page,
            pageCount: list!.pageCount,
            pageSize: list!.pageSize,
            from: list!.from,
            to: list!.to,
            total: list!.total,
            onPageChanged: list!.onPageChanged,
            onPageSizeChanged: list!.onPageSizeChanged,
          ),
        ],
      ],
    );
  }
}
