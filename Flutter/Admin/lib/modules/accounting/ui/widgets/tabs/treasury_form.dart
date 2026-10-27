import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../main/ui/widgets/admin_detail_kit.dart';
import '../sample/accounting_models.dart';
import '../shared/accounting_form_fields.dart';

/// Create/edit form for `POST|PUT treasuries`.
///
/// Body: `{branchId?, name, openingBalance?}`.
final class TreasuryForm extends StatelessWidget {
  const TreasuryForm({
    required this.onSave,
    required this.onCancel,
    super.key,
    this.treasury,
  });

  /// `null` renders the create form.
  final TreasuryRow? treasury;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final editing = treasury != null;

    return AccountingFormCard(
      title: editing
          ? l10n.accountingTreasuryDetails
          : l10n.accountingNewTreasury,
      icon: LucideIcons.vault,
      fields: [
        AccountingTextField(
          label: l10n.accountingName,
          icon: LucideIcons.type,
          initialValue: treasury?.name,
        ),
        AccountingDropdownField<String>(
          label: l10n.accountingBranch,
          icon: LucideIcons.building2,
          hint: l10n.adminFilterAll,
          initialValue: treasury?.branchId,
          options: [
            ('br-tanta', l10n.sampleBranch1),
            ('br-cairo', l10n.sampleBranch2),
            ('br-alex', l10n.sampleBranch3),
          ],
          onChanged: (_) {},
        ),
        AccountingTextField(
          label: l10n.accountingOpeningBalance,
          icon: LucideIcons.wallet,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          initialValue: treasury == null
              ? null
              : adminGroupDigits(treasury!.balance),
        ),
      ],
      actions: AccountingFormActions(onSave: onSave, onCancel: onCancel),
    );
  }
}
