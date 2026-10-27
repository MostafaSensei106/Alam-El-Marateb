/// Sample chart of accounts, journal entries and ledger lines.
///
/// Codes, amounts and field names mirror the backend payloads; only the
/// display names come from `AppLocalizations` so the tables read naturally in
/// both languages.
library;

import '../../../../../l10n/app_localizations.dart';
import 'accounting_models.dart';

/// Fixed "today" so every sample screen agrees on relative dates.
final accountingReferenceDate = DateTime(2026, 10, 21);

/// Start of the sample reporting period.
final accountingPeriodStart = DateTime(2026, 10);

const _accountSeeds = <(String, AccountType, double, String?, String?)>[
  ('1110', AccountType.asset, 61100, null, 'br-tanta'),
  ('1120', AccountType.asset, 480000, null, null),
  ('1130', AccountType.asset, 184300, null, null),
  ('1140', AccountType.asset, 300000, null, null),
  ('1150', AccountType.asset, 6100, '1110', null),
  ('2110', AccountType.liability, 148750, null, null),
  ('2120', AccountType.liability, 42000, '2110', null),
  ('3110', AccountType.equity, 600000, null, null),
  ('3120', AccountType.equity, 240750, '3110', null),
  ('4110', AccountType.revenue, 1840000, null, null),
  ('5110', AccountType.expense, 1180000, null, null),
  ('5210', AccountType.expense, 96000, null, 'br-cairo'),
  ('5220', AccountType.expense, 240000, null, null),
  ('5230', AccountType.expense, 40500, null, 'br-tanta'),
  ('5240', AccountType.expense, 60000, null, null),
];

/// `AccountView.name` for the seeded codes.
String accountingAccountName(AppLocalizations l10n, String code) =>
    switch (code) {
      '1110' => l10n.accountingAccountCash,
      '1120' => l10n.accountingAccountBank,
      '1130' => l10n.accountingAccountReceivables,
      '1140' => l10n.accountingAccountInventory,
      '1150' => l10n.accountingAccountPettyCash,
      '2110' => l10n.accountingAccountPayables,
      '2120' => l10n.accountingAccountVatPayable,
      '3110' => l10n.accountingAccountCapital,
      '3120' => l10n.accountingAccountRetained,
      '4110' => l10n.accountingAccountSalesRevenue,
      '5110' => l10n.accountingAccountCogs,
      '5210' => l10n.accountingAccountRent,
      '5220' => l10n.accountingAccountSalaries,
      '5230' => l10n.accountingAccountUtilities,
      '5240' => l10n.accountingAccountMarketing,
      _ => code,
    };

/// Resolves a `branchId` to its sample name; `null` means all branches.
String? accountingBranchName(AppLocalizations l10n, String? branchId) =>
    switch (branchId) {
      'br-tanta' => l10n.sampleBranch1,
      'br-cairo' => l10n.sampleBranch2,
      'br-alex' => l10n.sampleBranch3,
      _ => null,
    };

/// Every row of the chart of accounts, ordered by code.
List<AccountRow> accountingAccounts(AppLocalizations l10n) => [
  for (final (code, type, balance, parent, branch) in _accountSeeds)
    AccountRow(
      code: code,
      name: accountingAccountName(l10n, code),
      type: type,
      balance: balance,
      parentCode: parent,
      branchId: branch,
    ),
];

JournalLine _line(
  String code,
  String name, {
  double debit = 0,
  double credit = 0,
}) => JournalLine(
  accountCode: code,
  accountName: name,
  debit: debit,
  credit: credit,
);

/// Six balanced entries, one of them a full opening-balance posting.
List<JournalRow> accountingJournalEntries(AppLocalizations l10n) {
  final cash = l10n.accountingAccountCash;
  final bank = l10n.accountingAccountBank;
  final receivables = l10n.accountingAccountReceivables;
  final inventory = l10n.accountingAccountInventory;
  final petty = l10n.accountingAccountPettyCash;
  final payables = l10n.accountingAccountPayables;
  final vat = l10n.accountingAccountVatPayable;
  final capital = l10n.accountingAccountCapital;
  final retained = l10n.accountingAccountRetained;
  final revenue = l10n.accountingAccountSalesRevenue;
  final rent = l10n.accountingAccountRent;
  final salaries = l10n.accountingAccountSalaries;

  return [
    JournalRow(
      id: 'JE-2026-0179',
      entryDate: DateTime(2026, 10),
      source: JournalSource.manual,
      reference: 'OPEN-2026',
      memo: l10n.accountingMemoOpening,
      lines: [
        _line('1110', cash, debit: 61100),
        _line('1120', bank, debit: 480000),
        _line('1130', receivables, debit: 184300),
        _line('1140', inventory, debit: 300000),
        _line('1150', petty, debit: 6100),
        _line('2110', payables, credit: 148750),
        _line('2120', vat, credit: 42000),
        _line('3110', capital, credit: 600000),
        _line('3120', retained, credit: 240750),
      ],
    ),
    JournalRow(
      id: 'JE-2026-0180',
      entryDate: DateTime(2026, 10, 14),
      source: JournalSource.sales,
      reference: 'INV-8842',
      memo: l10n.accountingMemoSales,
      branchId: 'br-tanta',
      lines: [_line('1110', cash, debit: 45000), _line('4110', revenue, credit: 45000)],
    ),
    JournalRow(
      id: 'JE-2026-0181',
      entryDate: DateTime(2026, 10, 15),
      source: JournalSource.purchasing,
      reference: 'PO-3312',
      memo: l10n.accountingMemoSupplies,
      branchId: 'br-cairo',
      lines: [
        _line('1140', inventory, debit: 32000),
        _line('2110', payables, credit: 32000),
      ],
    ),
    JournalRow(
      id: 'JE-2026-0182',
      entryDate: DateTime(2026, 10, 16),
      source: JournalSource.expense,
      reference: 'EXP-0911',
      memo: l10n.accountingMemoRent,
      branchId: 'br-cairo',
      lines: [_line('5210', rent, debit: 24000), _line('1120', bank, credit: 24000)],
    ),
    JournalRow(
      id: 'JE-2026-0183',
      entryDate: DateTime(2026, 10, 19),
      source: JournalSource.transfer,
      reference: 'TR-0041',
      memo: l10n.accountingMemoTransfer,
      lines: [_line('1110', cash, debit: 15000), _line('1120', bank, credit: 15000)],
    ),
    JournalRow(
      id: 'JE-2026-0184',
      entryDate: DateTime(2026, 10, 21),
      source: JournalSource.manual,
      reference: 'PAY-2026-10',
      memo: l10n.accountingCategorySalaries,
      lines: [
        _line('5220', salaries, debit: 96000),
        _line('1120', bank, credit: 96000),
      ],
    ),
  ];
}

final _ledgerSeeds =
    <(String, DateTime, JournalSource, double, double, String?)>[
      ('JE-2026-0179', DateTime(2026, 10), JournalSource.manual, 61100, 0, 'OPEN-2026'),
      ('JE-2026-0180', DateTime(2026, 10, 3), JournalSource.sales, 12500, 0, 'INV-8831'),
      ('PC-2026-10', DateTime(2026, 10, 6), JournalSource.manual, 0, 8400, 'PC-2026-10'),
      ('INV-8836', DateTime(2026, 10, 9), JournalSource.sales, 22300, 0, 'INV-8836'),
      ('EXP-0915', DateTime(2026, 10, 12), JournalSource.expense, 0, 18000, 'EXP-0915'),
      ('JE-2026-0180', DateTime(2026, 10, 14), JournalSource.sales, 45000, 0, 'INV-8842'),
      ('ADV-2026-10', DateTime(2026, 10, 16), JournalSource.manual, 0, 30000, 'ADV-2026-10'),
      ('TR-0041', DateTime(2026, 10, 17), JournalSource.transfer, 0, 15000, 'TR-0041'),
      ('TR-0040', DateTime(2026, 10, 19), JournalSource.transfer, 15000, 0, 'TR-0040'),
      ('SUP-2026-44', DateTime(2026, 10, 20), JournalSource.manual, 0, 23400, 'SUP-2026-44'),
    ];

/// General-ledger movement of the cash account (`1110`), closing at 61,100.
List<LedgerRow> accountingLedgerRows(AppLocalizations l10n) {
  final rows = <LedgerRow>[];
  var running = 0.0;

  for (final (entryId, date, source, debit, credit, ref) in _ledgerSeeds) {
    running += debit - credit;
    rows.add(
      LedgerRow(
        entryId: entryId,
        entryDate: date,
        source: source,
        accountCode: '1110',
        accountName: l10n.accountingAccountCash,
        debit: debit,
        credit: credit,
        runningBalance: running,
        reference: ref,
      ),
    );
  }

  return rows;
}
