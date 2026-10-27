import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../sample/accounting_models.dart';
import '../shared/accounting_form_fields.dart';
import '../shared/accounting_shared.dart';

/// Create/edit form for `POST|PUT expenses`.
///
/// Body: `{branchId?, category, amount, receiptPhoto?, approvedBy?}`.
final class ExpenseForm extends StatelessWidget {
  const ExpenseForm({
    required this.onSave,
    required this.onCancel,
    super.key,
    this.expense,
  });

  /// `null` renders the create form.
  final ExpenseRow? expense;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final editing = expense != null;

    return AccountingFormCard(
      title: editing
          ? l10n.accountingExpenseDetails
          : l10n.accountingNewExpense,
      icon: LucideIcons.receipt,
      fields: [
        AccountingDropdownField<ExpenseCategory>(
          label: l10n.accountingCategory,
          icon: LucideIcons.tags,
          initialValue: expense?.category ?? ExpenseCategory.rent,
          options: [
            for (final value in ExpenseCategory.values)
              (value, accountingCategoryLabel(l10n, value)),
          ],
          onChanged: (_) {},
        ),
        AccountingDropdownField<String>(
          label: l10n.accountingBranch,
          icon: LucideIcons.building2,
          hint: l10n.adminFilterAll,
          initialValue: expense?.branchId,
          options: [
            ('br-tanta', l10n.sampleBranch1),
            ('br-cairo', l10n.sampleBranch2),
            ('br-alex', l10n.sampleBranch3),
          ],
          onChanged: (_) {},
        ),
        AccountingTextField(
          label: l10n.accountingAmount,
          icon: LucideIcons.banknote,
          initialValue: expense?.amount.toStringAsFixed(0),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        AccountingTextField(
          label: l10n.accountingReceipt,
          icon: LucideIcons.paperclip,
          initialValue: expense?.receiptPhoto,
          hint: l10n.accountingReceiptAttached,
        ),
        AccountingTextField(
          label: l10n.accountingApprovedBy,
          icon: LucideIcons.userCheck,
          initialValue: expense?.approvedBy,
          hint: l10n.accountingApprovalPending,
        ),
      ],
      actions: AccountingFormActions(onSave: onSave, onCancel: onCancel),
    );
  }
}
