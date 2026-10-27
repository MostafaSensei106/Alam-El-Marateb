import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../main/navigation/admin_module.dart';
import '../../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../../main/ui/widgets/admin_page_frame.dart';
import '../sample/accounting_models.dart';
import '../sample/accounting_sample_data.dart';
import '../shared/accounting_shared.dart';

/// General-ledger view of the journal tab (`GET general-ledger`).
///
/// Rows are read-only movements; tapping one opens the matching journal entry
/// when the movement points at a seeded entry.
final class LedgerView extends HookWidget {
  const LedgerView({
    required this.section,
    required this.mode,
    required this.onModeChanged,
    required this.onOpen,
    super.key,
  });

  final AdminSubSection section;
  final JournalViewMode mode;
  final ValueChanged<JournalViewMode> onModeChanged;
  final ValueChanged<JournalRow> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final rows = accountingLedgerRows(l10n);
    final entriesById = {
      for (final entry in accountingJournalEntries(l10n)) entry.id: entry,
    };

    final list = useAdminRecordList<LedgerRow>(
      items: rows,
      searchText: (row) =>
          '${row.entryId} ${row.reference ?? ''} ${row.accountName} '
          '${accountingSourceLabel(l10n, row.source)}',
    );

    final totalDebit = rows.fold<double>(0, (sum, row) => sum + row.debit);
    final totalCredit = rows.fold<double>(0, (sum, row) => sum + row.credit);
    final closing = rows.isEmpty ? 0.0 : rows.last.runningBalance;

    return AdminWorkspaceScaffold(
      title: section.title,
      icon: section.icon,
      sectionId: section.id,
      list: list,
      searchHint: l10n.accountingSearchLedger,
      metrics: [
        AdminMetric(
          label: l10n.accountingClosingBalance,
          value: adminFormatAmount(context, closing),
          icon: LucideIcons.wallet,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.accountingTotalDebit,
          value: adminFormatAmount(context, totalDebit),
          icon: LucideIcons.trendingUp,
          tone: AdminPillTone.success,
        ),
        AdminMetric(
          label: l10n.accountingTotalCredit,
          value: adminFormatAmount(context, totalCredit),
          icon: LucideIcons.trendingDown,
          tone: AdminPillTone.warning,
        ),
      ],
      filters: AccountingViewSwitch<JournalViewMode>(
        options: [
          AdminFilterOption(
            value: JournalViewMode.entries,
            label: accountingJournalViewLabel(l10n, JournalViewMode.entries),
            count: accountingJournalEntries(l10n).length,
          ),
          AdminFilterOption(
            value: JournalViewMode.ledger,
            label: accountingJournalViewLabel(l10n, JournalViewMode.ledger),
            count: rows.length,
          ),
        ],
        selected: mode,
        onSelected: onModeChanged,
      ),
      body: AdminDataTable(
        columns: [
          AdminTableColumn(label: l10n.accountingReference, flex: 2),
          AdminTableColumn(label: l10n.accountingDate, hideBelow: 480),
          AdminTableColumn(label: l10n.accountingSource, hideBelow: 700),
          AdminTableColumn(label: l10n.accountingDebit, alignEnd: true),
          AdminTableColumn(label: l10n.accountingCredit, alignEnd: true),
          AdminTableColumn(
            label: l10n.accountingRunningBalance,
            alignEnd: true,
            flex: 2,
            hideBelow: 620,
          ),
        ],
        rows: [
          for (final row in list.visible)
            AdminTableRow([
              Text(row.reference ?? row.entryId, style: textTheme.bodyMedium),
              Text(
                accountingDateLabel(context, row.entryDate),
                style: textTheme.bodySmall,
              ),
              AdminStatusPill(
                label: accountingSourceLabel(l10n, row.source),
                tone: accountingSourceTone(row.source),
              ),
              Text(
                row.debit == 0 ? '—' : adminFormatAmount(context, row.debit),
                textAlign: TextAlign.end,
                style: textTheme.bodySmall,
              ),
              Text(
                row.credit == 0 ? '—' : adminFormatAmount(context, row.credit),
                textAlign: TextAlign.end,
                style: textTheme.bodySmall,
              ),
              Text(
                adminFormatAmount(context, row.runningBalance),
                textAlign: TextAlign.end,
                style: textTheme.bodySmall,
              ),
            ], onTap: _openAction(entriesById[row.entryId], onOpen)),
        ],
      ),
    );
  }
}

/// Ledger movements whose id has no seeded entry stay read-only.
VoidCallback? _openAction(JournalRow? entry, ValueChanged<JournalRow> onOpen) =>
    entry == null ? null : () => onOpen(entry);
