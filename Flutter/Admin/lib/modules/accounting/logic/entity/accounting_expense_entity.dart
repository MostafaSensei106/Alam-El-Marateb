import 'package:freezed_annotation/freezed_annotation.dart';

import 'accounting_enums.dart';

part 'accounting_expense_entity.freezed.dart';

/// `ExpenseView`
@freezed
sealed class AccountingExpenseEntity with _$AccountingExpenseEntity {
  const factory AccountingExpenseEntity({
    required String id,
    required ExpenseCategory category,
    required num amount,
    required DateTime createdAt,
    String? branchId,
    String? approvedBy,
    String? receiptPhoto,
  }) = _AccountingExpenseEntity;
  const AccountingExpenseEntity._();

  bool get approved => approvedBy != null;
  bool get hasReceipt => receiptPhoto != null;
}
