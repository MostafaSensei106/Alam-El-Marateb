import 'package:freezed_annotation/freezed_annotation.dart';

part 'accounting_transfer_entity.freezed.dart';

/// `TransferView`
@freezed
sealed class AccountingTransferEntity with _$AccountingTransferEntity {
  const factory AccountingTransferEntity({
    required String id,
    required num amount,
    String? fromId,
    String? toId,
    DateTime? at,
    String? by,
  }) = _AccountingTransferEntity;
}
