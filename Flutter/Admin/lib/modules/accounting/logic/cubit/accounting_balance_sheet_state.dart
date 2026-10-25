import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/accounting_balance_sheet_entity.dart';

part 'accounting_balance_sheet_state.freezed.dart';

@freezed
sealed class AccountingBalanceSheetState with _$AccountingBalanceSheetState {
  const factory AccountingBalanceSheetState.initial() = _Initial;
  const factory AccountingBalanceSheetState.loading() = _Loading;
  const factory AccountingBalanceSheetState.success({
    required AccountingBalanceSheetEntity data,
  }) = Success;
  const factory AccountingBalanceSheetState.failure({required String message}) =
      Failure;
}
