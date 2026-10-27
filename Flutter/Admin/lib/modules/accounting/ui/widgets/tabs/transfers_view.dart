import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../main/navigation/admin_module.dart';
import '../../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../../main/ui/widgets/admin_page_frame.dart';
import '../sample/accounting_models.dart';
import '../sample/accounting_sample_operations.dart';
import '../shared/accounting_shared.dart';

/// Transfers list (`POST treasuries/transfers`).
final class TransfersView extends HookWidget {
  const TransfersView({
    required this.section,
    required this.mode,
    required this.onModeChanged,
    required this.onCreate,
    required this.onOpen,
    super.key,
  });

  final AdminSubSection section;
  final TreasuryViewMode mode;
  final ValueChanged<TreasuryViewMode> onModeChanged;
  final VoidCallback onCreate;
  final ValueChanged<TransferRow> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final transfers = accountingTransfers(l10n);
    final treasuries = accountingTreasuries(l10n);

    final list = useAdminRecordList<TransferRow>(
      items: transfers,
      searchText: (transfer) =>
          '${transfer.id} ${accountingTreasuryName(l10n, transfer.fromId)} '
          '${accountingTreasuryName(l10n, transfer.toId)} ${transfer.by}',
    );

    final moved = transfers.fold<double>(
      0,
      (sum, transfer) => sum + transfer.amount,
    );

    return AdminWorkspaceScaffold(
      title: section.title,
      icon: section.icon,
      sectionId: section.id,
      list: list,
      onCreate: onCreate,
      searchHint: l10n.accountingSearchTransfers,
      metrics: [
        AdminMetric(
          label: l10n.accountingMetricTransfers,
          value: adminGroupDigits(transfers.length),
          icon: LucideIcons.arrowLeftRight,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.accountingTotalMoved,
          value: adminFormatAmount(context, moved),
          icon: LucideIcons.trendingUp,
          tone: AdminPillTone.success,
        ),
      ],
      filters: AccountingViewSwitch<TreasuryViewMode>(
        options: [
          AdminFilterOption(
            value: TreasuryViewMode.treasuries,
            label: accountingTreasuryViewLabel(
              l10n,
              TreasuryViewMode.treasuries,
            ),
            count: treasuries.length,
          ),
          AdminFilterOption(
            value: TreasuryViewMode.transfers,
            label: accountingTreasuryViewLabel(
              l10n,
              TreasuryViewMode.transfers,
            ),
            count: transfers.length,
          ),
        ],
        selected: mode,
        onSelected: onModeChanged,
      ),
      body: AdminDataTable(
        columns: [
          AdminTableColumn(label: l10n.accountingReference, flex: 2),
          AdminTableColumn(label: l10n.accountingDate, hideBelow: 480),
          AdminTableColumn(label: l10n.accountingFrom, hideBelow: 640),
          AdminTableColumn(label: l10n.accountingTo, hideBelow: 640),
          AdminTableColumn(label: l10n.accountingAmount, alignEnd: true),
          AdminTableColumn(
            label: l10n.accountingCreatedBy,
            flex: 2,
            hideBelow: 900,
          ),
        ],
        rows: [
          for (final transfer in list.visible)
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
              Text(transfer.by, style: textTheme.bodySmall),
            ], onTap: () => onOpen(transfer)),
        ],
      ),
    );
  }
}
