import '../../../../core/constants/types/type_def.dart';
import '../../logic/entity/accounting_account_entity.dart';
import '../../logic/entity/accounting_balance_sheet_entity.dart';
import '../../logic/entity/accounting_check_entity.dart';
import '../../logic/entity/accounting_enums.dart';
import '../../logic/entity/accounting_expense_entity.dart';
import '../../logic/entity/accounting_journal_entry_entity.dart';
import '../../logic/entity/accounting_ledger_line_entity.dart';
import '../../logic/entity/accounting_profit_loss_entity.dart';
import '../../logic/entity/accounting_tax_report_entity.dart';
import '../../logic/entity/accounting_transfer_entity.dart';
import '../../logic/entity/accounting_treasury_entity.dart';

/// The single repository the accounting module talks to.
///
/// Every method returns an [ApiResult] already mapped to a domain entity so the
/// use-case layer never sees a transport DTO. Dates are passed as [DateTime] and
/// formatted here, in the data layer.
abstract interface class AccountingReposiory {
  // ─────────────────────────── Chart of accounts ───────────────────────────

  Future<ApiResult<List<AccountingAccountEntity>>> getAccounts();

  Future<ApiResult<AccountingAccountEntity>> getAccount({
    required String code,
  });

  Future<ApiResult<AccountingAccountEntity>> createAccount({
    required String code,
    required String name,
    AccountType type = AccountType.asset,
    String? parentCode,
    String? branchId,
    String? nameEn,
  });

  Future<ApiResult<AccountingAccountEntity>> updateAccount({
    required String code,
    String? name,
    String? nameEn,
    AccountType? type,
    String? parentCode,
  });

  // ────────────────────────────── Journal entries ──────────────────────────

  Future<ApiResult<List<AccountingJournalEntryEntity>>> getJournalEntries({
    String? branchId,
    DateTime? from,
    DateTime? to,
    JournalSource? source,
  });

  Future<ApiResult<AccountingJournalEntryEntity>> getJournalEntry({
    required String id,
  });

  Future<ApiResult<AccountingJournalEntryEntity>> postJournalEntry({
    required DateTime entryDate,
    required List<AccountingJournalLineInput> lines,
    JournalSource source = JournalSource.manual,
    String? branchId,
    String? reference,
    String? memo,
  });

  // ────────────────────────────── General ledger ───────────────────────────

  Future<ApiResult<List<AccountingLedgerLineEntity>>> getGeneralLedger({
    String? accountCode,
    DateTime? from,
    DateTime? to,
  });

  // ──────────────────────────────── Treasuries ─────────────────────────────

  Future<ApiResult<List<AccountingTreasuryEntity>>> getTreasuries({
    String? branchId,
  });

  Future<ApiResult<AccountingTreasuryEntity>> getTreasury({
    required String id,
  });

  Future<ApiResult<AccountingTreasuryEntity>> createTreasury({
    required String name,
    num? openingBalance,
    String? branchId,
  });

  Future<ApiResult<AccountingTreasuryEntity>> updateTreasury({
    required String id,
    String? name,
  });

  // ──────────────────────────── Treasury transfers ─────────────────────────

  Future<ApiResult<List<AccountingTransferEntity>>> getTransfers({
    String? treasuryId,
  });

  Future<ApiResult<AccountingTransferEntity>> getTransfer({
    required String id,
  });

  Future<ApiResult<AccountingTransferEntity>> createTransfer({
    required String fromId,
    required String toId,
    required num amount,
  });

  // ───────────────────────────────── Expenses ──────────────────────────────

  Future<ApiResult<List<AccountingExpenseEntity>>> getExpenses({
    String? branchId,
  });

  Future<ApiResult<AccountingExpenseEntity>> getExpense({required String id});

  Future<ApiResult<AccountingExpenseEntity>> createExpense({
    required ExpenseCategory category,
    required num amount,
    String? branchId,
    String? receiptPhoto,
    String? approvedBy,
  });

  Future<ApiResult<AccountingExpenseEntity>> updateExpense({
    required String id,
    ExpenseCategory? category,
    num? amount,
    String? receiptPhoto,
    String? approvedBy,
  });

  // ────────────────────────────────── Checks ───────────────────────────────

  Future<ApiResult<List<AccountingCheckEntity>>> getChecks({
    CheckStatus? status,
  });

  Future<ApiResult<AccountingCheckEntity>> getCheck({required String id});

  Future<ApiResult<AccountingCheckEntity>> createCheck({
    required CheckDirection direction,
    required num amount,
    DateTime? dueDate,
    String? party,
  });

  Future<ApiResult<AccountingCheckEntity>> updateCheck({
    required String id,
    DateTime? dueDate,
    String? party,
  });

  Future<ApiResult<AccountingCheckEntity>> updateCheckStatus({
    required String id,
    required CheckStatus status,
  });

  // ────────────────────────────────── Reports ──────────────────────────────

  Future<ApiResult<AccountingProfitLossEntity>> getProfitLoss({
    required DateTime from,
    required DateTime to,
  });

  Future<ApiResult<AccountingTaxReportEntity>> getTaxReport({
    required DateTime from,
    required DateTime to,
  });

  Future<ApiResult<AccountingBalanceSheetEntity>> getBalanceSheet({
    required DateTime to,
  });
}
