import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/date/date_only.dart';
import '../../logic/entity/accounting_transfer_entity.dart';
import '../../logic/entity/accounting_treasury_entity.dart';

part 'accounting_treasury_models.g.dart';

/// `TreasuryView`
@JsonSerializable()
final class TreasuryResponseData {
  const TreasuryResponseData({
    required this.name,
    required this.balance,
    this.id,
    this.branchId,
  });

  factory TreasuryResponseData.fromJson(Map<String, dynamic> json) =>
      _$TreasuryResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$TreasuryResponseDataToJson(this);

  final String? id;
  final String? branchId;
  final String name;
  final num balance;
}

extension TreasuryResponseDataX on TreasuryResponseData {
  AccountingTreasuryEntity toEntity() => AccountingTreasuryEntity(
    id: id ?? '',
    branchId: branchId,
    name: name,
    balance: balance,
  );
}

/// `TransferView`
@JsonSerializable()
final class TransferResponseData {
  const TransferResponseData({
    required this.amount,
    this.id,
    this.fromId,
    this.toId,
    this.at,
    this.by,
  });

  factory TransferResponseData.fromJson(Map<String, dynamic> json) =>
      _$TransferResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$TransferResponseDataToJson(this);

  final String? id;
  final String? fromId;
  final String? toId;
  final num amount;
  final String? at;
  final String? by;
}

extension TransferResponseDataX on TransferResponseData {
  AccountingTransferEntity toEntity() => AccountingTransferEntity(
    id: id ?? '',
    fromId: fromId,
    toId: toId,
    amount: amount,
    at: parseDateTime(at),
    by: by,
  );
}

/// `CreateTreasuryRequest`
@JsonSerializable()
final class CreateTreasuryRequestBody {
  const CreateTreasuryRequestBody({
    required this.name,
    this.branchId,
    this.openingBalance,
  });

  Map<String, dynamic> toJson() => _$CreateTreasuryRequestBodyToJson(this);

  final String? branchId;
  final String name;
  final num? openingBalance;
}

/// `UpdateTreasuryRequest`
@JsonSerializable()
final class UpdateTreasuryRequestBody {
  const UpdateTreasuryRequestBody({this.name});

  Map<String, dynamic> toJson() => _$UpdateTreasuryRequestBodyToJson(this);

  final String? name;
}

/// `TransferRequest`
@JsonSerializable()
final class TransferRequestBody {
  const TransferRequestBody({
    required this.fromId,
    required this.toId,
    required this.amount,
  });

  Map<String, dynamic> toJson() => _$TransferRequestBodyToJson(this);

  final String fromId;
  final String toId;
  final num amount;
}
