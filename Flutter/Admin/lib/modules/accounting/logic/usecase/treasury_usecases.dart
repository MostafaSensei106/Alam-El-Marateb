import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/result/result.dart';
import '../../../../core/utils/use_case/use_case_base.dart';
import '../../data/interface/accounting_reposiory.dart';
import '../entity/accounting_treasury_entity.dart';

// ──────────────────────────────── Treasuries ─────────────────────────────

final class GetTreasuriesParams {
  const GetTreasuriesParams({this.branchId});

  final String? branchId;
}

@injectable
final class GetTreasuriesUsecase
    implements
        UseCaseBase<List<AccountingTreasuryEntity>, GetTreasuriesParams> {
  const GetTreasuriesUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<List<AccountingTreasuryEntity>, Failures>> call(
    GetTreasuriesParams params,
  ) => _repo.getTreasuries(branchId: params.branchId);
}

@injectable
final class GetTreasuryUsecase
    implements UseCaseBase<AccountingTreasuryEntity, String> {
  const GetTreasuryUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingTreasuryEntity, Failures>> call(String params) =>
      _repo.getTreasury(id: params);
}

final class CreateTreasuryParams {
  const CreateTreasuryParams({
    required this.name,
    this.openingBalance,
    this.branchId,
  });

  final String name;
  final num? openingBalance;
  final String? branchId;
}

@injectable
final class CreateTreasuryUsecase
    implements
        UseCaseBase<AccountingTreasuryEntity, CreateTreasuryParams> {
  const CreateTreasuryUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingTreasuryEntity, Failures>> call(
    CreateTreasuryParams params,
  ) => _repo.createTreasury(
    name: params.name,
    openingBalance: params.openingBalance,
    branchId: params.branchId,
  );
}

final class UpdateTreasuryParams {
  const UpdateTreasuryParams({required this.id, this.name});

  final String id;
  final String? name;
}

@injectable
final class UpdateTreasuryUsecase
    implements
        UseCaseBase<AccountingTreasuryEntity, UpdateTreasuryParams> {
  const UpdateTreasuryUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingTreasuryEntity, Failures>> call(
    UpdateTreasuryParams params,
  ) => _repo.updateTreasury(id: params.id, name: params.name);
}
