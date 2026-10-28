import 'package:json_annotation/json_annotation.dart';

import '../../logic/entity/accounting_account_entity.dart';
import '../../logic/entity/accounting_enums.dart';

part 'accounting_account_models.g.dart';

/// `AccountView`
@JsonSerializable()
final class AccountResponseData {
  const AccountResponseData({
    required this.code,
    required this.name,
    required this.type,
    required this.balance,
    this.parentCode,
    this.branchId,
  });

  factory AccountResponseData.fromJson(Map<String, dynamic> json) =>
      _$AccountResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$AccountResponseDataToJson(this);

  final String code;
  final String name;
  final String type;
  final String? parentCode;
  final String? branchId;
  final num balance;
}

extension AccountResponseDataX on AccountResponseData {
  AccountingAccountEntity toEntity() => AccountingAccountEntity(
    code: code,
    name: name,
    type: accountTypeFrom(type),
    balance: balance,
    parentCode: parentCode,
    branchId: branchId,
  );
}

/// `CreateAccountRequest`
@JsonSerializable()
final class CreateAccountRequestBody {
  const CreateAccountRequestBody({
    required this.code,
    required this.nameAr,
    required this.type,
    this.nameEn,
    this.parentCode,
    this.branchId,
  });

  Map<String, dynamic> toJson() => _$CreateAccountRequestBodyToJson(this);

  final String code;
  final String nameAr;
  final String? nameEn;
  final String type;
  final String? parentCode;
  final String? branchId;
}

/// `UpdateAccountRequest`
@JsonSerializable()
final class UpdateAccountRequestBody {
  const UpdateAccountRequestBody({
    this.nameAr,
    this.nameEn,
    this.type,
    this.parentCode,
  });

  Map<String, dynamic> toJson() => _$UpdateAccountRequestBodyToJson(this);

  final String? nameAr;
  final String? nameEn;
  final String? type;
  final String? parentCode;
}
