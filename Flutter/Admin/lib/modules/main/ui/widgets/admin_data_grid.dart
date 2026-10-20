import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/widgets/design_system/tokens/tokens.dart';

/// Row model rendered by [AdminRecordsGrid].
final class AdminRecord {
  const AdminRecord({
    required this.reference,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.value,
  });

  final String reference;
  final String title;
  final String status;
  final Color statusColor;
  final String value;
}

/// A compact, theme-aware records table with four columns:
/// reference, title, status and value.
///
/// The reference column collapses on very narrow layouts so the table stays
/// readable beside a collapsed navigation rail.
final class AdminRecordsGrid extends StatelessWidget {
  const AdminRecordsGrid({
    required this.records,
    required this.headers,
    super.key,
    this.height = 320,
    this.compactBreakpoint = 470,
  });

  final List<AdminRecord> records;

  /// Exactly four headers in display order.
  final List<String> headers;
  final double height;
  final double compactBreakpoint;

  @override
  Widget build(BuildContext context) {
    assert(headers.length == 4, 'AdminRecordsGrid needs exactly four headers.');
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < compactBreakpoint;
        final dividerColor = colorScheme.outlineVariant.withValues(alpha: 0.4);
        final headerStyle = textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        );

        final source = _AdminRecordSource(
          records: records,
          compact: compact,
          dividerColor: dividerColor,
          colorScheme: colorScheme,
          textTheme: textTheme,
        );

        return SizedBox(
          height: height,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.medium),
            child: SfDataGrid(
              source: source,
              rowHeight: 46,
              headerRowHeight: 38,
              gridLinesVisibility: GridLinesVisibility.none,
              headerGridLinesVisibility: GridLinesVisibility.none,
              columns: <GridColumn>[
                if (!compact)
                  GridColumn(
                    columnName: 'reference',
                    width: 92,
                    label: _HeaderCell(
                      text: headers[0],
                      style: headerStyle,
                      dividerColor: dividerColor,
                    ),
                  ),
                GridColumn(
                  columnName: 'title',
                  label: _HeaderCell(
                    text: headers[1],
                    style: headerStyle,
                    dividerColor: dividerColor,
                  ),
                ),
                GridColumn(
                  columnName: 'status',
                  width: compact ? 86 : 112,
                  label: _HeaderCell(
                    text: headers[2],
                    style: headerStyle,
                    dividerColor: dividerColor,
                  ),
                ),
                GridColumn(
                  columnName: 'value',
                  width: compact ? 72 : 96,
                  label: _HeaderCell(
                    text: headers[3],
                    style: headerStyle,
                    dividerColor: dividerColor,
                    alignEnd: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

final class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.text,
    required this.style,
    required this.dividerColor,
    this.alignEnd = false,
  });

  final String text;
  final TextStyle? style;
  final Color dividerColor;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignEnd
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: dividerColor)),
      ),
      child: Text(
        text,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: style,
      ),
    );
  }
}

final class _AdminRecordSource extends DataGridSource {
  _AdminRecordSource({
    required this.records,
    required this.compact,
    required this.dividerColor,
    required this.colorScheme,
    required this.textTheme,
  }) {
    _rows = <DataGridRow>[
      for (final record in records)
        DataGridRow(
          cells: <DataGridCell<Object>>[
            if (!compact)
              DataGridCell<String>(
                columnName: 'reference',
                value: record.reference,
              ),
            DataGridCell<String>(columnName: 'title', value: record.title),
            DataGridCell<String>(columnName: 'status', value: record.status),
            DataGridCell<String>(columnName: 'value', value: record.value),
          ],
        ),
    ];
  }

  final List<AdminRecord> records;
  final bool compact;
  final Color dividerColor;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  late List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final index = _rows.indexOf(row);
    final record = records[index];

    Widget cell({
      required Widget child,
      bool alignEnd = false,
    }) {
      return Container(
        alignment: alignEnd
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: dividerColor)),
        ),
        child: child,
      );
    }

    return DataGridRowAdapter(
      cells: <Widget>[
        if (!compact)
          cell(
            child: Text(
              record.reference,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        cell(
          child: Text(
            record.title,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall,
          ),
        ),
        cell(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: record.statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppRadii.pill),
            ),
            child: Text(
              record.status,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelSmall?.copyWith(
                color: record.statusColor,
                fontSize: 10,
              ),
            ),
          ),
        ),
        cell(
          alignEnd: true,
          child: Text(
            record.value,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelMedium,
          ),
        ),
      ],
    );
  }
}
