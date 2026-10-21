import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../core/widgets/design_system/tokens/tokens.dart';

/// A single delivery, visit or appointment shown by [AdminScheduleCalendar].
final class AdminCalendarEvent {
  const AdminCalendarEvent({
    required this.subject,
    required this.start,
    required this.end,
    this.color,
  });

  final String subject;
  final DateTime start;
  final DateTime end;
  final Color? color;
}

/// Month calendar used for delivery schedules and appointment previews.
final class AdminScheduleCalendar extends StatelessWidget {
  const AdminScheduleCalendar({
    required this.events,
    super.key,
    this.height = 400,
    this.showHeader = true,
  });

  final List<AdminCalendarEvent> events;
  final double height;
  final bool showHeader;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: SfCalendar(
        view: CalendarView.month,
        firstDayOfWeek: 6,
        dataSource: _AdminCalendarSource(
          events,
          fallbackColor: colorScheme.primary,
        ),
        backgroundColor: Colors.transparent,
        cellBorderColor: colorScheme.outlineVariant.withValues(alpha: 0.4),
        todayHighlightColor: colorScheme.primary,
        todayTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
        ),
        headerHeight: showHeader ? 40 : 0,
        headerDateFormat: 'MMMM yyyy',
        headerStyle: CalendarHeaderStyle(
          textAlign: TextAlign.center,
          backgroundColor: Colors.transparent,
          textStyle: textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        viewHeaderHeight: 34,
        viewHeaderStyle: ViewHeaderStyle(
          backgroundColor: Colors.transparent,
          dayTextStyle: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          dateTextStyle: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
        selectionDecoration: const BoxDecoration(),
        monthCellBuilder: (context, details) {
          final scheme = Theme.of(context).colorScheme;
          final isToday = DateUtils.isSameDay(details.date, DateTime.now());
          final focusDate = details.visibleDates.length > 15
              ? details.visibleDates[15]
              : details.date;
          final inMonth = details.date.month == focusDate.month;
          final accent = details.appointments.isEmpty
              ? null
              : (details.appointments.first as Appointment).color;

          return Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isToday ? scheme.primary.withValues(alpha: 0.14) : null,
              borderRadius: BorderRadius.circular(AppRadii.small),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${details.date.day}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: inMonth
                          ? (isToday ? scheme.primary : scheme.onSurface)
                          : scheme.onSurfaceVariant.withValues(alpha: 0.4),
                      fontSize: 11,
                    ),
                  ),
                  if (accent != null) ...[
                    const SizedBox(height: 2),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

final class _AdminCalendarSource extends CalendarDataSource {
  _AdminCalendarSource(
    List<AdminCalendarEvent> events, {
    required Color fallbackColor,
  }) {
    appointments = <Appointment>[
      for (final event in events)
        Appointment(
          startTime: event.start,
          endTime: event.end,
          subject: event.subject,
          color: event.color ?? fallbackColor,
        ),
    ];
  }
}
