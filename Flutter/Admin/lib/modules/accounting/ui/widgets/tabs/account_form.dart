import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../sample/accounting_models.dart';
import '../shared/accounting_form_fields.dart';

/// Create/edit form for `POST|PUT chart-of-accounts`.
///
/// Body: `{code, nameAr, nameEn?, type, parentCode?, branchId?}`.
final class AccountForm extends StatelessWidget {
  const AccountForm({
    required this.onSave,
    required this.onCancel,
    super.key,
    this.account,
  });

  /// `null` renders the create form.
  final AccountRow? account;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final editing = account != null;

    return AccountingFormCard(
      title: editing
          ? l10n.accountingAccountDetails
          : l10n.accountingNewAccount,
      icon: LucideIcons.network,
      fields: [
        AccountingTextField(
          label: l10n.accountingCode,
          icon: LucideIcons.hash,
          initialValue: account?.code,
          keyboardType: TextInputType.number,
        ),
        AccountingTextField(
          label: l10n.accountingNameAr,
          icon: LucideIcons.type,
          initialValue: account?.name,
        ),
        AccountingTextField(
          label: l10n.accountingNameEn,
          icon: LucideIcons.languages,
        ),
        AccountingDropdownField<AccountType>(
          label: l10n.accountingAccountType,
          icon: LucideIcons.shapes,
          initialValue: account?.type ?? AccountType.asset,
          options: [
            (AccountType.asset, l10n.accountingTypeAsset),
            (AccountType.liability, l10n.accountingTypeLiability),
            (AccountType.equity, l10n.accountingTypeEquity),
            (AccountType.revenue, l10n.accountingTypeRevenue),
            (AccountType.expense, l10n.accountingTypeExpense),
          ],
          onChanged: (_) {},
        ),
        AccountingTextField(
          label: l10n.accountingParentCode,
          icon: LucideIcons.gitBranch,
          initialValue: account?.parentCode,
        ),
        AccountingDropdownField<String>(
          label: l10n.accountingBranch,
          icon: LucideIcons.building2,
          hint: l10n.adminFilterAll,
          initialValue: account?.branchId,
          options: [
            ('br-tanta', l10n.sampleBranch1),
            ('br-cairo', l10n.sampleBranch2),
            ('br-alex', l10n.sampleBranch3),
          ],
          onChanged: (_) {},
        ),
      ],
      actions: AccountingFormActions(onSave: onSave, onCancel: onCancel),
    );
  }
}
