import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/accounting_ledger_line_entity.dart';

part 'accounting_ledger_state.freezed.dart';

@freezed
sealed class AccountingLedgerState with _$AccountingLedgerState {
  const factory AccountingLedgerState.initial() = _Initial;

  const factory AccountingLedgerState.loading() = _Loading;

  const factory AccountingLedgerState.success({
    required List<AccountingLedgerLineEntity> items,
  }) = _Success;

  const factory AccountingLedgerState.failure({required String message}) =
      _Failure;
}
