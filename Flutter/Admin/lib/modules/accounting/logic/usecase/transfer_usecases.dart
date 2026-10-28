import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/result/result.dart';
import '../../../../core/utils/use_case/use_case_base.dart';
import '../../data/interface/accounting_reposiory.dart';
import '../entity/accounting_transfer_entity.dart';

// ──────────────────────────── Treasury transfers ─────────────────────────

final class GetTransfersParams {
  const GetTransfersParams({this.treasuryId});

  final String? treasuryId;
}

@injectable
final class GetTransfersUsecase
    implements
        UseCaseBase<List<AccountingTransferEntity>, GetTransfersParams> {
  const GetTransfersUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<List<AccountingTransferEntity>, Failures>> call(
    GetTransfersParams params,
  ) => _repo.getTransfers(treasuryId: params.treasuryId);
}

@injectable
final class GetTransferUsecase
    implements UseCaseBase<AccountingTransferEntity, String> {
  const GetTransferUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingTransferEntity, Failures>> call(String params) =>
      _repo.getTransfer(id: params);
}

final class CreateTransferParams {
  const CreateTransferParams({
    required this.fromId,
    required this.toId,
    required this.amount,
  });

  final String fromId;
  final String toId;
  final num amount;
}

@injectable
final class CreateTransferUsecase
    implements
        UseCaseBase<AccountingTransferEntity, CreateTransferParams> {
  const CreateTransferUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingTransferEntity, Failures>> call(
    CreateTransferParams params,
  ) => _repo.createTransfer(
    fromId: params.fromId,
    toId: params.toId,
    amount: params.amount,
  );
}
