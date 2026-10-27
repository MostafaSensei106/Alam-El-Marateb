import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../../main/ui/widgets/admin_page_frame.dart';
import '../sample/accounting_models.dart';
import '../sample/accounting_sample_data.dart';
import '../sample/accounting_sample_operations.dart';
import '../shared/accounting_shared.dart';

/// Detail view of one `TreasuryView` row plus its transfers.
final class TreasuryDetail extends StatelessWidget {
  const TreasuryDetail({
    required this.treasury,
    required this.onBack,
    required this.onEdit,
    required this.onOpenTransfer,
    super.key,
  });

  final TreasuryRow treasury;
  final VoidCallback onBack;
  final VoidCallback onEdit;
  final ValueChanged<TransferRow> onOpenTransfer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final related = accountingTransfers(l10n)
        .where(
          (transfer) =>
              transfer.fromId == treasury.id || transfer.toId == treasury.id,
        )
        .toList(growable: false);
    final moved = related.fold<double>(
      0,
      (sum, transfer) => sum + transfer.amount,
    );

    return AdminWorkspaceScaffold(
      title: l10n.accountingTreasuryDetails,
      icon: LucideIcons.vault,
      sectionId: 'accounting.treasuries',
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
          value: adminFormatAmount(context, treasury.balance),
          icon: LucideIcons.wallet,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.accountingMetricTransfers,
          value: adminGroupDigits(related.length),
          icon: LucideIcons.arrowLeftRight,
        ),
        AdminMetric(
          label: l10n.accountingTotalMoved,
          value: adminFormatAmount(context, moved),
          icon: LucideIcons.trendingUp,
          tone: AdminPillTone.success,
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSurfaceCard(
            child: Column(
              children: [
                AdminDetailRow(
                  label: l10n.accountingName,
                  value: treasury.name,
                  icon: LucideIcons.type,
                ),
                AdminDetailRow(
                  label: l10n.accountingBranch,
                  value: accountingBranchName(l10n, treasury.branchId) ?? '—',
                  icon: LucideIcons.building2,
                ),
                AdminDetailRow(
                  label: l10n.accountingBalance,
                  value: adminFormatAmount(context, treasury.balance),
                  icon: LucideIcons.wallet,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          AdminSectionHeading(
            title: l10n.accountingViewTransfers,
            icon: LucideIcons.arrowLeftRight,
          ),
          const SizedBox(height: AppSpacing.medium),
          AdminDataTable(
            columns: [
              AdminTableColumn(label: l10n.accountingReference, flex: 2),
              AdminTableColumn(label: l10n.accountingDate, hideBelow: 480),
              AdminTableColumn(label: l10n.accountingFrom, hideBelow: 640),
              AdminTableColumn(label: l10n.accountingTo, hideBelow: 640),
              AdminTableColumn(label: l10n.accountingAmount, alignEnd: true),
            ],
            rows: [
              for (final transfer in related)
                AdminTableRow([
                  Text(transfer.id, style: textTheme.bodyMedium),
                  Text(
                    accountingDateLabel(context, transfer.at),
                    style: textTheme.bodySmall,
                  ),
                  Text(
                    accountingTreasuryName(l10n, transfer.fromId),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  ),
                  Text(
                    accountingTreasuryName(l10n, transfer.toId),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  ),
                  Text(
                    adminFormatAmount(context, transfer.amount),
                    textAlign: TextAlign.end,
                    style: textTheme.bodyMedium,
                  ),
                ], onTap: () => onOpenTransfer(transfer)),
            ],
          ),
        ],
      ),
    );
  }
}
