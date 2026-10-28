// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounting_treasury_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TreasuryResponseData _$TreasuryResponseDataFromJson(
  Map<String, dynamic> json,
) => TreasuryResponseData(
  name: json['name'] as String,
  balance: json['balance'] as num,
  id: json['id'] as String?,
  branchId: json['branchId'] as String?,
);

Map<String, dynamic> _$TreasuryResponseDataToJson(
  TreasuryResponseData instance,
) => <String, dynamic>{
  'id': instance.id,
  'branchId': instance.branchId,
  'name': instance.name,
  'balance': instance.balance,
};

TransferResponseData _$TransferResponseDataFromJson(
  Map<String, dynamic> json,
) => TransferResponseData(
  amount: json['amount'] as num,
  id: json['id'] as String?,
  fromId: json['fromId'] as String?,
  toId: json['toId'] as String?,
  at: json['at'] as String?,
  by: json['by'] as String?,
);

Map<String, dynamic> _$TransferResponseDataToJson(
  TransferResponseData instance,
) => <String, dynamic>{
  'id': instance.id,
  'fromId': instance.fromId,
  'toId': instance.toId,
  'amount': instance.amount,
  'at': instance.at,
  'by': instance.by,
};

CreateTreasuryRequestBody _$CreateTreasuryRequestBodyFromJson(
  Map<String, dynamic> json,
) => CreateTreasuryRequestBody(
  name: json['name'] as String,
  branchId: json['branchId'] as String?,
  openingBalance: json['openingBalance'] as num?,
);

Map<String, dynamic> _$CreateTreasuryRequestBodyToJson(
  CreateTreasuryRequestBody instance,
) => <String, dynamic>{
  'branchId': instance.branchId,
  'name': instance.name,
  'openingBalance': instance.openingBalance,
};

UpdateTreasuryRequestBody _$UpdateTreasuryRequestBodyFromJson(
  Map<String, dynamic> json,
) => UpdateTreasuryRequestBody(name: json['name'] as String?);

Map<String, dynamic> _$UpdateTreasuryRequestBodyToJson(
  UpdateTreasuryRequestBody instance,
) => <String, dynamic>{'name': instance.name};

TransferRequestBody _$TransferRequestBodyFromJson(Map<String, dynamic> json) =>
    TransferRequestBody(
      fromId: json['fromId'] as String,
      toId: json['toId'] as String,
      amount: json['amount'] as num,
    );

Map<String, dynamic> _$TransferRequestBodyToJson(
  TransferRequestBody instance,
) => <String, dynamic>{
  'fromId': instance.fromId,
  'toId': instance.toId,
  'amount': instance.amount,
};
