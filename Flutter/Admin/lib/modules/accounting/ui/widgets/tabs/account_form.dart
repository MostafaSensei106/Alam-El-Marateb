import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/di.dart';
import '../../../../../core/extensions/extensions.dart';
import '../../../logic/cubit/accounting_accounts_cubit.dart';
import '../../../logic/cubit/accounting_accounts_state.dart';
import '../../../logic/entity/accounting_account_entity.dart';
import '../../../logic/entity/accounting_enums.dart';
import '../shared/accounting_async_body.dart';
import '../shared/accounting_form_fields.dart';
import '../shared/accounting_shared.dart';

/// Create/edit form for `POST|PATCH chart-of-accounts`.
///
/// Create body: `{code, nameAr, nameEn?, type, parentCode?}`.
/// Update body: `{nameAr?, nameEn?, type?, parentCode?}` — the code is the key
/// and therefore read-only while editing.
final class AccountForm extends HookWidget {
  const AccountForm({
    required this.onSaved,
    required this.onCancel,
    super.key,
    this.account,
  });

  /// `null` renders the create form.
  final AccountingAccountEntity? account;
  final VoidCallback onSaved;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final editing = account != null;

    final codeController = useTextEditingController(text: account?.code);
    final nameController = useTextEditingController(text: account?.name);
    final nameEnController = useTextEditingController();
    final parentCodeController = useTextEditingController(
      text: account?.parentCode,
    );
    final type = useState<AccountType>(account?.type ?? AccountType.asset);
    final codeError = useState<String?>(null);
    final nameError = useState<String?>(null);
    final submitting = useState(false);

    Future<void> submit() async {
      if (submitting.value) return;

      final code = codeController.text.trim();
      final name = nameController.text.trim();
      final required = l10n.catalogRequired;
      codeError.value = code.isEmpty ? required : null;
      nameError.value = name.isEmpty ? required : null;
      if (codeError.value != null || nameError.value != null) return;

      submitting.value = true;
      final cubit = context.read<AccountingAccountsCubit>();
      final nameEn = _optional(nameEnController.text);
      final parentCode = _optional(parentCodeController.text);
      final edited = account;

      final saved = edited == null
          ? await cubit.create(
              code: code,
              name: name,
              nameEn: nameEn,
              type: type.value,
              parentCode: parentCode,
            )
          : await cubit.update(
              code: edited.code,
              name: name,
              nameEn: nameEn,
              type: type.value,
              parentCode: parentCode,
            );

      if (!context.mounted) return;
      submitting.value = false;
      if (saved) onSaved();
    }

    return BlocSignalBuilder<AccountingAccountsCubit, AccountingAccountsState>(
      builder: (context, state) {
        final isSaving = switch (state) {
          AccountingAccountsSuccess(:final isSaving) => isSaving,
          _ => false,
        };
        final errorMessage = switch (state) {
          AccountingAccountsSuccess(:final errorMessage) => errorMessage,
          _ => null,
        };

        return AccountingFormCard(
          title: editing
              ? l10n.accountingAccountDetails
              : l10n.accountingNewAccount,
          icon: LucideIcons.network,
          fields: [
            if (errorMessage != null)
              AccountingFormWide(
                child: AccountingErrorNotice(message: errorMessage),
              ),
            AccountingTextField(
              label: l10n.accountingCode,
              icon: LucideIcons.hash,
              controller: codeController,
              readOnly: editing,
              errorText: codeError.value,
              onChanged: (_) => codeError.value = null,
            ),
            AccountingTextField(
              label: l10n.accountingNameAr,
              icon: LucideIcons.type,
              controller: nameController,
              errorText: nameError.value,
              onChanged: (_) => nameError.value = null,
            ),
            AccountingTextField(
              label: l10n.accountingNameEn,
              icon: LucideIcons.languages,
              controller: nameEnController,
            ),
            AccountingDropdownField<AccountType>(
              label: l10n.accountingAccountType,
              icon: LucideIcons.shapes,
              initialValue: type.value,
              options: [
                for (final value in AccountType.values)
                  (value, accountingAccountTypeLabel(l10n, value)),
              ],
              onChanged: (value) {
                if (value != null) type.value = value;
              },
            ),
            AccountingTextField(
              label: l10n.accountingParentCode,
              icon: LucideIcons.gitBranch,
              controller: parentCodeController,
            ),
          ],
          actions: AccountingFormActions(
            onSave: submit,
            onCancel: onCancel,
            saving: submitting.value || isSaving,
          ),
        );
      },
    );
  }
}

String? _optional(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
