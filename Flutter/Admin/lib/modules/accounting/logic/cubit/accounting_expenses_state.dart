import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/accounting_expense_entity.dart';

part 'accounting_expenses_state.freezed.dart';

@freezed
sealed class AccountingExpensesState with _$AccountingExpensesState {
  const factory AccountingExpensesState.initial() = AccountingExpensesInitial;

  const factory AccountingExpensesState.loading() = AccountingExpensesLoading;

  const factory AccountingExpensesState.success({
    required List<AccountingExpenseEntity> items,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = AccountingExpensesSuccess;

  const factory AccountingExpensesState.failure({required String message}) = AccountingExpensesFailure;
}
