import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/date/date_only.dart';
import '../../logic/entity/accounting_balance_sheet_entity.dart';
import '../../logic/entity/accounting_profit_loss_entity.dart';
import '../../logic/entity/accounting_tax_report_entity.dart';

part 'accounting_report_models.g.dart';

/// `ProfitLossView`
@JsonSerializable()
final class ProfitLossResponseData {
  const ProfitLossResponseData({
    required this.from,
    required this.to,
    required this.revenue,
    required this.cogs,
    required this.expenses,
    required this.netProfit,
    required this.vatPortion,
  });

  factory ProfitLossResponseData.fromJson(Map<String, dynamic> json) =>
      _$ProfitLossResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ProfitLossResponseDataToJson(this);

  final String from;
  final String to;
  final num revenue;
  final num cogs;
  final num expenses;
  final num netProfit;
  final num vatPortion;
}

extension ProfitLossResponseDataX on ProfitLossResponseData {
  AccountingProfitLossEntity toEntity() => AccountingProfitLossEntity(
    from: parseDateOr(from, DateTime.now()),
    to: parseDateOr(to, DateTime.now()),
    revenue: revenue,
    cogs: cogs,
    expenses: expenses,
    netProfit: netProfit,
    vatPortion: vatPortion,
  );
}

/// `TaxReportView`
@JsonSerializable()
final class TaxReportResponseData {
  const TaxReportResponseData({
    required this.from,
    required this.to,
    required this.revenueInclusive,
    required this.vatPortion,
    required this.purchasesInclusive,
    required this.inputVat,
    required this.netVatPayable,
  });

  factory TaxReportResponseData.fromJson(Map<String, dynamic> json) =>
      _$TaxReportResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$TaxReportResponseDataToJson(this);

  final String from;
  final String to;
  final num revenueInclusive;
  final num vatPortion;
  final num purchasesInclusive;
  final num inputVat;
  final num netVatPayable;
}

extension TaxReportResponseDataX on TaxReportResponseData {
  AccountingTaxReportEntity toEntity() => AccountingTaxReportEntity(
    from: parseDateOr(from, DateTime.now()),
    to: parseDateOr(to, DateTime.now()),
    revenueInclusive: revenueInclusive,
    vatPortion: vatPortion,
    purchasesInclusive: purchasesInclusive,
    inputVat: inputVat,
    netVatPayable: netVatPayable,
  );
}

/// `BalanceSheetView`
@JsonSerializable()
final class BalanceSheetResponseData {
  const BalanceSheetResponseData({
    required this.asOf,
    required this.assets,
    required this.liabilities,
    required this.equity,
  });

  factory BalanceSheetResponseData.fromJson(Map<String, dynamic> json) =>
      _$BalanceSheetResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceSheetResponseDataToJson(this);

  final String asOf;
  final num assets;
  final num liabilities;
  final num equity;
}

extension BalanceSheetResponseDataX on BalanceSheetResponseData {
  AccountingBalanceSheetEntity toEntity() => AccountingBalanceSheetEntity(
    asOf: parseDateOr(asOf, DateTime.now()),
    assets: assets,
    liabilities: liabilities,
    equity: equity,
  );
}
