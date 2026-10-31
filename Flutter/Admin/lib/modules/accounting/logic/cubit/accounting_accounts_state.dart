import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/accounting_account_entity.dart';

part 'accounting_accounts_state.freezed.dart';

@freezed
sealed class AccountingAccountsState with _$AccountingAccountsState {
  const factory AccountingAccountsState.initial() = AccountingAccountsInitial;

  const factory AccountingAccountsState.loading() = AccountingAccountsLoading;

  const factory AccountingAccountsState.success({
    required List<AccountingAccountEntity> items,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = AccountingAccountsSuccess;

  const factory AccountingAccountsState.failure({required String message}) = AccountingAccountsFailure;
}
