import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounting_balance_sheet_entity.freezed.dart';

/// `BalanceSheetView`
@freezed
sealed class AccountingBalanceSheetEntity with _$AccountingBalanceSheetEntity {
  const factory AccountingBalanceSheetEntity({
    required DateTime asOf,
    required num assets,
    required num liabilities,
    required num equity,
  }) = _AccountingBalanceSheetEntity;
  const AccountingBalanceSheetEntity._();

  num get liabilitiesAndEquity => liabilities + equity;

  bool get balanced => (assets - liabilitiesAndEquity).abs() < 0.01;
}
