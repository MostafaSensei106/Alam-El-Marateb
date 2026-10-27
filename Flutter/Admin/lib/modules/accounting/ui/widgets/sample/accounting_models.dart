/// Sample models that mirror the accounting API payloads.
///
/// Field names follow the backend DTOs (`AccountView`, `JournalView`,
/// `TreasuryView`, …) so the columns and detail rows line up with what the
/// endpoints actually return. Display names and running balances are
/// sample-only additions the screens need to render a realistic table.
library;

/// `AccountView.type`
enum AccountType { asset, liability, equity, revenue, expense }

/// `JournalView.source`
///
/// The backend keeps this as a free string; the sample data only uses the
/// sources the rest of the admin actually posts (`MANUAL` in Postman).
enum JournalSource { manual, sales, purchasing, expense, transfer }

/// `ExpenseView.category`
enum ExpenseCategory {
  rent,
  salaries,
  utilities,
  marketing,
  maintenance,
  transport,
  supplies,
}

/// `CheckView.direction`
enum CheckDirection { incoming, outgoing }

/// `CheckView.status`
enum CheckStatus { held, cashed, bounced, returned }

/// One row of the chart of accounts.
final class AccountRow {
  const AccountRow({
    required this.code,
    required this.name,
    required this.type,
    required this.balance,
    this.parentCode,
    this.branchId,
  });

  /// `AccountView.code`
  final String code;

  /// `AccountView.name`
  final String name;

  /// `AccountView.type`
  final AccountType type;

  /// Sample balance used by the list, detail and report screens.
  final double balance;

  /// `AccountView.parentCode`
  final String? parentCode;

  /// `AccountView.branchId`
  final String? branchId;

  bool get isRoot => parentCode == null;
}

/// `JournalLineView`
final class JournalLine {
  const JournalLine({
    required this.accountCode,
    required this.accountName,
    required this.debit,
    required this.credit,
  });

  final String accountCode;
  final String accountName;
  final double debit;
  final double credit;
}

/// `JournalView`
final class JournalRow {
  const JournalRow({
    required this.id,
    required this.entryDate,
    required this.source,
    required this.lines,
    this.branchId,
    this.reference,
    this.memo,
  });

  final String id;
  final DateTime entryDate;
  final JournalSource source;
  final List<JournalLine> lines;
  final String? branchId;
  final String? reference;
  final String? memo;

  /// `JournalView.totalDebit`
  double get totalDebit =>
      lines.fold<double>(0, (sum, line) => sum + line.debit);

  /// `JournalView.totalCredit`
  double get totalCredit =>
      lines.fold<double>(0, (sum, line) => sum + line.credit);

  bool get balanced => (totalDebit - totalCredit).abs() < 0.01;
}

/// `LedgerLineView` plus the running balance the ledger screen shows.
final class LedgerRow {
  const LedgerRow({
    required this.entryId,
    required this.entryDate,
    required this.source,
    required this.accountCode,
    required this.accountName,
    required this.debit,
    required this.credit,
    required this.runningBalance,
    this.reference,
  });

  final String entryId;
  final DateTime entryDate;
  final JournalSource source;
  final String accountCode;
  final String accountName;
  final double debit;
  final double credit;
  final double runningBalance;
  final String? reference;
}

/// `TreasuryView`
final class TreasuryRow {
  const TreasuryRow({
    required this.id,
    required this.name,
    required this.balance,
    this.branchId,
  });

  final String id;
  final String name;
  final double balance;
  final String? branchId;
}

/// `TransferView`
final class TransferRow {
  const TransferRow({
    required this.id,
    required this.fromId,
    required this.toId,
    required this.amount,
    required this.at,
    required this.by,
  });

  final String id;
  final String fromId;
  final String toId;
  final double amount;
  final DateTime at;
  final String by;
}

/// `ExpenseView`
final class ExpenseRow {
  const ExpenseRow({
    required this.id,
    required this.category,
    required this.amount,
    this.branchId,
    this.approvedBy,
    this.receiptPhoto,
  });

  final String id;
  final ExpenseCategory category;
  final double amount;
  final String? branchId;

  /// `ExpenseView.approvedBy` — `null` means the expense is still waiting.
  final String? approvedBy;

  /// `ExpenseView.receiptPhoto`
  final String? receiptPhoto;

  bool get approved => approvedBy != null;
  bool get hasReceipt => receiptPhoto != null;
}

/// `CheckView`
final class CheckRow {
  const CheckRow({
    required this.id,
    required this.direction,
    required this.amount,
    required this.status,
    this.dueDate,
    this.party,
  });

  final String id;
  final CheckDirection direction;
  final double amount;
  final CheckStatus status;
  final DateTime? dueDate;
  final String? party;
}

/// `ProfitLossView`
final class ProfitLossReport {
  const ProfitLossReport({
    required this.from,
    required this.to,
    required this.revenue,
    required this.cogs,
    required this.expenses,
    required this.vatPortion,
  });

  final DateTime from;
  final DateTime to;
  final double revenue;
  final double cogs;
  final double expenses;
  final double vatPortion;

  double get grossProfit => revenue - cogs;

  /// `ProfitLossView.netProfit`
  double get netProfit => grossProfit - expenses;
}

/// `BalanceSheetView`
final class BalanceSheetReport {
  const BalanceSheetReport({
    required this.asOf,
    required this.assets,
    required this.liabilities,
    required this.equity,
  });

  final DateTime asOf;
  final double assets;
  final double liabilities;
  final double equity;

  double get liabilitiesAndEquity => liabilities + equity;

  bool get balanced => (assets - liabilitiesAndEquity).abs() < 0.01;
}

/// `TaxReportView`
final class TaxReport {
  const TaxReport({
    required this.from,
    required this.to,
    required this.revenueInclusive,
    required this.vatPortion,
  });

  final DateTime from;
  final DateTime to;
  final double revenueInclusive;
  final double vatPortion;
}
