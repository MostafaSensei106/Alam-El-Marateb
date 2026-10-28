// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounting_expense_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseResponseData _$ExpenseResponseDataFromJson(Map<String, dynamic> json) =>
    ExpenseResponseData(
      category: json['category'] as String,
      amount: json['amount'] as num,
      createdAt: json['createdAt'] as String,
      id: json['id'] as String?,
      branchId: json['branchId'] as String?,
      receiptPhoto: json['receiptPhoto'] as String?,
      approvedBy: json['approvedBy'] as String?,
    );

Map<String, dynamic> _$ExpenseResponseDataToJson(
  ExpenseResponseData instance,
) => <String, dynamic>{
  'id': instance.id,
  'branchId': instance.branchId,
  'category': instance.category,
  'amount': instance.amount,
  'receiptPhoto': instance.receiptPhoto,
  'approvedBy': instance.approvedBy,
  'createdAt': instance.createdAt,
};

ExpenseRequestBody _$ExpenseRequestBodyFromJson(Map<String, dynamic> json) =>
    ExpenseRequestBody(
      category: json['category'] as String,
      amount: json['amount'] as num,
      branchId: json['branchId'] as String?,
      receiptPhoto: json['receiptPhoto'] as String?,
      approvedBy: json['approvedBy'] as String?,
    );

Map<String, dynamic> _$ExpenseRequestBodyToJson(ExpenseRequestBody instance) =>
    <String, dynamic>{
      'branchId': instance.branchId,
      'category': instance.category,
      'amount': instance.amount,
      'receiptPhoto': instance.receiptPhoto,
      'approvedBy': instance.approvedBy,
    };

UpdateExpenseRequestBody _$UpdateExpenseRequestBodyFromJson(
  Map<String, dynamic> json,
) => UpdateExpenseRequestBody(
  category: json['category'] as String?,
  amount: json['amount'] as num?,
  receiptPhoto: json['receiptPhoto'] as String?,
  approvedBy: json['approvedBy'] as String?,
);

Map<String, dynamic> _$UpdateExpenseRequestBodyToJson(
  UpdateExpenseRequestBody instance,
) => <String, dynamic>{
  'category': instance.category,
  'amount': instance.amount,
  'receiptPhoto': instance.receiptPhoto,
  'approvedBy': instance.approvedBy,
};
