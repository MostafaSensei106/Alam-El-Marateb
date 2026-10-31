import 'package:freezed_annotation/freezed_annotation.dart';

import '../entity/accounting_balance_sheet_entity.dart';
import '../entity/accounting_profit_loss_entity.dart';
import '../entity/accounting_tax_report_entity.dart';

part 'accounting_reports_state.freezed.dart';

@freezed
sealed class AccountingReportsState with _$AccountingReportsState {
  const factory AccountingReportsState.initial() = AccountingReportsInitial;

  const factory AccountingReportsState.loading() = AccountingReportsLoading;

  const factory AccountingReportsState.success({
    required DateTime from,
    required DateTime to,
    required AccountingProfitLossEntity profitLoss,
    required AccountingBalanceSheetEntity balanceSheet,
    required AccountingTaxReportEntity taxReport,
  }) = AccountingReportsSuccess;

  const factory AccountingReportsState.failure({required String message}) = AccountingReportsFailure;
}
