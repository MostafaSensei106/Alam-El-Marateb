import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../sample/accounting_sample_operations.dart';
import '../shared/accounting_form_fields.dart';

/// Create form for `POST treasuries/transfers`.
///
/// Body: `{fromId, toId, amount}`.
final class TransferForm extends StatelessWidget {
  const TransferForm({required this.onSave, required this.onCancel, super.key});

  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final treasuries = accountingTreasuries(l10n);
    final options = [
      for (final treasury in treasuries) (treasury.id, treasury.name),
    ];

    return AccountingFormCard(
      title: l10n.accountingNewTransfer,
      icon: LucideIcons.arrowLeftRight,
      fields: [
        AccountingDropdownField<String>(
          label: l10n.accountingTransferFrom,
          icon: LucideIcons.vault,
          hint: l10n.accountingTransferFrom,
          initialValue: options.isEmpty ? null : options.first.$1,
          options: options,
          onChanged: (_) {},
        ),
        AccountingDropdownField<String>(
          label: l10n.accountingTransferTo,
          icon: LucideIcons.vault,
          hint: l10n.accountingTransferTo,
          initialValue: options.length < 2 ? null : options[1].$1,
          options: options,
          onChanged: (_) {},
        ),
        AccountingTextField(
          label: l10n.accountingAmount,
          icon: LucideIcons.banknote,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      ],
      actions: AccountingFormActions(onSave: onSave, onCancel: onCancel),
    );
  }
}
