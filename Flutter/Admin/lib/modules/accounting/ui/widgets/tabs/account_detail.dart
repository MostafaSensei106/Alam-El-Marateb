import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../../main/ui/widgets/admin_page_frame.dart';
import '../sample/accounting_models.dart';
import '../sample/accounting_sample_data.dart';
import '../shared/accounting_shared.dart';

/// Detail view of one `AccountView` row.
final class AccountDetail extends StatelessWidget {
  const AccountDetail({
    required this.account,
    required this.onBack,
    required this.onEdit,
    super.key,
  });

  final AccountRow account;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final movements = accountingLedgerRows(l10n)
        .where((row) => row.accountCode == account.code)
        .toList(growable: false);

    return AdminWorkspaceScaffold(
      title: l10n.accountingAccountDetails,
      icon: LucideIcons.network,
      sectionId: 'accounting.accounts',
      actions: [
        accountingBackAction(context, onBack),
        TextButton.icon(
          onPressed: onEdit,
          icon: const Icon(LucideIcons.pencil, size: AppIconSizes.small),
          label: Text(l10n.accountingEdit),
        ),
      ],
      metrics: [
        AdminMetric(
          label: l10n.accountingBalance,
          value: adminFormatAmount(context, account.balance),
          icon: LucideIcons.wallet,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.accountingMetricEntries,
          value: adminGroupDigits(movements.length),
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
                  label: l10n.accountingCode,
                  value: account.code,
                  icon: LucideIcons.hash,
                ),
                AdminDetailRow(
                  label: l10n.accountingName,
                  value: account.name,
                  icon: LucideIcons.type,
                ),
                AdminDetailRow(
                  label: l10n.accountingType,
                  value: accountingAccountTypeLabel(l10n, account.type),
                  icon: LucideIcons.shapes,
                ),
                AdminDetailRow(
                  label: l10n.accountingParentCode,
                  value: account.parentCode ?? '—',
                  icon: LucideIcons.gitBranch,
                ),
                AdminDetailRow(
                  label: l10n.accountingBranch,
                  value: accountingBranchName(l10n, account.branchId) ?? '—',
                  icon: LucideIcons.building2,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          AdminSectionHeading(
            title: l10n.accountingViewLedger,
            icon: LucideIcons.scrollText,
          ),
          const SizedBox(height: AppSpacing.medium),
          AdminDataTable(
            columns: [
              AdminTableColumn(label: l10n.accountingReference, flex: 2),
              AdminTableColumn(label: l10n.accountingDate, hideBelow: 520),
              AdminTableColumn(label: l10n.accountingDebit, alignEnd: true),
              AdminTableColumn(label: l10n.accountingCredit, alignEnd: true),
              AdminTableColumn(
                label: l10n.accountingRunningBalance,
                alignEnd: true,
                flex: 2,
                hideBelow: 680,
              ),
            ],
            rows: [
              for (final row in movements)
                AdminTableRow([
                  Text(row.entryId, style: textTheme.bodyMedium),
                  Text(
                    accountingDateLabel(context, row.entryDate),
                    style: textTheme.bodySmall,
                  ),
                  Text(adminGroupDigits(row.debit), style: textTheme.bodySmall),
                  Text(
                    adminGroupDigits(row.credit),
                    style: textTheme.bodySmall,
                  ),
                  Text(
                    adminFormatAmount(context, row.runningBalance),
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
