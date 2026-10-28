import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounting_treasury_entity.freezed.dart';

/// `TreasuryView`
@freezed
sealed class AccountingTreasuryEntity with _$AccountingTreasuryEntity {
  const factory AccountingTreasuryEntity({
    required String id,
    required String name,
    required num balance,
    String? branchId,
  }) = _AccountingTreasuryEntity;
}
