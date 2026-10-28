import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/result/result.dart';
import '../../../../core/utils/use_case/use_case_base.dart';
import '../../data/interface/accounting_reposiory.dart';
import '../entity/accounting_check_entity.dart';
import '../entity/accounting_enums.dart';

// ────────────────────────────────── Checks ───────────────────────────────

final class GetChecksParams {
  const GetChecksParams({this.status});

  final CheckStatus? status;
}

@injectable
final class GetChecksUsecase
    implements UseCaseBase<List<AccountingCheckEntity>, GetChecksParams> {
  const GetChecksUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<List<AccountingCheckEntity>, Failures>> call(
    GetChecksParams params,
  ) => _repo.getChecks(status: params.status);
}

@injectable
final class GetCheckUsecase
    implements UseCaseBase<AccountingCheckEntity, String> {
  const GetCheckUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingCheckEntity, Failures>> call(String params) =>
      _repo.getCheck(id: params);
}

final class CreateCheckParams {
  const CreateCheckParams({
    required this.direction,
    required this.amount,
    this.dueDate,
    this.party,
  });

  final CheckDirection direction;
  final num amount;
  final DateTime? dueDate;
  final String? party;
}

@injectable
final class CreateCheckUsecase
    implements UseCaseBase<AccountingCheckEntity, CreateCheckParams> {
  const CreateCheckUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingCheckEntity, Failures>> call(
    CreateCheckParams params,
  ) => _repo.createCheck(
    direction: params.direction,
    amount: params.amount,
    dueDate: params.dueDate,
    party: params.party,
  );
}

final class UpdateCheckParams {
  const UpdateCheckParams({required this.id, this.dueDate, this.party});

  final String id;
  final DateTime? dueDate;
  final String? party;
}

@injectable
final class UpdateCheckUsecase
    implements UseCaseBase<AccountingCheckEntity, UpdateCheckParams> {
  const UpdateCheckUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingCheckEntity, Failures>> call(
    UpdateCheckParams params,
  ) => _repo.updateCheck(
    id: params.id,
    dueDate: params.dueDate,
    party: params.party,
  );
}

final class UpdateCheckStatusParams {
  const UpdateCheckStatusParams({required this.id, required this.status});

  final String id;
  final CheckStatus status;
}

@injectable
final class UpdateCheckStatusUsecase
    implements UseCaseBase<AccountingCheckEntity, UpdateCheckStatusParams> {
  const UpdateCheckStatusUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingCheckEntity, Failures>> call(
    UpdateCheckStatusParams params,
  ) => _repo.updateCheckStatus(id: params.id, status: params.status);
}
