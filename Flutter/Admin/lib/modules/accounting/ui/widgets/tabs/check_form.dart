import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../sample/accounting_models.dart';
import '../sample/accounting_sample_data.dart';
import '../shared/accounting_form_fields.dart';
import '../shared/accounting_shared.dart';

/// Create/edit form for `POST checks`.
///
/// Body: `{direction: in|out, amount, dueDate?, party?}`; the status is a
/// separate call to `POST checks/{id}/status`.
final class CheckForm extends StatelessWidget {
  const CheckForm({
    required this.onSave,
    required this.onCancel,
    super.key,
    this.check,
  });

  /// `null` renders the create form.
  final CheckRow? check;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final editing = check != null;

    return AccountingFormCard(
      title: editing ? l10n.accountingCheckDetails : l10n.accountingNewCheck,
      icon: LucideIcons.scrollText,
      fields: [
        AccountingDropdownField<CheckDirection>(
          label: l10n.accountingDirection,
          icon: LucideIcons.arrowLeftRight,
          initialValue: check?.direction ?? CheckDirection.incoming,
          options: [
            for (final value in CheckDirection.values)
              (value, accountingDirectionLabel(l10n, value)),
          ],
          onChanged: (_) {},
        ),
        AccountingTextField(
          label: l10n.accountingAmount,
          icon: LucideIcons.banknote,
          initialValue: check?.amount.toStringAsFixed(0),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        AccountingTextField(
          label: l10n.accountingDueDate,
          icon: LucideIcons.calendarDays,
          initialValue: accountingDateLabel(
            context,
            check?.dueDate ?? accountingReferenceDate,
          ),
        ),
        AccountingTextField(
          label: l10n.accountingParty,
          icon: LucideIcons.users,
          initialValue: check?.party,
        ),
        if (editing)
          AccountingDropdownField<CheckStatus>(
            label: l10n.accountingStatus,
            icon: LucideIcons.badgeCheck,
            initialValue: check?.status,
            options: [
              for (final value in CheckStatus.values)
                (value, accountingCheckStatusLabel(l10n, value)),
            ],
            onChanged: (_) {},
          ),
      ],
      actions: AccountingFormActions(onSave: onSave, onCancel: onCancel),
    );
  }
}
