import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/accounting_check_entity.dart';

part 'accounting_checks_state.freezed.dart';

@freezed
sealed class AccountingChecksState with _$AccountingChecksState {
  const factory AccountingChecksState.initial() = _Initial;

  const factory AccountingChecksState.loading() = _Loading;

  const factory AccountingChecksState.success({
    required List<AccountingCheckEntity> items,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = _Success;

  const factory AccountingChecksState.failure({required String message}) =
      _Failure;
}
