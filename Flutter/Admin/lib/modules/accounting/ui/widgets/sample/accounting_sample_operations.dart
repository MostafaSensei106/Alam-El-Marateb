/// Sample treasuries, transfers, expenses, checks and report figures.
///
/// The numbers stay consistent with `accounting_sample_data.dart`: the cash
/// treasury closes at 61,100, the expense total matches the income statement
/// and the balance sheet balances exactly.
library;

import '../../../../../l10n/app_localizations.dart';
import 'accounting_models.dart';
import 'accounting_sample_data.dart';

/// `TreasuryView.name` for the seeded treasury ids.
String accountingTreasuryName(AppLocalizations l10n, String id) =>
    switch (id) {
      'tr-main' => l10n.accountingTreasuryMain,
      'tr-tanta' => l10n.accountingTreasuryTanta,
      'tr-cairo' => l10n.accountingTreasuryCairo,
      'tr-bank' => l10n.accountingTreasuryBank,
      _ => id,
    };

/// Four treasuries holding 750,850 EGP in total.
List<TreasuryRow> accountingTreasuries(AppLocalizations l10n) => [
  TreasuryRow(
    id: 'tr-main',
    name: l10n.accountingTreasuryMain,
    balance: 125000,
  ),
  TreasuryRow(
    id: 'tr-tanta',
    name: l10n.accountingTreasuryTanta,
    balance: 61100,
    branchId: 'br-tanta',
  ),
  TreasuryRow(
    id: 'tr-cairo',
    name: l10n.accountingTreasuryCairo,
    balance: 84750,
    branchId: 'br-cairo',
  ),
  TreasuryRow(
    id: 'tr-bank',
    name: l10n.accountingTreasuryBank,
    balance: 480000,
  ),
];

/// Five transfers moving 95,250 EGP between the treasuries.
List<TransferRow> accountingTransfers(AppLocalizations l10n) => [
  TransferRow(
    id: 'TR-0038',
    fromId: 'tr-bank',
    toId: 'tr-main',
    amount: 25000,
    at: DateTime(2026, 10, 5),
    by: l10n.sampleEmployee1,
  ),
  TransferRow(
    id: 'TR-0039',
    fromId: 'tr-main',
    toId: 'tr-tanta',
    amount: 18750,
    at: DateTime(2026, 10, 8),
    by: l10n.sampleEmployee2,
  ),
  TransferRow(
    id: 'TR-0040',
    fromId: 'tr-cairo',
    toId: 'tr-main',
    amount: 12400,
    at: DateTime(2026, 10, 12),
    by: l10n.sampleEmployee3,
  ),
  TransferRow(
    id: 'TR-0041',
    fromId: 'tr-bank',
    toId: 'tr-main',
    amount: 15000,
    at: DateTime(2026, 10, 17),
    by: l10n.sampleEmployee1,
  ),
  TransferRow(
    id: 'TR-0042',
    fromId: 'tr-main',
    toId: 'tr-cairo',
    amount: 24100,
    at: DateTime(2026, 10, 20),
    by: l10n.sampleEmployee4,
  ),
];

/// Eight disbursements totalling 436,500 EGP; two await approval.
List<ExpenseRow> accountingExpenses(AppLocalizations l10n) => [
  ExpenseRow(
    id: 'EXP-0911',
    category: ExpenseCategory.rent,
    amount: 24000,
    branchId: 'br-cairo',
    approvedBy: l10n.sampleEmployee2,
    receiptPhoto: 'exp-0911.jpg',
  ),
  ExpenseRow(
    id: 'EXP-0912',
    category: ExpenseCategory.salaries,
    amount: 96000,
    approvedBy: l10n.sampleEmployee1,
    receiptPhoto: 'exp-0912.jpg',
  ),
  ExpenseRow(
    id: 'EXP-0913',
    category: ExpenseCategory.utilities,
    amount: 40500,
    branchId: 'br-tanta',
    approvedBy: l10n.sampleEmployee3,
    receiptPhoto: 'exp-0913.jpg',
  ),
  ExpenseRow(
    id: 'EXP-0914',
    category: ExpenseCategory.marketing,
    amount: 60000,
    approvedBy: l10n.sampleEmployee1,
  ),
  const ExpenseRow(
    id: 'EXP-0915',
    category: ExpenseCategory.maintenance,
    amount: 38000,
    branchId: 'br-tanta',
  ),
  ExpenseRow(
    id: 'EXP-0916',
    category: ExpenseCategory.transport,
    amount: 52000,
    branchId: 'br-cairo',
    approvedBy: l10n.sampleEmployee2,
    receiptPhoto: 'exp-0916.jpg',
  ),
  const ExpenseRow(
    id: 'EXP-0917',
    category: ExpenseCategory.supplies,
    amount: 76000,
  ),
  ExpenseRow(
    id: 'EXP-0918',
    category: ExpenseCategory.rent,
    amount: 50000,
    approvedBy: l10n.sampleEmployee4,
    receiptPhoto: 'exp-0918.jpg',
  ),
];

/// Eight checks: 214,300 received and 184,150 issued.
List<CheckRow> accountingChecks(AppLocalizations l10n) => [
  CheckRow(
    id: 'CHQ-2034',
    direction: CheckDirection.incoming,
    amount: 62400,
    status: CheckStatus.held,
    dueDate: DateTime(2026, 10, 30),
    party: l10n.sampleCustomer1,
  ),
  CheckRow(
    id: 'CHQ-2035',
    direction: CheckDirection.incoming,
    amount: 48700,
    status: CheckStatus.cashed,
    dueDate: DateTime(2026, 10, 12),
    party: l10n.sampleCustomer2,
  ),
  CheckRow(
    id: 'CHQ-2036',
    direction: CheckDirection.outgoing,
    amount: 75300,
    status: CheckStatus.held,
    dueDate: DateTime(2026, 11, 5),
    party: l10n.supplierDeltaFoam,
  ),
  CheckRow(
    id: 'CHQ-2037',
    direction: CheckDirection.outgoing,
    amount: 34200,
    status: CheckStatus.cashed,
    dueDate: DateTime(2026, 10, 8),
    party: l10n.supplierSleepTech,
  ),
  CheckRow(
    id: 'CHQ-2038',
    direction: CheckDirection.incoming,
    amount: 51900,
    status: CheckStatus.held,
    dueDate: DateTime(2026, 10, 24),
    party: l10n.sampleCustomer3,
  ),
  CheckRow(
    id: 'CHQ-2039',
    direction: CheckDirection.outgoing,
    amount: 44650,
    status: CheckStatus.bounced,
    dueDate: DateTime(2026, 10, 15),
    party: l10n.supplierDeltaFoam,
  ),
  CheckRow(
    id: 'CHQ-2040',
    direction: CheckDirection.outgoing,
    amount: 30000,
    status: CheckStatus.returned,
    dueDate: DateTime(2026, 10, 18),
    party: l10n.supplierSleepTech,
  ),
  CheckRow(
    id: 'CHQ-2041',
    direction: CheckDirection.incoming,
    amount: 51300,
    status: CheckStatus.held,
    dueDate: DateTime(2026, 11, 2),
    party: l10n.sampleCustomer4,
  ),
];

/// `ProfitLossView` for October 2026; net profit lands on 223,500.
ProfitLossReport accountingProfitLoss() => ProfitLossReport(
  from: accountingPeriodStart,
  to: accountingReferenceDate,
  revenue: 1840000,
  cogs: 1180000,
  expenses: 436500,
  vatPortion: 226000,
);

/// `BalanceSheetView` as of the reference date.
BalanceSheetReport accountingBalanceSheet() => BalanceSheetReport(
  asOf: accountingReferenceDate,
  assets: 1031500,
  liabilities: 190750,
  equity: 840750,
);

/// `TaxReportView` for October 2026.
TaxReport accountingTaxReport() => TaxReport(
  from: accountingPeriodStart,
  to: accountingReferenceDate,
  revenueInclusive: 1840000,
  vatPortion: 226000,
);
