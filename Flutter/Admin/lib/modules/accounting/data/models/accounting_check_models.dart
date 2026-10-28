import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/date/date_only.dart';
import '../../logic/entity/accounting_check_entity.dart';
import '../../logic/entity/accounting_enums.dart';

part 'accounting_check_models.g.dart';

/// `CheckView`
@JsonSerializable()
final class CheckResponseData {
  const CheckResponseData({
    required this.direction,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.id,
    this.dueDate,
    this.party,
  });

  factory CheckResponseData.fromJson(Map<String, dynamic> json) =>
      _$CheckResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$CheckResponseDataToJson(this);

  final String? id;
  final String direction;
  final num amount;
  final String? dueDate;
  final String status;
  final String? party;
  final String createdAt;
}

extension CheckResponseDataX on CheckResponseData {
  AccountingCheckEntity toEntity() => AccountingCheckEntity(
    id: id ?? '',
    direction: checkDirectionFrom(direction),
    amount: amount,
    dueDate: parseDateTime(dueDate),
    status: checkStatusFrom(status),
    party: party,
    createdAt: parseDateOr(createdAt, DateTime.now()),
  );
}

/// `CheckRequest`
@JsonSerializable()
final class CheckRequestBody {
  const CheckRequestBody({
    required this.direction,
    required this.amount,
    this.dueDate,
    this.party,
  });

  Map<String, dynamic> toJson() => _$CheckRequestBodyToJson(this);

  final String direction;
  final num amount;
  final String? dueDate;
  final String? party;
}

/// `UpdateCheckRequest`
@JsonSerializable()
final class UpdateCheckRequestBody {
  const UpdateCheckRequestBody({this.dueDate, this.party});

  Map<String, dynamic> toJson() => _$UpdateCheckRequestBodyToJson(this);

  final String? dueDate;
  final String? party;
}

/// `CheckStatusRequest`
@JsonSerializable()
final class CheckStatusRequestBody {
  const CheckStatusRequestBody({required this.status});

  Map<String, dynamic> toJson() => _$CheckStatusRequestBodyToJson(this);

  final String status;
}
