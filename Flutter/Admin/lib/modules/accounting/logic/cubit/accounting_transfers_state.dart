import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/accounting_transfer_entity.dart';

part 'accounting_transfers_state.freezed.dart';

@freezed
sealed class AccountingTransfersState with _$AccountingTransfersState {
  const factory AccountingTransfersState.initial() = _Initial;

  const factory AccountingTransfersState.loading() = _Loading;

  const factory AccountingTransfersState.success({
    required List<AccountingTransferEntity> items,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = _Success;

  const factory AccountingTransfersState.failure({required String message}) =
      _Failure;
}
