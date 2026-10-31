import 'dart:async';

import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/di.dart';
import '../../../../../core/extensions/extensions.dart';
import '../../../../../core/widgets/design_system/tokens/tokens.dart';
import '../../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../../main/ui/widgets/admin_page_frame.dart';
import '../../../logic/cubit/accounting_ledger_cubit.dart';
import '../../../logic/cubit/accounting_ledger_state.dart';
import '../../../logic/entity/accounting_account_entity.dart';
import '../../../logic/entity/accounting_ledger_line_entity.dart';
import '../../../logic/usecase/ledger_usecases.dart';
import '../shared/accounting_async_body.dart';
import '../shared/accounting_shared.dart';

/// Detail view of one `AccountView` row.
///
/// The movement table is a second, independent fetch: the detail owns its own
/// ledger cubit scoped to this account code instead of borrowing the journal
/// tab's data.
final class AccountDetail extends StatelessWidget {
  const AccountDetail({
    required this.account,
    required this.onBack,
    required this.onEdit,
    super.key,
  });

  final AccountingAccountEntity account;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) =>
      BlocSignalProvider<AccountingLedgerCubit>(
        create: (_) {
          final cubit = getIt<AccountingLedgerCubit>();
          unawaited(
            cubit.load(params: GetGeneralLedgerParams(accountCode: account.code)),
          );
          return cubit;
        },
        child: BlocSignalBuilder<AccountingLedgerCubit, AccountingLedgerState>(
          builder: (context, state) => _AccountDetailBody(
            account: account,
            state: state,
            onBack: onBack,
            onEdit: onEdit,
          ),
        ),
      );
}

final class _AccountDetailBody extends StatelessWidget {
  const _AccountDetailBody({
    required this.account,
    required this.state,
    required this.onBack,
    required this.onEdit,
  });

  final AccountingAccountEntity account;
  final AccountingLedgerState state;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final movements = switch (state) {
      AccountingLedgerSuccess(:final items) => items,
      _ => const <AccountingLedgerLineEntity>[],
    };

    return AdminWorkspaceScaffold(
      title: l10n.accountingAccountDetails,
      icon: LucideIcons.network,
      sectionId: 'accounting.accounts',
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
          label: l10n.accountingBalance,
          value: adminFormatAmount(context, account.balance),
          icon: LucideIcons.wallet,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.accountingMetricEntries,
          value: adminGroupDigits(movements.length),
          icon: LucideIcons.listOrdered,
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminSurfaceCard(
            child: Column(
              children: [
                AdminDetailRow(
                  label: l10n.accountingCode,
                  value: account.code,
                  icon: LucideIcons.hash,
                ),
                AdminDetailRow(
                  label: l10n.accountingName,
                  value: account.name,
                  icon: LucideIcons.type,
                ),
                AdminDetailRow(
                  label: l10n.accountingType,
                  value: accountingAccountTypeLabel(l10n, account.type),
                  icon: LucideIcons.shapes,
                ),
                AdminDetailRow(
                  label: l10n.accountingParentCode,
                  value: account.parentCode ?? '—',
                  icon: LucideIcons.gitBranch,
                ),
                AdminDetailRow(
                  label: l10n.accountingBranch,
                  value: account.branchId ?? '—',
                  icon: LucideIcons.building2,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          AdminSectionHeading(
            title: l10n.accountingViewLedger,
            icon: LucideIcons.scrollText,
          ),
          const SizedBox(height: AppSpacing.medium),
          _LedgerSection(
            state: state,
            onRetry: () => context.read<AccountingLedgerCubit>().load(),
          ),
        ],
      ),
    );
  }
}

final class _LedgerSection extends StatelessWidget {
  const _LedgerSection({required this.state, required this.onRetry});

  final AccountingLedgerState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;

    return switch (state) {
      AccountingLedgerInitial() ||
      AccountingLedgerLoading() => const AccountingLoadingBody(),
      AccountingLedgerFailure(:final message) => AccountingFailureBody(
        message: message,
        onRetry: onRetry,
      ),
      AccountingLedgerSuccess(:final items) => AdminDataTable(
        columns: [
          AdminTableColumn(label: l10n.accountingReference, flex: 2),
          AdminTableColumn(label: l10n.accountingDate, hideBelow: 520),
          AdminTableColumn(label: l10n.accountingDebit, alignEnd: true),
          AdminTableColumn(label: l10n.accountingCredit, alignEnd: true),
          AdminTableColumn(
            label: l10n.accountingRunningBalance,
            alignEnd: true,
            flex: 2,
            hideBelow: 680,
          ),
        ],
        rows: [
          for (final row in items)
            AdminTableRow([
              Text(
                row.reference ?? row.entryId ?? '—',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium,
              ),
              Text(
                accountingOptionalDateLabel(context, row.entryDate),
                style: textTheme.bodySmall,
              ),
              Text(adminGroupDigits(row.debit), style: textTheme.bodySmall),
              Text(adminGroupDigits(row.credit), style: textTheme.bodySmall),
              Text(
                adminFormatAmount(context, row.runningBalance),
                style: textTheme.bodySmall,
              ),
            ]),
        ],
      ),
    };
  }
}
