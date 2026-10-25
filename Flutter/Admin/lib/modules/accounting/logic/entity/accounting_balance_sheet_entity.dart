import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounting_balance_sheet_entity.freezed.dart';

@freezed
sealed class AccountingBalanceSheetEntity with _$AccountingBalanceSheetEntity {
  const factory AccountingBalanceSheetEntity({
    required String asOf,
    required num assets,
    required num liabilities,
    required num equity,
  }) = _AccountingBalanceSheetEntity;

  factory AccountingBalanceSheetEntity.placeholder() =>
      const AccountingBalanceSheetEntity(
        asOf: '2024-01-01',
        assets: 100000,
        liabilities: 40000,
        equity: 60000,
      );
}
