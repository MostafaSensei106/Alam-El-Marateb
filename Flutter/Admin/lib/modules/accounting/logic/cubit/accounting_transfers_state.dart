import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/accounting_transfer_entity.dart';

part 'accounting_transfers_state.freezed.dart';

@freezed
sealed class AccountingTransfersState with _$AccountingTransfersState {
  const factory AccountingTransfersState.initial() = AccountingTransfersInitial;

  const factory AccountingTransfersState.loading() = AccountingTransfersLoading;

  const factory AccountingTransfersState.success({
    required List<AccountingTransferEntity> items,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = AccountingTransfersSuccess;

  const factory AccountingTransfersState.failure({required String message}) = AccountingTransfersFailure;
}
