// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounting_check_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckResponseData _$CheckResponseDataFromJson(Map<String, dynamic> json) =>
    CheckResponseData(
      direction: json['direction'] as String,
      amount: json['amount'] as num,
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
      id: json['id'] as String?,
      dueDate: json['dueDate'] as String?,
      party: json['party'] as String?,
    );

Map<String, dynamic> _$CheckResponseDataToJson(CheckResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'direction': instance.direction,
      'amount': instance.amount,
      'dueDate': instance.dueDate,
      'status': instance.status,
      'party': instance.party,
      'createdAt': instance.createdAt,
    };

CheckRequestBody _$CheckRequestBodyFromJson(Map<String, dynamic> json) =>
    CheckRequestBody(
      direction: json['direction'] as String,
      amount: json['amount'] as num,
      dueDate: json['dueDate'] as String?,
      party: json['party'] as String?,
    );

Map<String, dynamic> _$CheckRequestBodyToJson(CheckRequestBody instance) =>
    <String, dynamic>{
      'direction': instance.direction,
      'amount': instance.amount,
      'dueDate': instance.dueDate,
      'party': instance.party,
    };

UpdateCheckRequestBody _$UpdateCheckRequestBodyFromJson(
  Map<String, dynamic> json,
) => UpdateCheckRequestBody(
  dueDate: json['dueDate'] as String?,
  party: json['party'] as String?,
);

Map<String, dynamic> _$UpdateCheckRequestBodyToJson(
  UpdateCheckRequestBody instance,
) => <String, dynamic>{'dueDate': instance.dueDate, 'party': instance.party};

CheckStatusRequestBody _$CheckStatusRequestBodyFromJson(
  Map<String, dynamic> json,
) => CheckStatusRequestBody(status: json['status'] as String);

Map<String, dynamic> _$CheckStatusRequestBodyToJson(
  CheckStatusRequestBody instance,
) => <String, dynamic>{'status': instance.status};
