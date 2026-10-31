import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/accounting_check_entity.dart';

part 'accounting_checks_state.freezed.dart';

@freezed
sealed class AccountingChecksState with _$AccountingChecksState {
  const factory AccountingChecksState.initial() = AccountingChecksInitial;

  const factory AccountingChecksState.loading() = AccountingChecksLoading;

  const factory AccountingChecksState.success({
    required List<AccountingCheckEntity> items,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = AccountingChecksSuccess;

  const factory AccountingChecksState.failure({required String message}) = AccountingChecksFailure;
}
