/// Cross-cutting accounting enums shared by the response models, entities,
/// use-cases and UI.
///
/// The backend keeps most of these values as free strings, so every enum has a
/// tolerant parser that never throws: unknown values fall back to [other].
library;

/// `AccountView.type`
enum AccountType { asset, liability, equity, revenue, expense, other }

/// `JournalView.source`
enum JournalSource { manual, sales, purchasing, expense, transfer, other }

/// `ExpenseView.category`
enum ExpenseCategory {
  rent,
  salaries,
  utilities,
  marketing,
  maintenance,
  transport,
  supplies,
  other,
}

/// `CheckView.direction`
enum CheckDirection { incoming, outgoing }

/// `CheckView.status`
enum CheckStatus { held, cashed, bounced, returned, other }

extension AccountTypeX on AccountType {
  /// API token used by `CreateAccountRequest.type`.
  String get apiValue => switch (this) {
    AccountType.asset => 'ASSET',
    AccountType.liability => 'LIABILITY',
    AccountType.equity => 'EQUITY',
    AccountType.revenue => 'REVENUE',
    AccountType.expense => 'EXPENSE',
    AccountType.other => 'ASSET',
  };

  /// Credit-normal accounts grow on the credit side.
  bool get isCreditNormal => switch (this) {
    AccountType.liability || AccountType.equity || AccountType.revenue => true,
    _ => false,
  };
}

extension CheckDirectionX on CheckDirection {
  /// API token used by `CheckRequest.direction`.
  String get apiValue => this == CheckDirection.incoming ? 'in' : 'out';
}

extension CheckStatusX on CheckStatus {
  /// API token accepted by `CheckStatusRequest.status` and `GET /checks?status`.
  String get apiValue => switch (this) {
    CheckStatus.held => 'held',
    CheckStatus.cashed => 'cashed',
    CheckStatus.bounced => 'bounced',
    CheckStatus.returned => 'returned',
    CheckStatus.other => 'held',
  };

  bool get isTerminal => this == CheckStatus.cashed || this == CheckStatus.bounced;
}

extension JournalSourceX on JournalSource {
  /// API token stored in `JournalView.source` and accepted by
  /// `PostJournalRequest.source` / `GET /journal-entries?source`.
  String get apiValue => switch (this) {
    JournalSource.manual => 'manual',
    JournalSource.sales => 'sales',
    JournalSource.purchasing => 'purchasing',
    JournalSource.expense => 'expense',
    JournalSource.transfer => 'transfer',
    JournalSource.other => 'manual',
  };
}

extension ExpenseCategoryX on ExpenseCategory {
  /// API token stored in `ExpenseView.category` (the backend keeps it as a free
  /// string, so the app owns the canonical spelling).
  String get apiValue => switch (this) {
    ExpenseCategory.rent => 'rent',
    ExpenseCategory.salaries => 'salaries',
    ExpenseCategory.utilities => 'utilities',
    ExpenseCategory.marketing => 'marketing',
    ExpenseCategory.maintenance => 'maintenance',
    ExpenseCategory.transport => 'transport',
    ExpenseCategory.supplies => 'supplies',
    ExpenseCategory.other => 'other',
  };
}

AccountType accountTypeFrom(String? raw) {
  return switch (raw?.trim().toUpperCase()) {
    'ASSET' => AccountType.asset,
    'LIABILITY' => AccountType.liability,
    'EQUITY' => AccountType.equity,
    'REVENUE' => AccountType.revenue,
    'EXPENSE' => AccountType.expense,
    _ => AccountType.other,
  };
}

JournalSource journalSourceFrom(String? raw) {
  return switch (raw?.trim().toUpperCase()) {
    'MANUAL' => JournalSource.manual,
    'SALES' => JournalSource.sales,
    'PURCHASING' || 'PURCHASE' => JournalSource.purchasing,
    'EXPENSE' => JournalSource.expense,
    'TRANSFER' => JournalSource.transfer,
    _ => JournalSource.other,
  };
}

ExpenseCategory expenseCategoryFrom(String? raw) {
  return switch (raw?.trim().toUpperCase()) {
    'RENT' => ExpenseCategory.rent,
    'SALARIES' || 'SALARY' => ExpenseCategory.salaries,
    'UTILITIES' => ExpenseCategory.utilities,
    'MARKETING' => ExpenseCategory.marketing,
    'MAINTENANCE' => ExpenseCategory.maintenance,
    'TRANSPORT' => ExpenseCategory.transport,
    'SUPPLIES' => ExpenseCategory.supplies,
    _ => ExpenseCategory.other,
  };
}

CheckDirection checkDirectionFrom(String? raw) {
  return switch (raw?.trim().toLowerCase()) {
    'out' || 'outgoing' => CheckDirection.outgoing,
    _ => CheckDirection.incoming,
  };
}

CheckStatus checkStatusFrom(String? raw) {
  return switch (raw?.trim().toUpperCase()) {
    'HELD' => CheckStatus.held,
    'CASHED' => CheckStatus.cashed,
    'BOUNCED' => CheckStatus.bounced,
    'RETURNED' => CheckStatus.returned,
    _ => CheckStatus.other,
  };
}
