import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../main/ui/widgets/admin_detail_kit.dart';
import '../sample/accounting_models.dart';
import '../sample/accounting_sample_data.dart';
import '../shared/accounting_form_fields.dart';
import '../shared/accounting_shared.dart';

/// Create form for `POST journal-entries`.
///
/// Body: `{branchId?, entryDate, source, ref?, memo?, lines?}`. Journal entries
/// are append-only in the API, so the same form covers the sample edit flow.
final class JournalEntryForm extends StatelessWidget {
  const JournalEntryForm({
    required this.onSave,
    required this.onCancel,
    super.key,
  });

  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;

    return AccountingFormCard(
      title: l10n.accountingNewEntry,
      icon: LucideIcons.bookOpen,
      fields: [
        AccountingDropdownField<String>(
          label: l10n.accountingBranch,
          icon: LucideIcons.building2,
          hint: l10n.adminFilterAll,
          options: [
            ('br-tanta', l10n.sampleBranch1),
            ('br-cairo', l10n.sampleBranch2),
            ('br-alex', l10n.sampleBranch3),
          ],
          onChanged: (_) {},
        ),
        AccountingTextField(
          label: l10n.accountingEntryDate,
          icon: LucideIcons.calendarDays,
          initialValue: accountingDateLabel(context, accountingReferenceDate),
          readOnly: true,
        ),
        AccountingDropdownField<JournalSource>(
          label: l10n.accountingSource,
          icon: LucideIcons.workflow,
          initialValue: JournalSource.manual,
          options: [
            for (final value in JournalSource.values)
              (value, accountingSourceLabel(l10n, value)),
          ],
          onChanged: (_) {},
        ),
        AccountingTextField(
          label: l10n.accountingReference,
          icon: LucideIcons.tag,
        ),
        AccountingFormWide(
          child: AccountingTextField(
            label: l10n.accountingMemo,
            icon: LucideIcons.stickyNote,
            maxLines: 2,
          ),
        ),
        const AccountingFormWide(
          child: _SampleLines(code1: '1110', code2: '4110', amount: 45000),
        ),
      ],
      actions: AccountingFormActions(onSave: onSave, onCancel: onCancel),
    );
  }
}

/// Balanced two-line block standing in for the journal line editor.
final class _SampleLines extends StatelessWidget {
  const _SampleLines({
    required this.code1,
    required this.code2,
    required this.amount,
  });

  final String code1;
  final String code2;
  final double amount;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(l10n.accountingLines, style: textTheme.titleSmall),
            const Spacer(),
            TextButton.icon(
              onPressed: () => accountingShowSampleAction(context),
              icon: const Icon(LucideIcons.plus, size: AppIconSizes.small),
              label: Text(l10n.accountingAddLine),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.small),
        _LineRow(
          code: code1,
          name: accountingAccountName(l10n, code1),
          debit: adminFormatAmount(context, amount),
          credit: '—',
        ),
        Divider(height: AppSpacing.large, color: colorScheme.outlineVariant),
        _LineRow(
          code: code2,
          name: accountingAccountName(l10n, code2),
          debit: '—',
          credit: adminFormatAmount(context, amount),
        ),
      ],
    );
  }
}

final class _LineRow extends StatelessWidget {
  const _LineRow({
    required this.code,
    required this.name,
    required this.debit,
    required this.credit,
  });

  final String code;
  final String name;
  final String debit;
  final String credit;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        SizedBox(width: 56, child: Text(code, style: textTheme.bodySmall)),
        Expanded(
          child: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium,
          ),
        ),
        SizedBox(
          width: 96,
          child: Text(
            debit,
            textAlign: TextAlign.end,
            style: textTheme.bodySmall,
          ),
        ),
        SizedBox(
          width: 96,
          child: Text(
            credit,
            textAlign: TextAlign.end,
            style: textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
