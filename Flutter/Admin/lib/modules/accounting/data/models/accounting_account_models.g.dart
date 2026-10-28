// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounting_account_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountResponseData _$AccountResponseDataFromJson(Map<String, dynamic> json) =>
    AccountResponseData(
      code: json['code'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      balance: json['balance'] as num,
      parentCode: json['parentCode'] as String?,
      branchId: json['branchId'] as String?,
    );

Map<String, dynamic> _$AccountResponseDataToJson(
  AccountResponseData instance,
) => <String, dynamic>{
  'code': instance.code,
  'name': instance.name,
  'type': instance.type,
  'parentCode': instance.parentCode,
  'branchId': instance.branchId,
  'balance': instance.balance,
};

CreateAccountRequestBody _$CreateAccountRequestBodyFromJson(
  Map<String, dynamic> json,
) => CreateAccountRequestBody(
  code: json['code'] as String,
  nameAr: json['nameAr'] as String,
  type: json['type'] as String,
  nameEn: json['nameEn'] as String?,
  parentCode: json['parentCode'] as String?,
  branchId: json['branchId'] as String?,
);

Map<String, dynamic> _$CreateAccountRequestBodyToJson(
  CreateAccountRequestBody instance,
) => <String, dynamic>{
  'code': instance.code,
  'nameAr': instance.nameAr,
  'nameEn': instance.nameEn,
  'type': instance.type,
  'parentCode': instance.parentCode,
  'branchId': instance.branchId,
};

UpdateAccountRequestBody _$UpdateAccountRequestBodyFromJson(
  Map<String, dynamic> json,
) => UpdateAccountRequestBody(
  nameAr: json['nameAr'] as String?,
  nameEn: json['nameEn'] as String?,
  type: json['type'] as String?,
  parentCode: json['parentCode'] as String?,
);

Map<String, dynamic> _$UpdateAccountRequestBodyToJson(
  UpdateAccountRequestBody instance,
) => <String, dynamic>{
  'nameAr': instance.nameAr,
  'nameEn': instance.nameEn,
  'type': instance.type,
  'parentCode': instance.parentCode,
};
