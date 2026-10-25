import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/result/result.dart';
import '../../../../core/utils/use_case/use_case_base.dart';
import '../../data/interface/accounting_reposiory.dart';
import '../entity/accounting_balance_sheet_entity.dart';

@injectable
final class GetAccountingBalanceSheetUsecase
    implements UseCaseBase<AccountingBalanceSheetEntity, String> {
  const GetAccountingBalanceSheetUsecase({required this._repo});

  final AccountingReposiory _repo;
  @override
  Future<Result<AccountingBalanceSheetEntity, Failures>> call(String params) =>
      _repo.getAccountBalanceSheet(to: params);
}
