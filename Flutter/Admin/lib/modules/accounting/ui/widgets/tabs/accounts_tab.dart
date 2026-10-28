import 'package:bloc_signals_flutter/bloc_signals_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/di.dart';
import '../../../../../core/extensions/extensions.dart';
import '../../../../main/navigation/admin_module.dart';
import '../../../../main/ui/widgets/admin_detail_kit.dart';
import '../../../logic/cubit/accounting_accounts_cubit.dart';
import '../../../logic/cubit/accounting_accounts_state.dart';
import '../../../logic/entity/accounting_account_entity.dart';
import '../../../logic/entity/accounting_enums.dart';
import '../shared/accounting_async_body.dart';
import '../shared/accounting_shared.dart';
import 'account_detail.dart';
import 'account_form.dart';

/// Chart of accounts tab (`GET|POST chart-of-accounts`).
///
/// The cubit is provided above the whole tab so the list, the detail and the
/// form all talk to the same instance. The list lives in its own hook widget so
/// the search and pagination hooks are never skipped.
final class AccountsTab extends StatelessWidget {
  const AccountsTab({required this.section, super.key});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) => BlocSignalProvider<AccountingAccountsCubit>(
    create: (_) => getIt<AccountingAccountsCubit>()..load(),
    child: _AccountsFlow(section: section),
  );
}

final class _AccountsFlow extends HookWidget {
  const _AccountsFlow({required this.section});

  final AdminSubSection section;

  @override
  Widget build(BuildContext context) {
    final selected = useState<AccountingAccountEntity?>(null);
    final editing = useState<AccountingAccountEntity?>(null);
    final creating = useState(false);

    void closeForm() {
      creating.value = false;
      editing.value = null;
    }

    if (creating.value || editing.value != null) {
      return AccountForm(
        account: editing.value,
        onSaved: () {
          closeForm();
          selected.value = null;
        },
        onCancel: closeForm,
      );
    }

    final account = selected.value;
    if (account != null) {
      return AccountDetail(
        account: account,
        onBack: () => selected.value = null,
        onEdit: () => editing.value = account,
      );
    }

    return _AccountsList(
      section: section,
      onCreate: () => creating.value = true,
      onOpen: (account) => selected.value = account,
    );
  }
}

final class _AccountsList extends StatelessWidget {
  const _AccountsList({
    required this.section,
    required this.onCreate,
    required this.onOpen,
  });

  final AdminSubSection section;
  final VoidCallback onCreate;
  final ValueChanged<AccountingAccountEntity> onOpen;

  @override
  Widget build(BuildContext context) => BlocSignalBuilder<
    AccountingAccountsCubit,
    AccountingAccountsState
  >(
    builder: (context, state) => switch (state) {
      AccountingAccountsInitial() || AccountingAccountsLoading() =>
        AdminWorkspaceScaffold(
          title: section.title,
          icon: section.icon,
          sectionId: section.id,
          body: const AccountingLoadingBody(),
        ),
      AccountingAccountsFailure(:final message) => AdminWorkspaceScaffold(
        title: section.title,
        icon: section.icon,
        sectionId: section.id,
        body: AccountingFailureBody(
          message: message,
          onRetry: () => context.read<AccountingAccountsCubit>().load(),
        ),
      ),
      AccountingAccountsSuccess(
        :final items,
        :final isSaving,
        :final errorMessage,
      ) =>
        _AccountsContent(
          section: section,
          accounts: items,
          isSaving: isSaving,
          errorMessage: errorMessage,
          onCreate: onCreate,
          onOpen: onOpen,
        ),
    },
  );
}

final class _AccountsContent extends HookWidget {
  const _AccountsContent({
    required this.section,
    required this.accounts,
    required this.isSaving,
    required this.errorMessage,
    required this.onCreate,
    required this.onOpen,
  });

  final AdminSubSection section;
  final List<AccountingAccountEntity> accounts;
  final bool isSaving;
  final String? errorMessage;
  final VoidCallback onCreate;
  final ValueChanged<AccountingAccountEntity> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = context.localeKeys;
    final textTheme = Theme.of(context).textTheme;
    final type = useState<AccountType?>(null);

    final scoped = type.value == null
        ? accounts
        : accounts
              .where((account) => account.type == type.value)
              .toList(growable: false);

    final list = useAdminRecordList<AccountingAccountEntity>(
      items: scoped,
      searchText: (account) =>
          '${account.code} ${account.name} ${account.parentCode ?? ''} '
          '${account.branchId ?? ''}',
    );

    final assets = _total(accounts, AccountType.asset);
    final liabilities = _total(accounts, AccountType.liability);
    final equity = _total(accounts, AccountType.equity);

    return AdminWorkspaceScaffold(
      title: section.title,
      icon: section.icon,
      sectionId: section.id,
      list: list,
      onCreate: isSaving ? null : onCreate,
      searchHint: l10n.accountingSearchAccounts,
      notice: errorMessage == null
          ? null
          : AccountingErrorNotice(message: errorMessage!),
      metrics: [
        AdminMetric(
          label: l10n.accountingMetricAccounts,
          value: adminGroupDigits(accounts.length),
          icon: LucideIcons.network,
          tone: AdminPillTone.primary,
        ),
        AdminMetric(
          label: l10n.accountingMetricAssets,
          value: adminFormatAmount(context, assets),
          icon: LucideIcons.trendingUp,
          tone: AdminPillTone.success,
        ),
        AdminMetric(
          label: l10n.accountingMetricLiabilities,
          value: adminFormatAmount(context, liabilities),
          icon: LucideIcons.trendingDown,
          tone: AdminPillTone.warning,
        ),
        AdminMetric(
          label: l10n.accountingMetricEquity,
          value: adminFormatAmount(context, equity),
          icon: LucideIcons.landmark,
          tone: AdminPillTone.primary,
        ),
      ],
      filters: AdminFilterChips<AccountType?>(
        options: [
          AdminFilterOption(
            value: null,
            label: l10n.adminFilterAll,
            count: accounts.length,
          ),
          for (final value in AccountType.values)
            AdminFilterOption(
              value: value,
              label: accountingAccountTypeLabel(l10n, value),
              count: accounts.where((account) => account.type == value).length,
            ),
        ],
        selected: type.value,
        onSelected: (value) => type.value = value,
      ),
      body: AdminDataTable(
        columns: [
          AdminTableColumn(label: l10n.accountingCode),
          AdminTableColumn(label: l10n.accountingName, flex: 2),
          AdminTableColumn(label: l10n.accountingType, hideBelow: 560),
          AdminTableColumn(label: l10n.accountingBranch, hideBelow: 720),
          AdminTableColumn(label: l10n.accountingBalance, alignEnd: true),
        ],
        rows: [
          for (final account in list.visible)
            AdminTableRow([
              Text(account.code, style: textTheme.bodyMedium),
              Text(
                account.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium,
              ),
              AdminStatusPill(
                label: accountingAccountTypeLabel(l10n, account.type),
                tone: accountingAccountTypeTone(account.type),
              ),
              Text(
                account.branchId ?? '—',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall,
              ),
              Text(
                adminFormatAmount(context, account.balance),
                textAlign: TextAlign.end,
                style: textTheme.bodyMedium,
              ),
            ], onTap: () => onOpen(account)),
        ],
      ),
    );
  }

  double _total(List<AccountingAccountEntity> accounts, AccountType type) =>
      accounts
          .where((account) => account.type == type)
          .fold<double>(0, (sum, account) => sum + account.balance);
}
