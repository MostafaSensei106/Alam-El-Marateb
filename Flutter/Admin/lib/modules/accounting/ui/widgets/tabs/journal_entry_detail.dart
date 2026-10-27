import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../../main/ui/widgets/admin_page_frame.dart';
import '../sample/accounting_models.dart';
import '../sample/accounting_sample_data.dart';
import '../shared/accounting_shared.dart';

/// Read-only detail screen for `GET journal-entries/{id}`.
///
/// The endpoint only exposes `GET` and `POST`, so the entry itself is never
/// editable from the UI.
final class JournalEntryDetail extends StatelessWidget {
  const JournalEntryDetail({
    required this.entry,
    required this.onBack,
    super.key,
  });

  final JournalRow entry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;

    return AdminWorkspaceScaffold(
      title: l10n.accountingEntryDetails,
      icon: LucideIcons.bookOpen,
      sectionId: 'accounting.journal',
      actions: [
        accountingBackAction(context, onBack),
        AdminStatusPill(
          label: entry.balanced
              ? l10n.accountingBalanced
              : l10n.accountingUnbalanced,
          tone: entry.balanced ? AdminPillTone.success : AdminPillTone.warning,
        ),
      ],
      metrics: [
        AdminMetric(
          label: l10n.accountingTotalDebit,
          value: adminFormatAmount(context, entry.totalDebit),
          icon: LucideIcons.trendingUp,
          tone: AdminPillTone.success,
        ),
        AdminMetric(
          label: l10n.accountingTotalCredit,
          value: adminFormatAmount(context, entry.totalCredit),
          icon: LucideIcons.trendingDown,
          tone: AdminPillTone.warning,
        ),
        AdminMetric(
          label: l10n.accountingLines,
          value: adminGroupDigits(entry.lines.length),
          icon: LucideIcons.listOrdered,
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSurfaceCard(
            child: Column(
              children: [
                AdminDetailRow(
                  label: l10n.accountingReference,
                  value: entry.id,
                  icon: LucideIcons.hash,
                ),
                AdminDetailRow(
                  label: l10n.accountingEntryDate,
                  value: accountingDateLabel(context, entry.entryDate),
                  icon: LucideIcons.calendarDays,
                ),
                AdminDetailRow(
                  label: l10n.accountingSource,
                  value: accountingSourceLabel(l10n, entry.source),
                  icon: LucideIcons.workflow,
                ),
                AdminDetailRow(
                  label: l10n.accountingReference,
                  value: entry.reference ?? '—',
                  icon: LucideIcons.tag,
                ),
                AdminDetailRow(
                  label: l10n.accountingBranch,
                  value: accountingBranchName(l10n, entry.branchId) ?? '—',
                  icon: LucideIcons.building2,
                ),
                AdminDetailRow(
                  label: l10n.accountingMemo,
                  value: entry.memo ?? '—',
                  icon: LucideIcons.stickyNote,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          AdminSectionHeading(
            title: l10n.accountingLines,
            icon: LucideIcons.listOrdered,
          ),
          const SizedBox(height: AppSpacing.medium),
          AdminDataTable(
            columns: [
              AdminTableColumn(label: l10n.accountingCode, hideBelow: 480),
              AdminTableColumn(label: l10n.accountingAccount, flex: 2),
              AdminTableColumn(label: l10n.accountingDebit, alignEnd: true),
              AdminTableColumn(label: l10n.accountingCredit, alignEnd: true),
            ],
            rows: [
              for (final line in entry.lines)
                AdminTableRow([
                  Text(line.accountCode, style: textTheme.bodySmall),
                  Text(line.accountName, style: textTheme.bodyMedium),
                  Text(
                    line.debit == 0 ? '—' : adminGroupDigits(line.debit),
                    textAlign: TextAlign.end,
                    style: textTheme.bodySmall,
                  ),
                  Text(
                    line.credit == 0 ? '—' : adminGroupDigits(line.credit),
                    textAlign: TextAlign.end,
                    style: textTheme.bodySmall,
                  ),
                ]),
            ],
          ),
        ],
      ),
    );
  }
}
