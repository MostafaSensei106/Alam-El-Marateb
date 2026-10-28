import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/utils/result/result.dart';
import '../../../../core/utils/use_case/use_case_base.dart';
import '../../data/interface/accounting_reposiory.dart';
import '../entity/accounting_balance_sheet_entity.dart';
import '../entity/accounting_profit_loss_entity.dart';
import '../entity/accounting_tax_report_entity.dart';

// ────────────────────────────────── Reports ──────────────────────────────

final class GetProfitLossParams {
  const GetProfitLossParams({required this.from, required this.to});

  final DateTime from;
  final DateTime to;
}

@injectable
final class GetProfitLossUsecase
    implements
        UseCaseBase<AccountingProfitLossEntity, GetProfitLossParams> {
  const GetProfitLossUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingProfitLossEntity, Failures>> call(
    GetProfitLossParams params,
  ) => _repo.getProfitLoss(from: params.from, to: params.to);
}

final class GetTaxReportParams {
  const GetTaxReportParams({required this.from, required this.to});

  final DateTime from;
  final DateTime to;
}

@injectable
final class GetTaxReportUsecase
    implements
        UseCaseBase<AccountingTaxReportEntity, GetTaxReportParams> {
  const GetTaxReportUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingTaxReportEntity, Failures>> call(
    GetTaxReportParams params,
  ) => _repo.getTaxReport(from: params.from, to: params.to);
}

final class GetBalanceSheetParams {
  const GetBalanceSheetParams({required this.to});

  final DateTime to;
}

@injectable
final class GetBalanceSheetUsecase
    implements
        UseCaseBase<AccountingBalanceSheetEntity, GetBalanceSheetParams> {
  const GetBalanceSheetUsecase({required this._repo});

  final AccountingReposiory _repo;

  @override
  Future<Result<AccountingBalanceSheetEntity, Failures>> call(
    GetBalanceSheetParams params,
  ) => _repo.getBalanceSheet(to: params.to);
}
