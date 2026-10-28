import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../modules/accounting/data/models/accounting_account_models.dart';
import '../../../modules/accounting/data/models/accounting_check_models.dart';
import '../../../modules/accounting/data/models/accounting_expense_models.dart';
import '../../../modules/accounting/data/models/accounting_journal_models.dart';
import '../../../modules/accounting/data/models/accounting_report_models.dart';
import '../../../modules/accounting/data/models/accounting_treasury_models.dart';
import '../../../modules/login/data/models/login_request_body.dart';
import '../../../modules/login/data/models/login_response_data.dart';
import '../../../modules/login/data/models/refresh_token_request_body.dart';
import '../../../modules/profile/data/models/auth_profile_response_data.dart';
import '../../constants/api_routes.dart';
import '../../constants/security_configs.dart';
import '../api_response_model/api_response_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiRoutes.apiBaseURL)
abstract class ApiService {
  /// Creates an instance of [ApiService] with the provided [Dio] client and optional [baseUrl].
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  /// Auth
  @POST(ApiRoutes.authLogin)
  @Extra({SecurityConfigs.requireToken: false})
  Future<ApiResponse<LoginResponseData>> login(@Body() LoginRequestBody body);

  @POST(ApiRoutes.authRefresh)
  @Extra({SecurityConfigs.requireToken: false})
  Future<ApiResponse<LoginResponseData>> refreshToken(
    @Body() RefreshTokenRequestBody body,
  );

  /// Profile
  @GET(ApiRoutes.authMe)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<AuthProfileResponseData>> authMe();

  /// Accounting · chart of accounts
  @GET(ApiRoutes.accountingChartOfAccounts)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<List<AccountResponseData>>> getAccounts();

  @POST(ApiRoutes.accountingAccountCreate)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<AccountResponseData>> createAccount(
    @Body() CreateAccountRequestBody body,
  );

  @GET(ApiRoutes.accountingAccountByCode)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<AccountResponseData>> getAccount(
    @Path('accountCode') String accountCode,
  );

  @PATCH(ApiRoutes.accountingAccountByCode)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<AccountResponseData>> updateAccount(
    @Path('accountCode') String accountCode,
    @Body() UpdateAccountRequestBody body,
  );

  /// Accounting · journal entries
  @GET(ApiRoutes.accountingJournalEntries)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<List<JournalResponseData>>> getJournalEntries({
    @Query('branchId') String? branchId,
    @Query('from') String? from,
    @Query('to') String? to,
    @Query('source') String? source,
  });

  @POST(ApiRoutes.accountingJournalEntryCreate)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<JournalResponseData>> postJournalEntry(
    @Body() PostJournalRequestBody body,
  );

  @GET(ApiRoutes.accountingJournalEntryById)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<JournalResponseData>> getJournalEntry(
    @Path('journalId') String journalId,
  );

  /// Accounting · general ledger
  @GET(ApiRoutes.accountingGeneralLedger)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<List<LedgerLineResponseData>>> getGeneralLedger({
    @Query('accountCode') String? accountCode,
    @Query('from') String? from,
    @Query('to') String? to,
  });

  /// Accounting · treasuries
  @GET(ApiRoutes.accountingTreasuries)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<List<TreasuryResponseData>>> getTreasuries({
    @Query('branchId') String? branchId,
  });

  @POST(ApiRoutes.accountingTreasuryCreate)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<TreasuryResponseData>> createTreasury(
    @Body() CreateTreasuryRequestBody body,
  );

  @GET(ApiRoutes.accountingTreasuryById)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<TreasuryResponseData>> getTreasury(
    @Path('treasuryId') String treasuryId,
  );

  @PATCH(ApiRoutes.accountingTreasuryById)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<TreasuryResponseData>> updateTreasury(
    @Path('treasuryId') String treasuryId,
    @Body() UpdateTreasuryRequestBody body,
  );

  /// Accounting · treasury transfers
  @GET(ApiRoutes.accountingTreasuryTransfer)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<List<TransferResponseData>>> getTransfers({
    @Query('treasuryId') String? treasuryId,
  });

  @POST(ApiRoutes.accountingTreasuryTransfer)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<TransferResponseData>> createTransfer(
    @Body() TransferRequestBody body,
  );

  @GET(ApiRoutes.accountingTreasuryTransferById)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<TransferResponseData>> getTransfer(
    @Path('transferId') String transferId,
  );

  /// Accounting · expenses
  @GET(ApiRoutes.accountingExpenses)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<List<ExpenseResponseData>>> getExpenses({
    @Query('branchId') String? branchId,
  });

  @POST(ApiRoutes.accountingExpenseCreate)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<ExpenseResponseData>> createExpense(
    @Body() ExpenseRequestBody body,
  );

  @GET(ApiRoutes.accountingExpenseById)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<ExpenseResponseData>> getExpense(
    @Path('expenseId') String expenseId,
  );

  @PATCH(ApiRoutes.accountingExpenseById)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<ExpenseResponseData>> updateExpense(
    @Path('expenseId') String expenseId,
    @Body() UpdateExpenseRequestBody body,
  );

  /// Accounting · checks
  @GET(ApiRoutes.accountingChecks)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<List<CheckResponseData>>> getChecks({
    @Query('status') String? status,
  });

  @POST(ApiRoutes.accountingCheckCreate)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<CheckResponseData>> createCheck(
    @Body() CheckRequestBody body,
  );

  @GET(ApiRoutes.accountingCheckById)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<CheckResponseData>> getCheck(
    @Path('checkId') String checkId,
  );

  @PATCH(ApiRoutes.accountingCheckById)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<CheckResponseData>> updateCheck(
    @Path('checkId') String checkId,
    @Body() UpdateCheckRequestBody body,
  );

  @POST(ApiRoutes.accountingCheckStatus)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<CheckResponseData>> updateCheckStatus(
    @Path('checkId') String checkId,
    @Body() CheckStatusRequestBody body,
  );

  /// Accounting · reports
  @GET(ApiRoutes.accountingProfitLoss)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<ProfitLossResponseData>> getProfitLoss({
    @Query('from') String? from,
    @Query('to') String? to,
  });

  @GET(ApiRoutes.accountingTaxReport)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<TaxReportResponseData>> getTaxReport({
    @Query('from') String? from,
    @Query('to') String? to,
  });

  @GET(ApiRoutes.accountingBalanceSheet)
  @Extra({SecurityConfigs.requireToken: true})
  Future<ApiResponse<BalanceSheetResponseData>> getBalanceSheet(
    @Query('to') String to,
  );
}
