import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/accounting_ledger_line_entity.dart';

part 'accounting_ledger_state.freezed.dart';

@freezed
sealed class AccountingLedgerState with _$AccountingLedgerState {
  const factory AccountingLedgerState.initial() = AccountingLedgerInitial;

  const factory AccountingLedgerState.loading() = AccountingLedgerLoading;

  const factory AccountingLedgerState.success({
    required List<AccountingLedgerLineEntity> items,
  }) = AccountingLedgerSuccess;

  const factory AccountingLedgerState.failure({required String message}) = AccountingLedgerFailure;
}
