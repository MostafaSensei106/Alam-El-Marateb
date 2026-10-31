import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/accounting_treasury_entity.dart';

part 'accounting_treasuries_state.freezed.dart';

@freezed
sealed class AccountingTreasuriesState with _$AccountingTreasuriesState {
  const factory AccountingTreasuriesState.initial() = AccountingTreasuriesInitial;

  const factory AccountingTreasuriesState.loading() = AccountingTreasuriesLoading;

  const factory AccountingTreasuriesState.success({
    required List<AccountingTreasuryEntity> items,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = AccountingTreasuriesSuccess;

  const factory AccountingTreasuriesState.failure({required String message}) = AccountingTreasuriesFailure;
}
