// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_sheet_response_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BalanceSheetResponseData _$BalanceSheetResponseDataFromJson(
  Map<String, dynamic> json,
) => BalanceSheetResponseData(
  asOf: json['asOf'] as String,
  assets: (json['assets'] as num).toInt(),
  liabilities: (json['liabilities'] as num).toInt(),
  equity: (json['equity'] as num).toInt(),
);

Map<String, dynamic> _$BalanceSheetResponseDataToJson(
  BalanceSheetResponseData instance,
) => <String, dynamic>{
  'asOf': instance.asOf,
  'assets': instance.assets,
  'liabilities': instance.liabilities,
  'equity': instance.equity,
};
