import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/result/result.dart';
import '../../../../core/utils/use_case/use_case_base.dart';
import '../../data/interface/accounting_reposiory.dart';
import '../entity/accounting_enums.dart';
import '../entity/accounting_expense_entity.dart';

// ───────────────────────────────── Expenses ──────────────────────────────

final class GetExpensesParams {
  const GetExpensesParams({this.branchId});

  final String? branchId;
}

@injectable
final class GetExpensesUsecase
    implements UseCaseBase<List<AccountingExpenseEntity>, GetExpensesParams> {
  const GetExpensesUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<List<AccountingExpenseEntity>, Failures>> call(
    GetExpensesParams params,
  ) => _repo.getExpenses(branchId: params.branchId);
}

@injectable
final class GetExpenseUsecase
    implements UseCaseBase<AccountingExpenseEntity, String> {
  const GetExpenseUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingExpenseEntity, Failures>> call(String params) =>
      _repo.getExpense(id: params);
}

final class CreateExpenseParams {
  const CreateExpenseParams({
    required this.category,
    required this.amount,
    this.branchId,
    this.receiptPhoto,
    this.approvedBy,
  });

  final ExpenseCategory category;
  final num amount;
  final String? branchId;
  final String? receiptPhoto;
  final String? approvedBy;
}

@injectable
final class CreateExpenseUsecase
    implements UseCaseBase<AccountingExpenseEntity, CreateExpenseParams> {
  const CreateExpenseUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingExpenseEntity, Failures>> call(
    CreateExpenseParams params,
  ) => _repo.createExpense(
    category: params.category,
    amount: params.amount,
    branchId: params.branchId,
    receiptPhoto: params.receiptPhoto,
    approvedBy: params.approvedBy,
  );
}

final class UpdateExpenseParams {
  const UpdateExpenseParams({
    required this.id,
    this.category,
    this.amount,
    this.receiptPhoto,
    this.approvedBy,
  });

  final String id;
  final ExpenseCategory? category;
  final num? amount;
  final String? receiptPhoto;
  final String? approvedBy;
}

@injectable
final class UpdateExpenseUsecase
    implements UseCaseBase<AccountingExpenseEntity, UpdateExpenseParams> {
  const UpdateExpenseUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingExpenseEntity, Failures>> call(
    UpdateExpenseParams params,
  ) => _repo.updateExpense(
    id: params.id,
    category: params.category,
    amount: params.amount,
    receiptPhoto: params.receiptPhoto,
    approvedBy: params.approvedBy,
  );
}
