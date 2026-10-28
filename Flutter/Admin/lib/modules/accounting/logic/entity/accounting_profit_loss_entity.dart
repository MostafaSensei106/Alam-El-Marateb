import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounting_profit_loss_entity.freezed.dart';

/// `ProfitLossView`
@freezed
sealed class AccountingProfitLossEntity with _$AccountingProfitLossEntity {
  const factory AccountingProfitLossEntity({
    required DateTime from,
    required DateTime to,
    required num revenue,
    required num cogs,
    required num expenses,
    required num netProfit,
    required num vatPortion,
  }) = _AccountingProfitLossEntity;
  const AccountingProfitLossEntity._();

  num get grossProfit => revenue - cogs;
}
