import 'package:json_annotation/json_annotation.dart';

import '../../../../core/utils/date/date_only.dart';
import '../../logic/entity/accounting_enums.dart';
import '../../logic/entity/accounting_expense_entity.dart';

part 'accounting_expense_models.g.dart';

/// `ExpenseView`
@JsonSerializable()
final class ExpenseResponseData {
  const ExpenseResponseData({
    required this.category,
    required this.amount,
    required this.createdAt,
    this.id,
    this.branchId,
    this.receiptPhoto,
    this.approvedBy,
  });

  factory ExpenseResponseData.fromJson(Map<String, dynamic> json) =>
      _$ExpenseResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseResponseDataToJson(this);

  final String? id;
  final String? branchId;
  final String category;
  final num amount;
  final String? receiptPhoto;
  final String? approvedBy;
  final String createdAt;
}

extension ExpenseResponseDataX on ExpenseResponseData {
  AccountingExpenseEntity toEntity() => AccountingExpenseEntity(
    id: id ?? '',
    branchId: branchId,
    category: expenseCategoryFrom(category),
    amount: amount,
    receiptPhoto: receiptPhoto,
    approvedBy: approvedBy,
    createdAt: parseDateOr(createdAt, DateTime.now()),
  );
}

/// `ExpenseRequest`
@JsonSerializable()
final class ExpenseRequestBody {
  const ExpenseRequestBody({
    required this.category,
    required this.amount,
    this.branchId,
    this.receiptPhoto,
    this.approvedBy,
  });

  Map<String, dynamic> toJson() => _$ExpenseRequestBodyToJson(this);

  final String? branchId;
  final String category;
  final num amount;
  final String? receiptPhoto;
  final String? approvedBy;
}

/// `UpdateExpenseRequest`
@JsonSerializable()
final class UpdateExpenseRequestBody {
  const UpdateExpenseRequestBody({
    this.category,
    this.amount,
    this.receiptPhoto,
    this.approvedBy,
  });

  Map<String, dynamic> toJson() => _$UpdateExpenseRequestBodyToJson(this);

  final String? category;
  final num? amount;
  final String? receiptPhoto;
  final String? approvedBy;
}
