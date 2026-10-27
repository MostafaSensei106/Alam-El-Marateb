import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../../main/ui/widgets/admin_page_frame.dart';
import '../sample/accounting_models.dart';
import '../shared/accounting_shared.dart';

/// Detail view of one `CheckView` row.
final class CheckDetail extends StatelessWidget {
  const CheckDetail({
    required this.check,
    required this.onBack,
    required this.onEdit,
    super.key,
  });

  final CheckRow check;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;

    return AdminWorkspaceScaffold(
      title: l10n.accountingCheckDetails,
      icon: LucideIcons.scrollText,
      sectionId: 'accounting.checks',
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
          label: l10n.accountingAmount,
          value: adminFormatAmount(context, check.amount),
          icon: LucideIcons.banknote,
          tone: check.direction == CheckDirection.incoming
              ? AdminPillTone.success
              : AdminPillTone.warning,
        ),
        AdminMetric(
          label: l10n.accountingStatus,
          value: accountingCheckStatusLabel(l10n, check.status),
          icon: LucideIcons.badgeCheck,
          tone: accountingCheckStatusTone(check.status),
        ),
      ],
      body: AdminSurfaceCard(
        child: Column(
          children: [
            AdminDetailRow(
              label: l10n.accountingReference,
              value: check.id,
              icon: LucideIcons.hash,
            ),
            AdminDetailRow(
              label: l10n.accountingDirection,
              value: accountingDirectionLabel(l10n, check.direction),
              icon: check.direction == CheckDirection.incoming
                  ? LucideIcons.arrowDownLeft
                  : LucideIcons.arrowUpRight,
            ),
            AdminDetailRow(
              label: l10n.accountingParty,
              value: check.party ?? '—',
              icon: LucideIcons.users,
            ),
            AdminDetailRow(
              label: l10n.accountingDueDate,
              value: check.dueDate == null
                  ? '—'
                  : accountingDateLabel(context, check.dueDate!),
              icon: LucideIcons.calendarDays,
            ),
            AdminDetailRow(
              label: l10n.accountingStatus,
              value: accountingCheckStatusLabel(l10n, check.status),
              icon: LucideIcons.badgeCheck,
            ),
            AdminDetailRow(
              label: l10n.accountingAmount,
              value: adminFormatAmount(context, check.amount),
              icon: LucideIcons.banknote,
            ),
          ],
        ),
      ),
    );
  }
}
