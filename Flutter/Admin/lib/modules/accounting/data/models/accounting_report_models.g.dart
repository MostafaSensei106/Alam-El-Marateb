// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounting_report_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfitLossResponseData _$ProfitLossResponseDataFromJson(
  Map<String, dynamic> json,
) => ProfitLossResponseData(
  from: json['from'] as String,
  to: json['to'] as String,
  revenue: json['revenue'] as num,
  cogs: json['cogs'] as num,
  expenses: json['expenses'] as num,
  netProfit: json['netProfit'] as num,
  vatPortion: json['vatPortion'] as num,
);

Map<String, dynamic> _$ProfitLossResponseDataToJson(
  ProfitLossResponseData instance,
) => <String, dynamic>{
  'from': instance.from,
  'to': instance.to,
  'revenue': instance.revenue,
  'cogs': instance.cogs,
  'expenses': instance.expenses,
  'netProfit': instance.netProfit,
  'vatPortion': instance.vatPortion,
};

TaxReportResponseData _$TaxReportResponseDataFromJson(
  Map<String, dynamic> json,
) => TaxReportResponseData(
  from: json['from'] as String,
  to: json['to'] as String,
  revenueInclusive: json['revenueInclusive'] as num,
  vatPortion: json['vatPortion'] as num,
  purchasesInclusive: json['purchasesInclusive'] as num,
  inputVat: json['inputVat'] as num,
  netVatPayable: json['netVatPayable'] as num,
);

Map<String, dynamic> _$TaxReportResponseDataToJson(
  TaxReportResponseData instance,
) => <String, dynamic>{
  'from': instance.from,
  'to': instance.to,
  'revenueInclusive': instance.revenueInclusive,
  'vatPortion': instance.vatPortion,
  'purchasesInclusive': instance.purchasesInclusive,
  'inputVat': instance.inputVat,
  'netVatPayable': instance.netVatPayable,
};

BalanceSheetResponseData _$BalanceSheetResponseDataFromJson(
  Map<String, dynamic> json,
) => BalanceSheetResponseData(
  asOf: json['asOf'] as String,
  assets: json['assets'] as num,
  liabilities: json['liabilities'] as num,
  equity: json['equity'] as num,
);

Map<String, dynamic> _$BalanceSheetResponseDataToJson(
  BalanceSheetResponseData instance,
) => <String, dynamic>{
  'asOf': instance.asOf,
  'assets': instance.assets,
  'liabilities': instance.liabilities,
  'equity': instance.equity,
};
