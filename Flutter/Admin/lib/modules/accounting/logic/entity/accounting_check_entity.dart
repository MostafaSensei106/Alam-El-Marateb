import 'package:freezed_annotation/freezed_annotation.dart';

import 'accounting_enums.dart';

part 'accounting_check_entity.freezed.dart';

/// `CheckView`
@freezed
sealed class AccountingCheckEntity with _$AccountingCheckEntity {
  const factory AccountingCheckEntity({
    required String id,
    required CheckDirection direction,
    required num amount,
    required CheckStatus status,
    required DateTime createdAt,
    DateTime? dueDate,
    String? party,
  }) = _AccountingCheckEntity;
}
