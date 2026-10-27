import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../main/navigation/admin_module.dart';
import '../../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../../main/ui/widgets/admin_page_frame.dart';
import '../sample/accounting_models.dart';
import '../sample/accounting_sample_data.dart';
import '../sample/accounting_sample_operations.dart';
import '../shared/accounting_shared.dart';

/// Treasuries list (`GET|POST treasuries`).
final class TreasuriesView extends HookWidget {
  const TreasuriesView({
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
  final ValueChanged<TreasuryRow> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final treasuries = accountingTreasuries(l10n);
    final transfers = accountingTransfers(l10n);

    final list = useAdminRecordList<TreasuryRow>(
      items: treasuries,
      searchText: (treasury) =>
          '${treasury.name} '
          '${accountingBranchName(l10n, treasury.branchId) ?? ''}',
    );

    final totalBalance = treasuries.fold<double>(
      0,
      (sum, treasury) => sum + treasury.balance,
    );

    int transferCount(TreasuryRow treasury) => transfers
        .where(
          (transfer) =>
              transfer.fromId == treasury.id || transfer.toId == treasury.id,
        )
        .length;

    return AdminWorkspaceScaffold(
      title: section.title,
      icon: section.icon,
      sectionId: section.id,
      list: list,
      onCreate: onCreate,
      searchHint: l10n.accountingSearchTreasuries,
      metrics: [
        AdminMetric(
          label: l10n.accountingMetricTreasuries,
          value: adminGroupDigits(treasuries.length),
          icon: LucideIcons.vault,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.accountingMetricTotalBalance,
          value: adminFormatAmount(context, totalBalance),
          icon: LucideIcons.wallet,
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
          AdminTableColumn(label: l10n.accountingName, flex: 2),
          AdminTableColumn(label: l10n.accountingBranch, hideBelow: 520),
          AdminTableColumn(
            label: l10n.accountingBalance,
            alignEnd: true,
            flex: 2,
          ),
          AdminTableColumn(
            label: l10n.accountingMetricTransfers,
            alignEnd: true,
            hideBelow: 720,
          ),
        ],
        rows: [
          for (final treasury in list.visible)
            AdminTableRow([
              Text(treasury.name, style: textTheme.bodyMedium),
              Text(
                accountingBranchName(l10n, treasury.branchId) ?? '—',
                style: textTheme.bodySmall,
              ),
              Text(
                adminFormatAmount(context, treasury.balance),
                textAlign: TextAlign.end,
                style: textTheme.bodyMedium,
              ),
              Text(
                adminGroupDigits(transferCount(treasury)),
                textAlign: TextAlign.end,
                style: textTheme.bodySmall,
              ),
            ], onTap: () => onOpen(treasury)),
        ],
      ),
    );
  }
}
