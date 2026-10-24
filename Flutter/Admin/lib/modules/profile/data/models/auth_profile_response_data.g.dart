// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_profile_response_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthProfileResponseData _$AuthProfileResponseDataFromJson(
  Map<String, dynamic> json,
) => AuthProfileResponseData(
  id: json['id'] as String,
  fullName: json['fullName'] as String,
  phoneNumber: json['phoneNumber'] as String,
  email: json['email'] as String,
  branchId: json['branchId'] as String,
  roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
  active: json['active'] as bool,
);

Map<String, dynamic> _$AuthProfileResponseDataToJson(
  AuthProfileResponseData instance,
) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'phoneNumber': instance.phoneNumber,
  'email': instance.email,
  'branchId': instance.branchId,
  'roles': instance.roles,
  'active': instance.active,
};
