import 'package:bloc_signals/bloc_signals.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/result/result.dart';
import '../usecase/report_usecases.dart';
import 'accounting_reports_state.dart';

@injectable
final class AccountingReportsCubit extends CubitSignal<AccountingReportsState> {
  AccountingReportsCubit({
    required this._getProfitLoss,
    required this._getTaxReport,
    required this._getBalanceSheet,
  }) : super(initialState: const AccountingReportsState.initial());

  final GetProfitLossUsecase _getProfitLoss;
  final GetTaxReportUsecase _getTaxReport;
  final GetBalanceSheetUsecase _getBalanceSheet;

  Future<void> load({required DateTime from, required DateTime to}) async {
    emit(const AccountingReportsState.loading());

    final profitLoss = await _getProfitLoss.call(
      GetProfitLossParams(from: from, to: to),
    );
    if (profitLoss case Failure(:final error)) {
      emit(AccountingReportsState.failure(message: error.message));
      return;
    }

    final taxReport = await _getTaxReport.call(
      GetTaxReportParams(from: from, to: to),
    );
    if (taxReport case Failure(:final error)) {
      emit(AccountingReportsState.failure(message: error.message));
      return;
    }

    final balanceSheet = await _getBalanceSheet.call(
      GetBalanceSheetParams(to: to),
    );
    if (balanceSheet case Failure(:final error)) {
      emit(AccountingReportsState.failure(message: error.message));
      return;
    }

    emit(
      AccountingReportsState.success(
        from: from,
        to: to,
        profitLoss: profitLoss.getOrThrow(),
        taxReport: taxReport.getOrThrow(),
        balanceSheet: balanceSheet.getOrThrow(),
      ),
    );
  }
}
