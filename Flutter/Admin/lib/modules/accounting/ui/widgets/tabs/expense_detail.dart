import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../../main/ui/widgets/admin_page_frame.dart';
import '../sample/accounting_models.dart';
import '../sample/accounting_sample_data.dart';
import '../shared/accounting_shared.dart';

/// Detail view of one `ExpenseView` row.
final class ExpenseDetail extends StatelessWidget {
  const ExpenseDetail({
    required this.expense,
    required this.onBack,
    required this.onEdit,
    super.key,
  });

  final ExpenseRow expense;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;

    return AdminWorkspaceScaffold(
      title: l10n.accountingExpenseDetails,
      icon: LucideIcons.receipt,
      sectionId: 'accounting.expenses',
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
          value: adminFormatAmount(context, expense.amount),
          icon: LucideIcons.banknote,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.accountingStatus,
          value: accountingApprovalLabel(l10n, expense),
          icon: expense.approved ? LucideIcons.check : LucideIcons.clock,
          tone: accountingApprovalTone(expense),
        ),
      ],
      body: AdminSurfaceCard(
        child: Column(
          children: [
            AdminDetailRow(
              label: l10n.accountingReference,
              value: expense.id,
              icon: LucideIcons.hash,
            ),
            AdminDetailRow(
              label: l10n.accountingCategory,
              value: accountingCategoryLabel(l10n, expense.category),
              icon: LucideIcons.tags,
            ),
            AdminDetailRow(
              label: l10n.accountingBranch,
              value: accountingBranchName(l10n, expense.branchId) ?? '—',
              icon: LucideIcons.building2,
            ),
            AdminDetailRow(
              label: l10n.accountingAmount,
              value: adminFormatAmount(context, expense.amount),
              icon: LucideIcons.banknote,
            ),
            AdminDetailRow(
              label: l10n.accountingReceipt,
              value: expense.hasReceipt
                  ? l10n.accountingReceiptAttached
                  : l10n.accountingNoReceipt,
              icon: LucideIcons.paperclip,
            ),
            AdminDetailRow(
              label: expense.approved
                  ? l10n.accountingApprovedBy
                  : l10n.accountingApprovalPending,
              value: expense.approvedBy ?? '—',
              icon: LucideIcons.userCheck,
            ),
          ],
        ),
      ),
    );
  }
}
