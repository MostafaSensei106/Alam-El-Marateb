import 'package:bloc_signals/bloc_signals.dart';
import 'package:injectable/injectable.dart';

import '../entity/accounting_enums.dart';
import '../entity/accounting_expense_entity.dart';
import '../usecase/expense_usecases.dart';
import 'accounting_expenses_state.dart';

@injectable
final class AccountingExpensesCubit
    extends CubitSignal<AccountingExpensesState> {
  AccountingExpensesCubit({
    required this._getExpenses,
    required this._createExpense,
    required this._updateExpense,
  }) : super(initialState: const AccountingExpensesState.initial());

  final GetExpensesUsecase _getExpenses;
  final CreateExpenseUsecase _createExpense;
  final UpdateExpenseUsecase _updateExpense;

  String? _branchId;

  List<AccountingExpenseEntity> get items => switch (state.value) {
    Success(:final items) => items,
    _ => const [],
  };

  Future<void> load({String? branchId}) async {
    _branchId = branchId;
    emit(const AccountingExpensesState.loading());
    final result = await _getExpenses.call(
      GetExpensesParams(branchId: branchId),
    );
    result.when(
      success: (items) => emit(AccountingExpensesState.success(items: items)),
      failure: (error) =>
          emit(AccountingExpensesState.failure(message: error.message)),
    );
  }

  Future<bool> create({
    required ExpenseCategory category,
    required num amount,
    String? branchId,
    String? receiptPhoto,
    String? approvedBy,
  }) async {
    emit(AccountingExpensesState.success(items: items, isSaving: true));
    final result = await _createExpense.call(
      CreateExpenseParams(
        category: category,
        amount: amount,
        branchId: branchId ?? _branchId,
        receiptPhoto: receiptPhoto,
        approvedBy: approvedBy,
      ),
    );
    return result.when(
      success: (_) async {
        await _refresh();
        return true;
      },
      failure: (error) async {
        emit(
          AccountingExpensesState.success(
            items: items,
            errorMessage: error.message,
          ),
        );
        return false;
      },
    );
  }

  Future<bool> update({
    required String id,
    ExpenseCategory? category,
    num? amount,
    String? receiptPhoto,
    String? approvedBy,
  }) async {
    emit(AccountingExpensesState.success(items: items, isSaving: true));
    final result = await _updateExpense.call(
      UpdateExpenseParams(
        id: id,
        category: category,
        amount: amount,
        receiptPhoto: receiptPhoto,
        approvedBy: approvedBy,
      ),
    );
    return result.when(
      success: (_) async {
        await _refresh();
        return true;
      },
      failure: (error) async {
        emit(
          AccountingExpensesState.success(
            items: items,
            errorMessage: error.message,
          ),
        );
        return false;
      },
    );
  }

  Future<void> _refresh() async {
    final result = await _getExpenses.call(
      GetExpensesParams(branchId: _branchId),
    );
    result.when(
      success: (items) => emit(AccountingExpensesState.success(items: items)),
      failure: (error) => emit(
        AccountingExpensesState.success(
          items: items,
          errorMessage: error.message,
        ),
      ),
    );
  }
}
