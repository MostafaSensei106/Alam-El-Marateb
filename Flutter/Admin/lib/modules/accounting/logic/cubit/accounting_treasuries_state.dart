import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/accounting_treasury_entity.dart';

part 'accounting_treasuries_state.freezed.dart';

@freezed
sealed class AccountingTreasuriesState with _$AccountingTreasuriesState {
  const factory AccountingTreasuriesState.initial() = _Initial;

  const factory AccountingTreasuriesState.loading() = _Loading;

  const factory AccountingTreasuriesState.success({
    required List<AccountingTreasuryEntity> items,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = _Success;

  const factory AccountingTreasuriesState.failure({required String message}) =
      _Failure;
}
