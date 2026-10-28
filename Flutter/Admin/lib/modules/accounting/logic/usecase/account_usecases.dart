import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/result/result.dart';
import '../../../../core/utils/use_case/use_case_base.dart';
import '../../data/interface/accounting_reposiory.dart';
import '../entity/accounting_account_entity.dart';
import '../entity/accounting_enums.dart';

// ─────────────────────────── Chart of accounts ───────────────────────────

@injectable
final class GetAccountsUsecase
    implements UseCaseBase<List<AccountingAccountEntity>, NoParams> {
  const GetAccountsUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<List<AccountingAccountEntity>, Failures>> call(
    NoParams params,
  ) => _repo.getAccounts();
}

@injectable
final class GetAccountUsecase
    implements UseCaseBase<AccountingAccountEntity, String> {
  const GetAccountUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingAccountEntity, Failures>> call(String params) =>
      _repo.getAccount(code: params);
}

final class CreateAccountParams {
  const CreateAccountParams({
    required this.code,
    required this.name,
    this.type = AccountType.asset,
    this.parentCode,
    this.branchId,
    this.nameEn,
  });

  final String code;
  final String name;
  final AccountType type;
  final String? parentCode;
  final String? branchId;
  final String? nameEn;
}

@injectable
final class CreateAccountUsecase
    implements UseCaseBase<AccountingAccountEntity, CreateAccountParams> {
  const CreateAccountUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingAccountEntity, Failures>> call(
    CreateAccountParams params,
  ) => _repo.createAccount(
    code: params.code,
    name: params.name,
    type: params.type,
    parentCode: params.parentCode,
    branchId: params.branchId,
    nameEn: params.nameEn,
  );
}

final class UpdateAccountParams {
  const UpdateAccountParams({
    required this.code,
    this.name,
    this.nameEn,
    this.type,
    this.parentCode,
  });

  final String code;
  final String? name;
  final String? nameEn;
  final AccountType? type;
  final String? parentCode;
}

@injectable
final class UpdateAccountUsecase
    implements UseCaseBase<AccountingAccountEntity, UpdateAccountParams> {
  const UpdateAccountUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingAccountEntity, Failures>> call(
    UpdateAccountParams params,
  ) => _repo.updateAccount(
    code: params.code,
    name: params.name,
    nameEn: params.nameEn,
    type: params.type,
    parentCode: params.parentCode,
  );
}
