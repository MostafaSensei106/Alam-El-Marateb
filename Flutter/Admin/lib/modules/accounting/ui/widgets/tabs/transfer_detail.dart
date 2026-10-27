import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../../main/ui/widgets/admin_page_frame.dart';
import '../sample/accounting_models.dart';
import '../sample/accounting_sample_operations.dart';
import '../shared/accounting_shared.dart';

/// Detail view of one `TransferView` row.
final class TransferDetail extends StatelessWidget {
  const TransferDetail({
    required this.transfer,
    required this.onBack,
    super.key,
  });

  final TransferRow transfer;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final from = accountingTreasuryName(l10n, transfer.fromId);
    final to = accountingTreasuryName(l10n, transfer.toId);

    return AdminWorkspaceScaffold(
      title: l10n.accountingTransferDetails,
      icon: LucideIcons.arrowLeftRight,
      sectionId: 'accounting.treasuries',
      actions: [accountingBackAction(context, onBack)],
      metrics: [
        AdminMetric(
          label: l10n.accountingAmount,
          value: adminFormatAmount(context, transfer.amount),
          icon: LucideIcons.banknote,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.accountingCreatedBy,
          value: transfer.by,
          icon: LucideIcons.user,
        ),
      ],
      body: AdminSurfaceCard(
        child: Column(
          children: [
            AdminDetailRow(
              label: l10n.accountingReference,
              value: transfer.id,
              icon: LucideIcons.hash,
            ),
            AdminDetailRow(
              label: l10n.accountingDate,
              value: accountingDateLabel(context, transfer.at),
              icon: LucideIcons.calendarDays,
            ),
            AdminDetailRow(
              label: l10n.accountingTransferFrom,
              value: from,
              icon: LucideIcons.arrowUpRight,
            ),
            AdminDetailRow(
              label: l10n.accountingTransferTo,
              value: to,
              icon: LucideIcons.arrowDownLeft,
            ),
            AdminDetailRow(
              label: l10n.accountingAmount,
              value: adminFormatAmount(context, transfer.amount),
              icon: LucideIcons.banknote,
            ),
            AdminDetailRow(
              label: l10n.accountingCreatedBy,
              value: transfer.by,
              icon: LucideIcons.user,
            ),
          ],
        ),
      ),
    );
  }
}
