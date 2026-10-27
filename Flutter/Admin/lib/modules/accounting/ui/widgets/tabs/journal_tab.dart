import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../main/navigation/admin_module.dart';
import '../../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../../main/ui/widgets/admin_page_frame.dart';
import '../sample/accounting_models.dart';
import '../sample/accounting_sample_data.dart';
import '../shared/accounting_shared.dart';
import 'journal_entry_detail.dart';
import 'journal_entry_form.dart';
import 'ledger_view.dart';

/// Journal tab (`GET|POST journal-entries`, `GET general-ledger`).
///
/// The entries list and the general ledger share the tab through a view
/// switch; the shell only owns the mode and the selected entry so every list
/// keeps its own hooks.
final class JournalTab extends HookWidget {
  const JournalTab({required this.section, super.key});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final mode = useState(JournalViewMode.entries);
    final selected = useState<JournalRow?>(null);
    final creating = useState(false);

    if (creating.value) {
      return JournalEntryForm(
        onSave: () {
          accountingShowSampleAction(context);
          creating.value = false;
        },
        onCancel: () => creating.value = false,
      );
    }

    final entry = selected.value;
    if (entry != null) {
      return JournalEntryDetail(
        entry: entry,
        onBack: () => selected.value = null,
      );
    }

    void changeMode(JournalViewMode value) {
      mode.value = value;
      selected.value = null;
    }

    return switch (mode.value) {
      JournalViewMode.entries => _EntriesList(
        section: section,
        mode: mode.value,
        onModeChanged: changeMode,
        onCreate: () => creating.value = true,
        onOpen: (entry) => selected.value = entry,
      ),
      JournalViewMode.ledger => LedgerView(
        section: section,
        mode: mode.value,
        onModeChanged: changeMode,
        onOpen: (entry) => selected.value = entry,
      ),
    };
  }
}

final class _EntriesList extends HookWidget {
  const _EntriesList({
    required this.section,
    required this.mode,
    required this.onModeChanged,
    required this.onCreate,
    required this.onOpen,
  });

  final AdminSubSection section;
  final JournalViewMode mode;
  final ValueChanged<JournalViewMode> onModeChanged;
  final VoidCallback onCreate;
  final ValueChanged<JournalRow> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final entries = accountingJournalEntries(l10n);
    final source = useState<JournalSource?>(null);

    final scoped = source.value == null
        ? entries
        : entries
              .where((entry) => entry.source == source.value)
              .toList(growable: false);

    final list = useAdminRecordList<JournalRow>(
      items: scoped,
      searchText: (entry) =>
          '${entry.id} ${entry.reference ?? ''} ${entry.memo ?? ''} '
          '${accountingSourceLabel(l10n, entry.source)}',
    );

    final totalDebit = scoped.fold<double>(
      0,
      (sum, entry) => sum + entry.totalDebit,
    );
    final totalCredit = scoped.fold<double>(
      0,
      (sum, entry) => sum + entry.totalCredit,
    );

    return AdminWorkspaceScaffold(
      title: section.title,
      icon: section.icon,
      sectionId: section.id,
      list: list,
      onCreate: onCreate,
      searchHint: l10n.accountingSearchJournal,
      metrics: [
        AdminMetric(
          label: l10n.accountingMetricEntries,
          value: adminGroupDigits(scoped.length),
          icon: LucideIcons.bookOpen,
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
      filters: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountingViewSwitch<JournalViewMode>(
            options: [
              AdminFilterOption(
                value: JournalViewMode.entries,
                label: accountingJournalViewLabel(
                  l10n,
                  JournalViewMode.entries,
                ),
                count: entries.length,
              ),
              AdminFilterOption(
                value: JournalViewMode.ledger,
                label: accountingJournalViewLabel(l10n, JournalViewMode.ledger),
                count: accountingLedgerRows(l10n).length,
              ),
            ],
            selected: mode,
            onSelected: onModeChanged,
          ),
          const SizedBox(height: AppSpacing.small),
          AdminFilterChips<JournalSource?>(
            options: [
              AdminFilterOption(
                value: null,
                label: l10n.adminFilterAll,
                count: entries.length,
              ),
              for (final value in JournalSource.values)
                AdminFilterOption(
                  value: value,
                  label: accountingSourceLabel(l10n, value),
                  count: entries.where((entry) => entry.source == value).length,
                ),
            ],
            selected: source.value,
            onSelected: (value) => source.value = value,
          ),
        ],
      ),
      body: AdminDataTable(
        columns: [
          AdminTableColumn(label: l10n.accountingReference, flex: 2),
          AdminTableColumn(label: l10n.accountingDate, hideBelow: 480),
          AdminTableColumn(label: l10n.accountingSource, hideBelow: 640),
          AdminTableColumn(label: l10n.accountingMemo, flex: 2, hideBelow: 820),
          AdminTableColumn(label: l10n.accountingTotal, alignEnd: true),
          AdminTableColumn(
            label: l10n.accountingStatus,
            alignEnd: true,
            hideBelow: 620,
          ),
        ],
        rows: [
          for (final entry in list.visible)
            AdminTableRow([
              Text(entry.id, style: textTheme.bodyMedium),
              Text(
                accountingDateLabel(context, entry.entryDate),
                style: textTheme.bodySmall,
              ),
              AdminStatusPill(
                label: accountingSourceLabel(l10n, entry.source),
                tone: accountingSourceTone(entry.source),
              ),
              Text(
                entry.memo ?? '—',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
              Text(
                adminFormatAmount(context, entry.totalDebit),
                textAlign: TextAlign.end,
                style: textTheme.bodyMedium,
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: AdminStatusPill(
                  label: entry.balanced
                      ? l10n.accountingBalanced
                      : l10n.accountingUnbalanced,
                  tone: entry.balanced
                      ? AdminPillTone.success
                      : AdminPillTone.warning,
                ),
              ),
            ], onTap: () => onOpen(entry)),
        ],
      ),
    );
  }
}
