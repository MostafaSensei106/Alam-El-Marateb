import 'package:freezed_annotation/freezed_annotation.dart';

import 'accounting_enums.dart';

part 'accounting_account_entity.freezed.dart';

/// `AccountView`
@freezed
sealed class AccountingAccountEntity with _$AccountingAccountEntity {
  const factory AccountingAccountEntity({
    required String code,
    required String name,
    required AccountType type,
    required num balance,
    String? parentCode,
    String? branchId,
  }) = _AccountingAccountEntity;
  const AccountingAccountEntity._();

  bool get isRoot => parentCode == null;
}
