import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/result/result.dart';
import '../../../../core/utils/use_case/use_case_base.dart';
import '../../data/interface/accounting_reposiory.dart';
import '../entity/accounting_ledger_line_entity.dart';

// ────────────────────────────── General ledger ───────────────────────────

final class GetGeneralLedgerParams {
  const GetGeneralLedgerParams({this.accountCode, this.from, this.to});

  final String? accountCode;
  final DateTime? from;
  final DateTime? to;
}

@injectable
final class GetGeneralLedgerUsecase
    implements
        UseCaseBase<
          List<AccountingLedgerLineEntity>,
          GetGeneralLedgerParams
        > {
  const GetGeneralLedgerUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<List<AccountingLedgerLineEntity>, Failures>> call(
    GetGeneralLedgerParams params,
  ) => _repo.getGeneralLedger(
    accountCode: params.accountCode,
    from: params.from,
    to: params.to,
  );
}
