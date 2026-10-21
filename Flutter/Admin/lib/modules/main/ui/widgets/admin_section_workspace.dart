import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../navigation/admin_module.dart';
import 'admin_charts.dart';
import 'admin_data_grid.dart';
import 'admin_page_frame.dart';
import 'admin_schedule_calendar.dart';

const _pageSizeOptions = <int>[6, 12, 24];
const _defaultPageSize = 6;

/// Full-width, interactive workspace for a single module sub-section.
///
/// Every layout kind renders real, paginated content instead of a static
/// sketch, so the tabs above it are the only navigation the user needs.
final class AdminSectionWorkspace extends HookWidget {
  const AdminSectionWorkspace({
    required this.module,
    required this.section,
    super.key,
  });

  final AdminModule module;
  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final search = useTextEditingController();
    final query = useValueListenable(search);
    final page = useState(0);
    final pageSize = useState(_defaultPageSize);
    final selectedIndex = useState(0);

    final kind = section.wireframe;
    final isRecordKind =
        kind == AdminWireframeKind.table ||
        kind == AdminWireframeKind.list ||
        kind == AdminWireframeKind.detail ||
        kind == AdminWireframeKind.board;

    final records = isRecordKind
        ? _recordsFor(context, module)
        : const <_WorkspaceRecord>[];
    final term = query.text.trim().toLowerCase();
    final filtered = term.isEmpty
        ? records
        : records
              .where(
                (record) =>
                    record.reference.toLowerCase().contains(term) ||
                    record.title.toLowerCase().contains(term) ||
                    record.subtitle.toLowerCase().contains(term),
              )
              .toList(growable: false);

    final pageCount = math.max(
      1,
      (filtered.length + pageSize.value - 1) ~/ pageSize.value,
    );
    final currentPage = math.min(page.value, pageCount - 1);
    final start = currentPage * pageSize.value;
    final visible = filtered.sublist(
      start,
      math.min(start + pageSize.value, filtered.length),
    );

    useEffect(() {
      page.value = 0;
      return null;
    }, [term]);

    useEffect(() {
      selectedIndex.value = 0;
      return null;
    }, [currentPage]);

    final content = switch (kind) {
      AdminWireframeKind.table => _TableContent(records: visible),
      AdminWireframeKind.list => _ListContent(
        records: visible,
        section: section,
      ),
      AdminWireframeKind.detail => _DetailContent(
        records: visible,
        section: section,
        selectedIndex: math.min(selectedIndex.value, visible.length - 1),
        onSelected: (index) => selectedIndex.value = index,
      ),
      AdminWireframeKind.board => _BoardContent(records: visible),
      AdminWireframeKind.stats => const _StatsContent(),
      AdminWireframeKind.form => _SectionForm(section: section),
      AdminWireframeKind.calendar => _CalendarContent(section: section),
      AdminWireframeKind.map => _MapContent(section: section),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isRecordKind) ...[
          _WorkspaceToolbar(
            section: section,
            search: search,
            total: filtered.length,
            hasQuery: term.isNotEmpty,
            onClear: search.clear,
          ),
          const SizedBox(height: AppSpacing.medium),
        ],
        if (isRecordKind && filtered.isEmpty)
          _EmptyState(
            section: section,
            hasQuery: term.isNotEmpty,
            onClear: search.clear,
          )
        else
          AnimatedSwitcher(
            duration: AppMotion.fast,
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: KeyedSubtree(
              key: ValueKey('${section.title}-${section.wireframe}'),
              child: content,
            ),
          ),
        if (isRecordKind && filtered.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.medium),
          _PaginationBar(
            page: currentPage,
            pageCount: pageCount,
            pageSize: pageSize.value,
            from: start + 1,
            to: start + visible.length,
            total: filtered.length,
            onPageChanged: (value) => page.value = value,
            onPageSizeChanged: (value) {
              pageSize.value = value;
              page.value = 0;
            },
          ),
        ],
      ],
    );
  }
}

final class _WorkspaceToolbar extends StatelessWidget {
  const _WorkspaceToolbar({
    required this.section,
    required this.search,
    required this.total,
    required this.hasQuery,
    required this.onClear,
  });

  final AdminSubSection section;
  final TextEditingController search;
  final int total;
  final bool hasQuery;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;

    return AdminSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSectionHeading(
            title: section.title,
            icon: section.icon,
            trailing: Wrap(
              spacing: AppSpacing.small,
              runSpacing: AppSpacing.small,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AdminStatusPill(
                  label: l10n.sectionRecordsCount(total),
                  icon: LucideIcons.listFilter,
                ),
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(l10n.wireframeNew)));
                  },
                  icon: const Icon(LucideIcons.plus, size: AppIconSizes.small),
                  label: Text(l10n.wireframeNew),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _TableContent extends StatelessWidget {
  const _TableContent({required this.records});

  final List<_WorkspaceRecord> records;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final height = math.max(220.0, records.length * 46.0 + 38.0);

    return AdminSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.small),
      child: AdminRecordsGrid(
        records: [
          for (final record in records)
            AdminRecord(
              reference: record.reference,
              title: record.title,
              status: record.status,
              statusColor: _toneColor(colorScheme, record.tone),
              value: record.value,
            ),
        ],
        headers: [
          l10n.wireframeTableRef,
          l10n.wireframeTableName,
          l10n.wireframeTableStatus,
          l10n.wireframeTableValue,
        ],
        height: height,
      ),
    );
  }
}

final class _ListContent extends StatelessWidget {
  const _ListContent({required this.records, required this.section});

  final List<_WorkspaceRecord> records;
  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    return AdminSurfaceCard(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
      child: Column(
        children: [
          for (var index = 0; index < records.length; index++) ...[
            if (index > 0)
              Divider(
                height: AppControlSizes.dividerThickness,
                color: Theme.of(context).colorScheme.outlineVariant
                    .withValues(alpha: 0.4),
              ),
            _RecordTile(record: records[index], section: section),
          ],
        ],
      ),
    );
  }
}

final class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.records,
    required this.section,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<_WorkspaceRecord> records;
  final AdminSubSection section;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final activeRecord = records[math.max(0, selectedIndex)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdminSurfaceCard(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
          child: Column(
            children: [
              for (var index = 0; index < records.length; index++) ...[
                if (index > 0)
                  Divider(
                    height: AppControlSizes.dividerThickness,
                    color: Theme.of(context).colorScheme.outlineVariant
                        .withValues(alpha: 0.4),
                  ),
                _RecordTile(
                  record: records[index],
                  section: section,
                  selected: index == selectedIndex,
                  onTap: () => onSelected(index),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.large),
        _RecordDetails(record: activeRecord, section: section),
      ],
    );
  }
}

final class _BoardContent extends StatelessWidget {
  const _BoardContent({required this.records});

  final List<_WorkspaceRecord> records;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final columns = [
      (label: l10n.boardColumnNew, records: <_WorkspaceRecord>[]),
      (label: l10n.boardColumnInProgress, records: <_WorkspaceRecord>[]),
      (label: l10n.boardColumnDone, records: <_WorkspaceRecord>[]),
    ];

    for (final record in records) {
      final index = record.column.clamp(0, columns.length - 1);
      columns[index].records.add(record);
    }

    final columnWidgets = [
      for (final column in columns)
        _BoardColumn(label: column.label, records: column.records),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < columnWidgets.length; index++) ...[
                if (index > 0) const SizedBox(width: AppSpacing.medium),
                Expanded(child: columnWidgets[index]),
              ],
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var index = 0; index < columnWidgets.length; index++) ...[
              if (index > 0) const SizedBox(height: AppSpacing.medium),
              columnWidgets[index],
            ],
          ],
        );
      },
    );
  }
}

final class _BoardColumn extends StatelessWidget {
  const _BoardColumn({required this.label, required this.records});

  final String label;
  final List<_WorkspaceRecord> records;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AdminSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSectionHeading(
            title: label,
            trailing: AdminStatusPill(label: '${records.length}'),
          ),
          const SizedBox(height: AppSpacing.medium),
          if (records.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.large),
              child: Text(
                context.localeKeys.sectionEmptyTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
            )
          else
            for (var index = 0; index < records.length; index++) ...[
              if (index > 0) const SizedBox(height: AppSpacing.small),
              _BoardCard(record: records[index]),
            ],
        ],
      ),
    );
  }
}

final class _BoardCard extends StatelessWidget {
  const _BoardCard({required this.record});

  final _WorkspaceRecord record;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.small),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadii.medium),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            record.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: 2),
          Text(
            record.reference,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          Text(record.value, style: textTheme.labelMedium),
        ],
      ),
    );
  }
}

final class _RecordTile extends StatelessWidget {
  const _RecordTile({
    required this.record,
    required this.section,
    this.selected = false,
    this.onTap,
  });

  final _WorkspaceRecord record;
  final AdminSubSection section;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final foreground = selected ? colorScheme.onSecondaryContainer : null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 480;

        return Material(
          color: selected ? colorScheme.secondaryContainer : Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.small,
                vertical: AppSpacing.small,
              ),
              child: Row(
                children: [
                  AdminAvatar(name: record.title, size: 36),
                  const SizedBox(width: AppSpacing.small),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: foreground,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          compact
                              ? '${record.subtitle} • ${record.status}'
                              : record.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!compact) ...[
                    const SizedBox(width: AppSpacing.small),
                    AdminStatusPill(label: record.status, tone: record.tone),
                  ],
                  const SizedBox(width: AppSpacing.small),
                  Text(record.value, style: textTheme.labelMedium),
                  if (onTap != null) ...[
                    const SizedBox(width: AppSpacing.xSmall),
                    Icon(
                      LucideIcons.chevronRight,
                      size: AppIconSizes.small,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

final class _RecordDetails extends StatelessWidget {
  const _RecordDetails({required this.record, required this.section});

  final _WorkspaceRecord record;
  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AdminAvatar(name: record.title),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.sectionDetailTitle,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      record.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.small),
              AdminStatusPill(label: record.status, tone: record.tone),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          Divider(
            height: AppControlSizes.dividerThickness,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.medium),
          Wrap(
            spacing: AppSpacing.medium,
            runSpacing: AppSpacing.medium,
            children: [
              _InfoTile(
                label: l10n.formFieldReference,
                value: record.reference,
              ),
              _InfoTile(label: l10n.formFieldBranch, value: record.subtitle),
              _InfoTile(label: l10n.formFieldAmount, value: record.value),
              _InfoTile(label: l10n.sectionCreatedAt, value: '2026/10/12'),
              _InfoTile(label: l10n.sectionLastUpdate, value: '2026/10/18'),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          Text(
            l10n.formFieldNotes,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xSmall),
          Text(l10n.sectionRecordNote, style: textTheme.bodySmall),
          const SizedBox(height: AppSpacing.large),
          AdminSectionHeading(title: l10n.sectionTimeline, icon: section.icon),
          const SizedBox(height: AppSpacing.medium),
          _TimelineRow(
            title: l10n.statusPending,
            subtitle: '2026/10/12',
            done: true,
          ),
          _TimelineRow(
            title: l10n.statusInProgress,
            subtitle: '2026/10/15',
            done: true,
          ),
          _TimelineRow(
            title: record.status,
            subtitle: '2026/10/18',
            done: record.column >= 1,
            last: true,
          ),
        ],
      ),
    );
  }
}

final class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      width: 168,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

final class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.title,
    required this.subtitle,
    required this.done,
    this.last = false,
  });

  final String title;
  final String subtitle;
  final bool done;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color = done ? colorScheme.primary : colorScheme.outlineVariant;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? color : Colors.transparent,
                  border: Border.all(color: color),
                ),
              ),
              if (!last)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    color: color.withValues(alpha: 0.4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.small),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : AppSpacing.medium),
              child: Row(
                children: [
                  Expanded(child: Text(title, style: textTheme.bodySmall)),
                  const SizedBox(width: AppSpacing.small),
                  Text(
                    subtitle,
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _StatsContent extends StatelessWidget {
  const _StatsContent();

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;

    final metrics = [
      (
        label: l10n.wireframeStatsSales,
        value: '48,500 ${l10n.currencyEgp}',
        icon: LucideIcons.banknote,
        tone: AdminPillTone.success,
      ),
      (
        label: l10n.wireframeStatsOrders,
        value: '1,284',
        icon: LucideIcons.shoppingCart,
        tone: AdminPillTone.primary,
      ),
      (
        label: l10n.wireframeStatsGrowth,
        value: '+18%',
        icon: LucideIcons.trendingUp,
        tone: AdminPillTone.warning,
      ),
    ];

    final areaPoints = <AdminChartPoint>[
      AdminChartPoint(label: l10n.weekdaySat, value: 32),
      AdminChartPoint(label: l10n.weekdaySun, value: 41),
      AdminChartPoint(label: l10n.weekdayMon, value: 38),
      AdminChartPoint(label: l10n.weekdayTue, value: 52),
      AdminChartPoint(label: l10n.weekdayWed, value: 47),
      AdminChartPoint(label: l10n.weekdayThu, value: 61),
      AdminChartPoint(label: l10n.weekdayFri, value: 58),
    ];

    final splitPoints = <AdminChartPoint>[
      AdminChartPoint(label: l10n.wireframeStatsSales, value: 58),
      AdminChartPoint(label: l10n.wireframeStatsOrders, value: 27),
      AdminChartPoint(label: l10n.statsActiveCustomers, value: 15),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 720 ? 3 : 1;
            final width =
                (constraints.maxWidth - (columns - 1) * AppSpacing.medium) /
                columns;

            return Wrap(
              spacing: AppSpacing.medium,
              runSpacing: AppSpacing.medium,
              children: [
                for (final metric in metrics)
                  SizedBox(
                    width: width,
                    child: _MetricTile(
                      label: metric.label,
                      value: metric.value,
                      icon: metric.icon,
                      tone: metric.tone,
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.medium),
        LayoutBuilder(
          builder: (context, constraints) {
            final chartCard = AdminSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AdminSectionHeading(
                    title: l10n.wireframeStatsChartTitle,
                    icon: LucideIcons.chartNoAxesCombined,
                    trailing: AdminStatusPill(
                      label: l10n.statsConversion,
                      tone: AdminPillTone.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  AdminAreaChart(
                    points: areaPoints,
                    height: 220,
                    valueSuffix: 'k',
                  ),
                ],
              ),
            );

            final splitCard = AdminSurfaceCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AdminSectionHeading(
                    title: l10n.statsAverageOrder,
                    icon: LucideIcons.pieChart,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  AdminDoughnutChart(points: splitPoints, height: 220),
                ],
              ),
            );

            if (constraints.maxWidth >= 820) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: chartCard),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(child: splitCard),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                chartCard,
                const SizedBox(height: AppSpacing.medium),
                splitCard,
              ],
            );
          },
        ),
      ],
    );
  }
}

final class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.tone,
  });

  final String label;
  final String value;
  final IconData icon;
  final AdminPillTone tone;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final color = _toneColor(colorScheme, tone);

    return AdminSurfaceCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadii.medium),
            ),
            child: Icon(icon, size: AppIconSizes.small, color: color),
          ),
          const SizedBox(width: AppSpacing.small),
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
                  maxLines: 1,
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

final class _SectionForm extends HookWidget {
  const _SectionForm({required this.section});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final name = useTextEditingController();
    final reference = useTextEditingController(text: 'REQ-1042');
    final amount = useTextEditingController(text: '1250');
    final notes = useTextEditingController();
    final branch = useState(0);
    final status = useState(1);
    final date = useState<DateTime?>(null);

    final branches = [
      l10n.sampleBranch1,
      l10n.sampleBranch2,
      l10n.sampleBranch3,
      l10n.sampleBranch4,
    ];
    final statuses = [
      l10n.statusPending,
      l10n.statusInProgress,
      l10n.statusCompleted,
      l10n.statusCancelled,
    ];

    void resetForm() {
      name.clear();
      reference.text = 'REQ-1042';
      amount.text = '1250';
      notes.clear();
      branch.value = 0;
      status.value = 1;
      date.value = null;
    }

    Widget buildNameField() => TextFormField(
      controller: name,
      decoration: _fieldDecoration(context, l10n.formFieldName),
    );

    Widget buildReferenceField() => TextFormField(
      controller: reference,
      decoration: _fieldDecoration(context, l10n.formFieldReference),
    );

    Widget buildAmountField() => TextFormField(
      controller: amount,
      keyboardType: TextInputType.number,
      decoration: _fieldDecoration(context, l10n.formFieldAmount),
    );

    Widget buildBranchField() => DropdownButtonFormField<int>(
      initialValue: branch.value,
      isExpanded: true,
      decoration: _fieldDecoration(context, l10n.formFieldBranch),
      items: [
        for (var index = 0; index < branches.length; index++)
          DropdownMenuItem(value: index, child: Text(branches[index])),
      ],
      onChanged: (value) => branch.value = value ?? branch.value,
    );

    Widget buildStatusField() => DropdownButtonFormField<int>(
      initialValue: status.value,
      isExpanded: true,
      decoration: _fieldDecoration(context, l10n.formFieldStatus),
      items: [
        for (var index = 0; index < statuses.length; index++)
          DropdownMenuItem(value: index, child: Text(statuses[index])),
      ],
      onChanged: (value) => status.value = value ?? status.value,
    );

    Widget buildDateField() {
      final selected = date.value;
      final label = selected == null
          ? l10n.formFieldDate
          : MaterialLocalizations.of(context).formatCompactDate(selected);

      return InkWell(
        borderRadius: BorderRadius.circular(AppRadii.medium),
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: selected ?? DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2035),
          );
          if (picked != null) date.value = picked;
        },
        child: InputDecorator(
          decoration: _fieldDecoration(context, l10n.formFieldDate),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                LucideIcons.calendar,
                size: AppIconSizes.small,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      );
    }

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSectionHeading(
            title: section.title,
            subtitle: l10n.sectionEmptyMessage,
            icon: section.icon,
          ),
          const SizedBox(height: AppSpacing.large),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 720) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          buildNameField(),
                          const SizedBox(height: AppSpacing.medium),
                          buildReferenceField(),
                          const SizedBox(height: AppSpacing.medium),
                          buildBranchField(),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.medium),
                    Expanded(
                      child: Column(
                        children: [
                          buildAmountField(),
                          const SizedBox(height: AppSpacing.medium),
                          buildStatusField(),
                          const SizedBox(height: AppSpacing.medium),
                          buildDateField(),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  buildNameField(),
                  const SizedBox(height: AppSpacing.medium),
                  buildReferenceField(),
                  const SizedBox(height: AppSpacing.medium),
                  buildAmountField(),
                  const SizedBox(height: AppSpacing.medium),
                  buildBranchField(),
                  const SizedBox(height: AppSpacing.medium),
                  buildStatusField(),
                  const SizedBox(height: AppSpacing.medium),
                  buildDateField(),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.medium),
          TextFormField(
            controller: notes,
            minLines: 3,
            maxLines: 5,
            decoration: _fieldDecoration(context, l10n.formFieldNotes),
          ),
          const SizedBox(height: AppSpacing.large),
          Wrap(
            spacing: AppSpacing.small,
            runSpacing: AppSpacing.small,
            alignment: WrapAlignment.end,
            children: [
              TextButton(
                onPressed: resetForm,
                child: Text(l10n.wireframeCancel),
              ),
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.formSaveSuccess)));
                },
                icon: const Icon(LucideIcons.check, size: AppIconSizes.small),
                label: Text(l10n.wireframeSave),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _CalendarContent extends StatelessWidget {
  const _CalendarContent({required this.section});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final now = DateTime.now();
    final events = [
      AdminCalendarEvent(
        subject: l10n.wireframeEventDelivery,
        start: DateTime(now.year, now.month, now.day, 9),
        end: DateTime(now.year, now.month, now.day, 10),
      ),
      AdminCalendarEvent(
        subject: l10n.wireframeEventVisit,
        start: DateTime(now.year, now.month, now.day + 1, 11),
        end: DateTime(now.year, now.month, now.day + 1, 12),
      ),
      AdminCalendarEvent(
        subject: l10n.wireframeEventAudit,
        start: DateTime(now.year, now.month, now.day + 2, 13),
        end: DateTime(now.year, now.month, now.day + 2, 14),
      ),
      AdminCalendarEvent(
        subject: l10n.wireframeEventMeeting,
        start: DateTime(now.year, now.month, now.day + 3, 15),
        end: DateTime(now.year, now.month, now.day + 3, 16),
      ),
    ];
    final localizations = MaterialLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AdminSurfaceCard(
          child: AdminScheduleCalendar(events: events, height: 420),
        ),
        const SizedBox(height: AppSpacing.medium),
        AdminSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AdminSectionHeading(
                title: l10n.calendarUpcoming,
                icon: section.icon,
              ),
              const SizedBox(height: AppSpacing.medium),
              for (var index = 0; index < events.length; index++) ...[
                if (index > 0)
                  Divider(
                    height: AppControlSizes.dividerThickness,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.small,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        LucideIcons.calendarClock,
                        size: AppIconSizes.small,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.small),
                      Expanded(
                        child: Text(
                          events[index].subject,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.small),
                      Text(
                        '${localizations.formatMediumDate(events[index].start)} · '
                        '${localizations.formatTimeOfDay(TimeOfDay.fromDateTime(events[index].start))}',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

final class _MapContent extends StatelessWidget {
  const _MapContent({required this.section});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final zones = [
      (name: l10n.sampleBranch1, orders: 420, revenue: 18400),
      (name: l10n.sampleBranch2, orders: 360, revenue: 15200),
      (name: l10n.sampleBranch3, orders: 280, revenue: 11800),
      (name: l10n.sampleBranch4, orders: 190, revenue: 7600),
    ];
    final maxOrders = zones
        .map((zone) => zone.orders)
        .reduce(math.max)
        .toDouble();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSectionHeading(
            title: section.title,
            subtitle: l10n.dashboardFeature3,
            icon: section.icon,
            trailing: AdminStatusPill(
              label: '${zones.length}',
              tone: AdminPillTone.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.mapZone,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                l10n.mapOrders,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              SizedBox(
                width: 96,
                child: Text(
                  l10n.mapRevenue,
                  textAlign: TextAlign.end,
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.small),
          for (var index = 0; index < zones.length; index++) ...[
            if (index > 0)
              Divider(
                height: AppSpacing.medium,
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        zones[index].name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodySmall,
                      ),
                      const SizedBox(height: AppSpacing.xSmall),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                        child: LinearProgressIndicator(
                          value: zones[index].orders / maxOrders,
                          minHeight: 6,
                          backgroundColor: colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.medium),
                SizedBox(
                  width: 52,
                  child: Text(
                    '${zones[index].orders}',
                    textAlign: TextAlign.end,
                    style: textTheme.bodySmall,
                  ),
                ),
                const SizedBox(width: AppSpacing.medium),
                SizedBox(
                  width: 96,
                  child: Text(
                    '${_formatAmount(zones[index].revenue)} ${l10n.currencyEgp}',
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelMedium,
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

final class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.page,
    required this.pageCount,
    required this.pageSize,
    required this.from,
    required this.to,
    required this.total,
    required this.onPageChanged,
    required this.onPageSizeChanged,
  });

  final int page;
  final int pageCount;
  final int pageSize;
  final int from;
  final int to;
  final int total;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<int> onPageSizeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final textTheme = Theme.of(context).textTheme;

    return AdminSurfaceCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      child: LayoutBuilder(
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
                    for (final size in _pageSizeOptions)
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
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: controls,
                ),
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
      ),
    );
  }
}

final class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.section,
    required this.hasQuery,
    required this.onClear,
  });

  final AdminSubSection section;
  final bool hasQuery;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AdminSurfaceCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.large,
        vertical: AppSpacing.xxLarge,
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              hasQuery ? LucideIcons.searchX : section.icon,
              size: AppIconSizes.medium,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(
            hasQuery ? l10n.sectionNoResultsTitle : l10n.sectionEmptyTitle,
            textAlign: TextAlign.center,
            style: textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.xSmall),
          Text(
            hasQuery ? l10n.sectionNoResultsMessage : l10n.sectionEmptyMessage,
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (hasQuery) ...[
            const SizedBox(height: AppSpacing.medium),
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(LucideIcons.x, size: AppIconSizes.small),
              label: Text(l10n.sectionClearSearch),
            ),
          ],
        ],
      ),
    );
  }
}

final class _WorkspaceRecord {
  const _WorkspaceRecord({
    required this.reference,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.tone,
    required this.value,
    required this.column,
  });

  final String reference;
  final String title;
  final String subtitle;
  final String status;
  final AdminPillTone tone;
  final String value;
  final int column;
}

List<_WorkspaceRecord> _recordsFor(BuildContext context, AdminModule module) {
  final l10n = context.localeKeys;
  final products = [
    l10n.sampleProduct1,
    l10n.sampleProduct2,
    l10n.sampleProduct3,
    l10n.sampleProduct4,
    l10n.sampleProduct5,
  ];
  final customers = [
    l10n.sampleCustomer1,
    l10n.sampleCustomer2,
    l10n.sampleCustomer3,
    l10n.sampleCustomer4,
  ];
  final employees = [
    l10n.sampleEmployee1,
    l10n.sampleEmployee2,
    l10n.sampleEmployee3,
    l10n.sampleEmployee4,
  ];
  final campaigns = [
    l10n.sampleCampaign1,
    l10n.sampleCampaign2,
    l10n.sampleCampaign3,
    l10n.sampleCampaign4,
  ];
  final titles = switch (module.id) {
    AdminModuleId.catalog ||
    AdminModuleId.inventory ||
    AdminModuleId.purchasing => products,
    AdminModuleId.hr || AdminModuleId.identity => employees,
    AdminModuleId.marketing => campaigns,
    _ => customers,
  };
  final branches = [
    l10n.sampleBranch1,
    l10n.sampleBranch2,
    l10n.sampleBranch3,
    l10n.sampleBranch4,
  ];
  final statuses = [
    (label: l10n.statusCompleted, tone: AdminPillTone.success, column: 2),
    (label: l10n.statusPending, tone: AdminPillTone.warning, column: 0),
    (label: l10n.statusInProgress, tone: AdminPillTone.primary, column: 1),
    (label: l10n.statusCancelled, tone: AdminPillTone.muted, column: 0),
  ];

  return [
    for (var index = 0; index < 26; index++)
      _WorkspaceRecord(
        reference: '${_referencePrefix(module.id)}-${1042 + index * 7}',
        title: titles[index % titles.length],
        subtitle: branches[index % branches.length],
        status: statuses[index % statuses.length].label,
        tone: statuses[index % statuses.length].tone,
        value:
            '${_formatAmount(850 + (index * 137) % 8400)} '
            '${l10n.currencyEgp}',
        column: statuses[index % statuses.length].column,
      ),
  ];
}

String _referencePrefix(AdminModuleId id) => switch (id) {
  AdminModuleId.catalog => 'CAT',
  AdminModuleId.inventory => 'INV',
  AdminModuleId.sales => 'ORD',
  AdminModuleId.purchasing => 'PO',
  AdminModuleId.crm => 'CRM',
  AdminModuleId.delivery => 'SHP',
  AdminModuleId.hr => 'EMP',
  AdminModuleId.accounting => 'ACC',
  AdminModuleId.marketing => 'CMP',
  AdminModuleId.identity => 'USR',
  _ => 'REC',
};

Color _toneColor(ColorScheme colorScheme, AdminPillTone tone) => switch (tone) {
  AdminPillTone.primary => colorScheme.primary,
  AdminPillTone.success => const Color(0xFF1B8A5A),
  AdminPillTone.warning => const Color(0xFFB26A00),
  AdminPillTone.muted => colorScheme.onSurfaceVariant,
};

InputDecoration _fieldDecoration(BuildContext context, String label) {
  return InputDecoration(
    labelText: label,
    isDense: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadii.medium),
    ),
  );
}

String _formatAmount(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) buffer.write(',');
    buffer.write(digits[index]);
  }
  return buffer.toString();
}
