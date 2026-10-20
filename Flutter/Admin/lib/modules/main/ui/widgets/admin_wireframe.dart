import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../navigation/admin_module.dart';
import 'admin_charts.dart';
import 'admin_data_grid.dart';
import 'admin_page_frame.dart';
import 'admin_schedule_calendar.dart';

/// Ghosted layout sketch for a planned screen.
///
/// The preview intentionally uses neutral blocks instead of real data so the
/// page communicates structure without pretending to be functional.
final class AdminWireframePreview extends StatelessWidget {
  const AdminWireframePreview({required this.section, super.key});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;

    final kindLabel = switch (section.wireframe) {
      AdminWireframeKind.table => l10n.wireframeTableTitle,
      AdminWireframeKind.form => l10n.wireframeFormTitle,
      AdminWireframeKind.stats => l10n.wireframeStatsTitle,
      AdminWireframeKind.calendar => l10n.wireframeCalendarTitle,
      AdminWireframeKind.map => l10n.wireframeMapTitle,
      AdminWireframeKind.board => l10n.wireframeBoardTitle,
      AdminWireframeKind.list => l10n.wireframeListTitle,
      AdminWireframeKind.detail => l10n.wireframeDetailTitle,
    };

    return AdminSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSectionHeading(
            title: section.title,
            subtitle: kindLabel,
            icon: section.icon,
            trailing: AdminStatusPill(
              label: l10n.sampleData,
              icon: LucideIcons.flaskConical,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            l10n.wireframePreviewHint,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.large),
          const _WireframeToolbar(),
          const SizedBox(height: AppSpacing.medium),
          Container(
            height: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.medium),
          _WireframeBody(kind: section.wireframe),
        ],
      ),
    );
  }
}

final class _WireframeBody extends StatelessWidget {
  const _WireframeBody({required this.kind});

  final AdminWireframeKind kind;

  @override
  Widget build(BuildContext context) {
    return switch (kind) {
      AdminWireframeKind.table => const _TableWireframe(),
      AdminWireframeKind.form => const _FormWireframe(),
      AdminWireframeKind.stats => const _StatsWireframe(),
      AdminWireframeKind.calendar => const _CalendarWireframe(),
      AdminWireframeKind.map => const _MapWireframe(),
      AdminWireframeKind.board => const _BoardWireframe(),
      AdminWireframeKind.list => const _ListWireframe(),
      AdminWireframeKind.detail => const _DetailWireframe(),
    };
  }
}

final class _WireframeToolbar extends StatelessWidget {
  const _WireframeToolbar();

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 480;

        return Row(
          children: [
            Expanded(
              child: _GhostBox(
                height: 40,
                child: Row(
                  children: [
                    const SizedBox(width: AppSpacing.medium),
                    Icon(
                      LucideIcons.search,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: AppSpacing.small),
                    Text(
                      l10n.wireframeSearch,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.small),
            if (!isNarrow) ...[
              _GhostChip(
                icon: LucideIcons.listFilter,
                label: l10n.wireframeFilter,
              ),
              const SizedBox(width: AppSpacing.small),
              _GhostChip(
                icon: LucideIcons.download,
                label: l10n.wireframeExport,
              ),
              const SizedBox(width: AppSpacing.small),
            ],
            _GhostChip(
              icon: LucideIcons.plus,
              label: isNarrow ? null : l10n.wireframeNew,
              highlighted: true,
            ),
          ],
        );
      },
    );
  }
}

final class _GhostChip extends StatelessWidget {
  const _GhostChip({required this.icon, this.label, this.highlighted = false});

  final IconData icon;
  final String? label;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final foreground = highlighted
        ? colorScheme.onPrimary
        : colorScheme.onSurfaceVariant;

    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(
        horizontal: label == null ? AppSpacing.medium : AppSpacing.medium,
      ),
      decoration: BoxDecoration(
        color: highlighted
            ? colorScheme.primary
            : colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadii.medium),
        border: Border.all(
          color: highlighted
              ? Colors.transparent
              : colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          if (label != null) ...[
            const SizedBox(width: AppSpacing.small),
            Text(
              label!,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: foreground),
            ),
          ],
        ],
      ),
    );
  }
}

final class _GhostBox extends StatelessWidget {
  const _GhostBox({this.height = 14, this.child});

  final double height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: height,
      alignment: child == null ? null : Alignment.centerLeft,
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.045),
        borderRadius: BorderRadius.circular(AppRadii.medium),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.65),
        ),
      ),
      child: child,
    );
  }
}

final class _GhostLine extends StatelessWidget {
  const _GhostLine({this.widthFactor = 1, this.height = 8});

  final double widthFactor;
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Row children and shrink-wrapped boxes hand down an unbounded width.
        // Fall back to a modest fixed bar so previews still read as text lines.
        final available = constraints.maxWidth;
        final width = available.isFinite
            ? available * widthFactor
            : 64 * widthFactor;

        return SizedBox(
          width: width,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadii.small),
            ),
          ),
        );
      },
    );
  }
}

final class _GhostDot extends StatelessWidget {
  const _GhostDot({this.size = 28, this.active = false});

  final double size;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active
            ? colorScheme.primary.withValues(alpha: 0.35)
            : colorScheme.onSurface.withValues(alpha: 0.09),
      ),
    );
  }
}

final class _TableWireframe extends StatelessWidget {
  const _TableWireframe();

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;

    final records = [
      (
        reference: '#2041',
        name: l10n.sampleCustomer1,
        status: l10n.dashboardStatusPaid,
        color: const Color(0xFF1B8A5A),
        total: '1,250',
      ),
      (
        reference: '#2040',
        name: l10n.sampleCustomer2,
        status: l10n.dashboardStatusShipping,
        color: colorScheme.primary,
        total: '740',
      ),
      (
        reference: '#2039',
        name: l10n.sampleCustomer3,
        status: l10n.dashboardStatusPending,
        color: const Color(0xFFB26A00),
        total: '2,180',
      ),
      (
        reference: '#2038',
        name: l10n.sampleCustomer4,
        status: l10n.dashboardStatusPaid,
        color: const Color(0xFF1B8A5A),
        total: '980',
      ),
    ];

    return AdminRecordsGrid(
      height: 46 * records.length + 42,
      headers: [
        l10n.wireframeTableRef,
        l10n.wireframeTableName,
        l10n.wireframeTableStatus,
        l10n.wireframeTableValue,
      ],
      records: [
        for (final record in records)
          AdminRecord(
            reference: record.reference,
            title: record.name,
            status: record.status,
            statusColor: record.color,
            value: '${record.total} ${l10n.currencyEgp}',
          ),
      ],
    );
  }
}

final class _FormWireframe extends StatelessWidget {
  const _FormWireframe();

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = AppSpacing.medium;
        final columns = constraints.maxWidth >= 600 ? 2 : 1;
        final fieldWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: gap,
              runSpacing: AppSpacing.medium,
              children: [
                for (var field = 0; field < 6; field++)
                  SizedBox(
                    width: fieldWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _GhostLine(
                          widthFactor: field.isEven ? 0.35 : 0.5,
                          height: 7,
                        ),
                        const SizedBox(height: AppSpacing.small),
                        _GhostBox(
                          height: 42,
                          child: field == 2
                              ? Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    start: AppSpacing.medium,
                                  ),
                                  child: Align(
                                    alignment: AlignmentDirectional.centerStart,
                                    child: Text(
                                      l10n.wireframeValue,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.large),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _GhostChip(icon: LucideIcons.x, label: l10n.wireframeCancel),
                const SizedBox(width: AppSpacing.small),
                _GhostChip(
                  icon: LucideIcons.check,
                  label: l10n.wireframeSave,
                  highlighted: true,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

final class _StatsWireframe extends StatelessWidget {
  const _StatsWireframe();

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final tiles = <(String, String)>[
      (l10n.wireframeStatsSales, '128,540 ${l10n.currencyEgp}'),
      (l10n.wireframeStatsOrders, '1,284'),
      (l10n.wireframeStatsGrowth, '+12.4%'),
    ];
    final points = <AdminChartPoint>[
      AdminChartPoint(label: l10n.weekdaySat, value: 86),
      AdminChartPoint(label: l10n.weekdaySun, value: 94),
      AdminChartPoint(label: l10n.weekdayMon, value: 78),
      AdminChartPoint(label: l10n.weekdayTue, value: 112),
      AdminChartPoint(label: l10n.weekdayWed, value: 104),
      AdminChartPoint(label: l10n.weekdayThu, value: 128),
      AdminChartPoint(label: l10n.weekdayFri, value: 121),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = AppSpacing.medium;
        final columns = constraints.maxWidth >= 560 ? 3 : 1;
        final tileWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final tile in tiles)
                  SizedBox(
                    width: tileWidth,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.medium),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(AppRadii.medium),
                        border: Border.all(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tile.$1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xSmall),
                          Text(
                            tile.$2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.large),
            Text(
              l10n.wireframeStatsChartTitle,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            AdminAreaChart(points: points, height: 170),
          ],
        );
      },
    );
  }
}

final class _CalendarWireframe extends StatelessWidget {
  const _CalendarWireframe();

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxWidth < 420 ? 360.0 : 420.0;

        return AdminScheduleCalendar(
          height: height,
          events: [
            AdminCalendarEvent(
              subject: l10n.wireframeEventDelivery,
              start: today.add(const Duration(days: 1, hours: 10)),
              end: today.add(const Duration(days: 1, hours: 11)),
              color: colorScheme.primary,
            ),
            AdminCalendarEvent(
              subject: l10n.wireframeEventVisit,
              start: today.add(const Duration(days: 4, hours: 13)),
              end: today.add(const Duration(days: 4, hours: 14)),
              color: colorScheme.tertiary,
            ),
            AdminCalendarEvent(
              subject: l10n.wireframeEventAudit,
              start: today.add(const Duration(days: 7, hours: 9)),
              end: today.add(const Duration(days: 7, hours: 10)),
              color: const Color(0xFFB26A00),
            ),
            AdminCalendarEvent(
              subject: l10n.wireframeEventMeeting,
              start: today.add(const Duration(days: 11, hours: 12)),
              end: today.add(const Duration(days: 11, hours: 13)),
              color: const Color(0xFF1B8A5A),
            ),
          ],
        );
      },
    );
  }
}

final class _MapWireframe extends StatelessWidget {
  const _MapWireframe();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = context.localeKeys;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.large),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.6),
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.primaryContainer.withValues(alpha: 0.5),
                colorScheme.surfaceContainerHighest,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _RoutePainter(
                    routeColor: colorScheme.primary,
                    dotColor: colorScheme.surface,
                  ),
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.medium,
                    vertical: AppSpacing.small,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppRadii.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        LucideIcons.route,
                        size: 16,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.small),
                      Text(
                        l10n.wireframeMapArea,
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        for (var stop = 0; stop < 3; stop++) ...[
          Row(
            children: [
              _GhostDot(size: 18, active: stop == 0),
              const SizedBox(width: AppSpacing.small),
              const Expanded(child: _GhostLine(widthFactor: 0.6)),
              const SizedBox(width: AppSpacing.medium),
              const _GhostLine(widthFactor: 0.12, height: 7),
            ],
          ),
          if (stop != 2)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 8),
              child: Container(
                width: 1,
                height: 14,
                color: colorScheme.outlineVariant,
              ),
            ),
        ],
      ],
    );
  }
}

final class _RoutePainter extends CustomPainter {
  const _RoutePainter({required this.routeColor, required this.dotColor});

  final Color routeColor;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.12, size.height * 0.72)
      ..cubicTo(
        size.width * 0.3,
        size.height * 0.18,
        size.width * 0.55,
        size.height * 0.95,
        size.width * 0.88,
        size.height * 0.3,
      );

    canvas.drawPath(
      path,
      Paint()
        ..color = routeColor.withValues(alpha: 0.28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = routeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    for (final offset in [
      Offset(size.width * 0.12, size.height * 0.72),
      Offset(size.width * 0.88, size.height * 0.3),
    ]) {
      canvas
        ..drawCircle(offset, 7, Paint()..color = dotColor)
        ..drawCircle(
          offset,
          7,
          Paint()
            ..color = routeColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3,
        );
    }
  }

  @override
  bool shouldRepaint(_RoutePainter oldDelegate) =>
      oldDelegate.routeColor != routeColor || oldDelegate.dotColor != dotColor;
}

final class _BoardWireframe extends StatelessWidget {
  const _BoardWireframe();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = AppSpacing.medium;
        final columns = constraints.maxWidth >= 700 ? 3 : 2;
        final columnWidth =
            (constraints.maxWidth - gap * (columns - 1)) / columns;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var column = 0; column < columns; column++) ...[
                SizedBox(
                  width: columnWidth,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.small),
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(AppRadii.medium),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.55,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.small),
                          child: Row(
                            children: [
                              _GhostDot(size: 14, active: column == 0),
                              const SizedBox(width: AppSpacing.small),
                              const Expanded(
                                child: _GhostLine(widthFactor: 0.55, height: 7),
                              ),
                            ],
                          ),
                        ),
                        for (var card = 0; card < 3; card++) ...[
                          Container(
                            margin: const EdgeInsets.only(
                              bottom: AppSpacing.small,
                            ),
                            padding: const EdgeInsets.all(AppSpacing.medium),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(
                                AppRadii.medium,
                              ),
                              border: Border.all(
                                color: colorScheme.outlineVariant.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _GhostLine(
                                  widthFactor: (card + column).isEven
                                      ? 0.85
                                      : 0.7,
                                ),
                                const SizedBox(height: AppSpacing.small),
                                const _GhostLine(widthFactor: 0.55, height: 6),
                                const SizedBox(height: AppSpacing.medium),
                                Row(
                                  children: [
                                    _GhostDot(
                                      size: 18,
                                      active: card == 0 && column == 0,
                                    ),
                                    const Spacer(),
                                    const _GhostLine(
                                      widthFactor: 0.18,
                                      height: 6,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (column != columns - 1) const SizedBox(width: gap),
              ],
            ],
          ),
        );
      },
    );
  }
}

final class _ListWireframe extends StatelessWidget {
  const _ListWireframe();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 620;
        final list = Column(
          children: [
            for (var row = 0; row < 4; row++)
              Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.small),
                padding: const EdgeInsets.all(AppSpacing.medium),
                decoration: BoxDecoration(
                  color: row == 0
                      ? colorScheme.primary.withValues(alpha: 0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadii.medium),
                  border: Border.all(
                    color: row == 0
                        ? colorScheme.primary.withValues(alpha: 0.3)
                        : colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    _GhostDot(size: 26, active: row == 0),
                    const SizedBox(width: AppSpacing.small),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _GhostLine(widthFactor: 0.7),
                          SizedBox(height: 6),
                          _GhostLine(widthFactor: 0.45, height: 6),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );

        final detail = Container(
          padding: const EdgeInsets.all(AppSpacing.medium),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadii.medium),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.55),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  _GhostDot(size: 34, active: true),
                  SizedBox(width: AppSpacing.small),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _GhostLine(widthFactor: 0.5, height: 10),
                        SizedBox(height: 6),
                        _GhostLine(widthFactor: 0.3, height: 6),
                      ],
                    ),
                  ),
                  _GhostChip(icon: LucideIcons.pencil),
                ],
              ),
              const SizedBox(height: AppSpacing.large),
              for (var field = 0; field < 4; field++) ...[
                const _GhostLine(widthFactor: 0.25, height: 6),
                const SizedBox(height: AppSpacing.xSmall),
                _GhostLine(widthFactor: field.isEven ? 0.85 : 0.65),
                const SizedBox(height: AppSpacing.medium),
              ],
            ],
          ),
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              list,
              const SizedBox(height: AppSpacing.medium),
              detail,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 4, child: list),
            const SizedBox(width: AppSpacing.medium),
            Expanded(flex: 6, child: detail),
          ],
        );
      },
    );
  }
}

final class _DetailWireframe extends StatelessWidget {
  const _DetailWireframe();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Row(
          children: [
            _GhostDot(size: 40, active: true),
            SizedBox(width: AppSpacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GhostLine(widthFactor: 0.45, height: 11),
                  SizedBox(height: 8),
                  _GhostLine(widthFactor: 0.28, height: 7),
                ],
              ),
            ),
            _GhostChip(icon: LucideIcons.ellipsis),
          ],
        ),
        const SizedBox(height: AppSpacing.large),
        Row(
          children: [
            for (var tab = 0; tab < 3; tab++) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium,
                  vertical: AppSpacing.small,
                ),
                decoration: BoxDecoration(
                  color: tab == 0
                      ? colorScheme.primary.withValues(alpha: 0.14)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadii.pill),
                ),
                child: const _GhostLine(height: 7),
              ),
              if (tab != 2) const SizedBox(width: AppSpacing.small),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.6)),
        const SizedBox(height: AppSpacing.small),
        LayoutBuilder(
          builder: (context, constraints) {
            const gap = AppSpacing.large;
            final columns = constraints.maxWidth >= 560 ? 2 : 1;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;

            return Wrap(
              spacing: gap,
              runSpacing: AppSpacing.medium,
              children: [
                for (var field = 0; field < 6; field++)
                  SizedBox(
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _GhostLine(widthFactor: 0.3, height: 6),
                        const SizedBox(height: AppSpacing.xSmall),
                        _GhostLine(
                          widthFactor: field.isEven ? 0.75 : 0.55,
                          height: 9,
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
