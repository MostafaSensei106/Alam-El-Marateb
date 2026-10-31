import 'package:injectable/injectable.dart';

import '../../../../core/constants/types/type_def.dart';
import '../../../../core/networking/api_executor/api_executor.dart';
import '../../../../core/networking/api_service/api_service.dart';
import '../../../../core/utils/date/date_only.dart';
import '../../data/interface/accounting_reposiory.dart';
import '../../data/models/accounting_account_models.dart';
import '../../data/models/accounting_check_models.dart';
import '../../data/models/accounting_expense_models.dart';
import '../../data/models/accounting_journal_models.dart';
import '../../data/models/accounting_report_models.dart';
import '../../data/models/accounting_treasury_models.dart';
import '../entity/accounting_account_entity.dart';
import '../entity/accounting_balance_sheet_entity.dart';
import '../entity/accounting_check_entity.dart';
import '../entity/accounting_enums.dart';
import '../entity/accounting_expense_entity.dart';
import '../entity/accounting_journal_entry_entity.dart';
import '../entity/accounting_ledger_line_entity.dart';
import '../entity/accounting_profit_loss_entity.dart';
import '../entity/accounting_tax_report_entity.dart';
import '../entity/accounting_transfer_entity.dart';
import '../entity/accounting_treasury_entity.dart';

@LazySingleton(as: AccountingReposiory)
final class AccountingReposioryImpl implements AccountingReposiory {
  const AccountingReposioryImpl({required this._api});
  final ApiService _api;

  // ─────────────────────────── Chart of accounts ───────────────────────────

  @override
  Future<ApiResult<List<AccountingAccountEntity>>> getAccounts() =>
      ApiExecutor.executeMapped(
        action: _api.getAccounts,
        mapper: (dto) => dto.data.map((e) => e.toEntity()).toList(),
      );

  @override
  Future<ApiResult<AccountingAccountEntity>> getAccount({
    required String code,
  }) => ApiExecutor.executeMapped(
    action: () => _api.getAccount(code),
    mapper: (dto) => dto.data.toEntity(),
  );

  @override
  Future<ApiResult<AccountingAccountEntity>> createAccount({
    required String code,
    required String name,
    AccountType type = AccountType.asset,
    String? parentCode,
    String? branchId,
    String? nameEn,
  }) => ApiExecutor.executeMapped(
    action: () => _api.createAccount(
      CreateAccountRequestBody(
        code: code,
        nameAr: name,
        nameEn: nameEn,
        type: type.apiValue,
        parentCode: parentCode,
        branchId: branchId,
      ),
    ),
    mapper: (dto) => dto.data.toEntity(),
  );

  @override
  Future<ApiResult<AccountingAccountEntity>> updateAccount({
    required String code,
    String? name,
    String? nameEn,
    AccountType? type,
    String? parentCode,
  }) => ApiExecutor.executeMapped(
    action: () => _api.updateAccount(
      code,
      UpdateAccountRequestBody(
        nameAr: name,
        nameEn: nameEn,
        type: type?.apiValue,
        parentCode: parentCode,
      ),
    ),
    mapper: (dto) => dto.data.toEntity(),
  );

  // ────────────────────────────── Journal entries ──────────────────────────

  @override
  Future<ApiResult<List<AccountingJournalEntryEntity>>> getJournalEntries({
    String? branchId,
    DateTime? from,
    DateTime? to,
    JournalSource? source,
  }) => ApiExecutor.executeMapped(
    action: () => _api.getJournalEntries(
      branchId: branchId,
      from: from == null ? null : formatDateOnly(from),
      to: to == null ? null : formatDateOnly(to),
      source: source?.apiValue,
    ),
    mapper: (dto) => dto.data.map((e) => e.toEntity()).toList(),
  );

  @override
  Future<ApiResult<AccountingJournalEntryEntity>> getJournalEntry({
    required String id,
  }) => ApiExecutor.executeMapped(
    action: () => _api.getJournalEntry(id),
    mapper: (dto) => dto.data.toEntity(),
  );

  @override
  Future<ApiResult<AccountingJournalEntryEntity>> postJournalEntry({
    required DateTime entryDate,
    required List<AccountingJournalLineInput> lines,
    JournalSource source = JournalSource.manual,
    String? branchId,
    String? reference,
    String? memo,
  }) => ApiExecutor.executeMapped(
    action: () => _api.postJournalEntry(
      PostJournalRequestBody(
        branchId: branchId,
        entryDate: formatDateOnly(entryDate),
        source: source.apiValue,
        ref: reference,
        memo: memo,
        lines: lines.map(JournalLineRequestBody.fromEntity).toList(),
      ),
    ),
    mapper: (dto) => dto.data.toEntity(),
  );

  // ────────────────────────────── General ledger ───────────────────────────

  @override
  Future<ApiResult<List<AccountingLedgerLineEntity>>> getGeneralLedger({
    String? accountCode,
    DateTime? from,
    DateTime? to,
  }) => ApiExecutor.executeMapped(
    action: () => _api.getGeneralLedger(
      accountCode: accountCode,
      from: from == null ? null : formatDateOnly(from),
      to: to == null ? null : formatDateOnly(to),
    ),
    mapper: (dto) => dto.data.map((e) => e.toEntity()).toList(),
  );

  // ──────────────────────────────── Treasuries ─────────────────────────────

  @override
  Future<ApiResult<List<AccountingTreasuryEntity>>> getTreasuries({
    String? branchId,
  }) => ApiExecutor.executeMapped(
    action: () => _api.getTreasuries(branchId: branchId),
    mapper: (dto) => dto.data.map((e) => e.toEntity()).toList(),
  );

  @override
  Future<ApiResult<AccountingTreasuryEntity>> getTreasury({
    required String id,
  }) => ApiExecutor.executeMapped(
    action: () => _api.getTreasury(id),
    mapper: (dto) => dto.data.toEntity(),
  );

  @override
  Future<ApiResult<AccountingTreasuryEntity>> createTreasury({
    required String name,
    num? openingBalance,
    String? branchId,
  }) => ApiExecutor.executeMapped(
    action: () => _api.createTreasury(
      CreateTreasuryRequestBody(
        name: name,
        openingBalance: openingBalance,
        branchId: branchId,
      ),
    ),
    mapper: (dto) => dto.data.toEntity(),
  );

  @override
  Future<ApiResult<AccountingTreasuryEntity>> updateTreasury({
    required String id,
    String? name,
  }) => ApiExecutor.executeMapped(
    action: () =>
        _api.updateTreasury(id, UpdateTreasuryRequestBody(name: name)),
    mapper: (dto) => dto.data.toEntity(),
  );

  // ──────────────────────────── Treasury transfers ─────────────────────────

  @override
  Future<ApiResult<List<AccountingTransferEntity>>> getTransfers({
    String? treasuryId,
  }) => ApiExecutor.executeMapped(
    action: () => _api.getTransfers(treasuryId: treasuryId),
    mapper: (dto) => dto.data.map((e) => e.toEntity()).toList(),
  );

  @override
  Future<ApiResult<AccountingTransferEntity>> getTransfer({
    required String id,
  }) => ApiExecutor.executeMapped(
    action: () => _api.getTransfer(id),
    mapper: (dto) => dto.data.toEntity(),
  );

  @override
  Future<ApiResult<AccountingTransferEntity>> createTransfer({
    required String fromId,
    required String toId,
    required num amount,
  }) => ApiExecutor.executeMapped(
    action: () => _api.createTransfer(
      TransferRequestBody(fromId: fromId, toId: toId, amount: amount),
    ),
    mapper: (dto) => dto.data.toEntity(),
  );

  // ───────────────────────────────── Expenses ──────────────────────────────

  @override
  Future<ApiResult<List<AccountingExpenseEntity>>> getExpenses({
    String? branchId,
  }) => ApiExecutor.executeMapped(
    action: () => _api.getExpenses(branchId: branchId),
    mapper: (dto) => dto.data.map((e) => e.toEntity()).toList(),
  );

  @override
  Future<ApiResult<AccountingExpenseEntity>> getExpense({required String id}) =>
      ApiExecutor.executeMapped(
        action: () => _api.getExpense(id),
        mapper: (dto) => dto.data.toEntity(),
      );

  @override
  Future<ApiResult<AccountingExpenseEntity>> createExpense({
    required ExpenseCategory category,
    required num amount,
    String? branchId,
    String? receiptPhoto,
    String? approvedBy,
  }) => ApiExecutor.executeMapped(
    action: () => _api.createExpense(
      ExpenseRequestBody(
        category: category.apiValue,
        amount: amount,
        branchId: branchId,
        receiptPhoto: receiptPhoto,
        approvedBy: approvedBy,
      ),
    ),
    mapper: (dto) => dto.data.toEntity(),
  );

  @override
  Future<ApiResult<AccountingExpenseEntity>> updateExpense({
    required String id,
    ExpenseCategory? category,
    num? amount,
    String? receiptPhoto,
    String? approvedBy,
  }) => ApiExecutor.executeMapped(
    action: () => _api.updateExpense(
      id,
      UpdateExpenseRequestBody(
        category: category?.apiValue,
        amount: amount,
        receiptPhoto: receiptPhoto,
        approvedBy: approvedBy,
      ),
    ),
    mapper: (dto) => dto.data.toEntity(),
  );

  // ────────────────────────────────── Checks ───────────────────────────────

  @override
  Future<ApiResult<List<AccountingCheckEntity>>> getChecks({
    CheckStatus? status,
  }) => ApiExecutor.executeMapped(
    action: () => _api.getChecks(status: status?.apiValue),
    mapper: (dto) => dto.data.map((e) => e.toEntity()).toList(),
  );

  @override
  Future<ApiResult<AccountingCheckEntity>> getCheck({required String id}) =>
      ApiExecutor.executeMapped(
        action: () => _api.getCheck(id),
        mapper: (dto) => dto.data.toEntity(),
      );

  @override
  Future<ApiResult<AccountingCheckEntity>> createCheck({
    required CheckDirection direction,
    required num amount,
    DateTime? dueDate,
    String? party,
  }) => ApiExecutor.executeMapped(
    action: () => _api.createCheck(
      CheckRequestBody(
        direction: direction.apiValue,
        amount: amount,
        dueDate: dueDate == null ? null : formatDateOnly(dueDate),
        party: party,
      ),
    ),
    mapper: (dto) => dto.data.toEntity(),
  );

  @override
  Future<ApiResult<AccountingCheckEntity>> updateCheck({
    required String id,
    DateTime? dueDate,
    String? party,
  }) => ApiExecutor.executeMapped(
    action: () => _api.updateCheck(
      id,
      UpdateCheckRequestBody(
        dueDate: dueDate == null ? null : formatDateOnly(dueDate),
        party: party,
      ),
    ),
    mapper: (dto) => dto.data.toEntity(),
  );

  @override
  Future<ApiResult<AccountingCheckEntity>> updateCheckStatus({
    required String id,
    required CheckStatus status,
  }) => ApiExecutor.executeMapped(
    action: () => _api.updateCheckStatus(
      id,
      CheckStatusRequestBody(status: status.apiValue),
    ),
    mapper: (dto) => dto.data.toEntity(),
  );

  // ────────────────────────────────── Reports ──────────────────────────────

  @override
  Future<ApiResult<AccountingProfitLossEntity>> getProfitLoss({
    required DateTime from,
    required DateTime to,
  }) => ApiExecutor.executeMapped(
    action: () =>
        _api.getProfitLoss(from: formatDateOnly(from), to: formatDateOnly(to)),
    mapper: (dto) => dto.data.toEntity(),
  );

  @override
  Future<ApiResult<AccountingTaxReportEntity>> getTaxReport({
    required DateTime from,
    required DateTime to,
  }) => ApiExecutor.executeMapped(
    action: () =>
        _api.getTaxReport(from: formatDateOnly(from), to: formatDateOnly(to)),
    mapper: (dto) => dto.data.toEntity(),
  );

  @override
  Future<ApiResult<AccountingBalanceSheetEntity>> getBalanceSheet({
    required DateTime to,
  }) => ApiExecutor.executeMapped(
    action: () => _api.getBalanceSheet(formatDateOnly(to)),
    mapper: (dto) => dto.data.toEntity(),
  );
}
