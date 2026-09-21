package com.mostafasensei.alamelmarateb.core.router

/**
 * Accounting routes — owning module: accounting.
 * Audience: accountants (books, treasuries, expenses, checks, tax reports).
 * Required roles: ACCOUNTANT, SUPER_ADMIN.
 */
object AccountingRoutes {
    private const val PREFIX = "/api/v1/accounting"

    const val BASE = PREFIX
    const val CHART_OF_ACCOUNTS = "$PREFIX/chart-of-accounts"
    const val ACCOUNT_BY_CODE = "$PREFIX/chart-of-accounts/{code}"
    const val JOURNAL_ENTRIES = "$PREFIX/journal-entries"
    const val GENERAL_LEDGER = "$PREFIX/general-ledger"
    const val TREASURIES = "$PREFIX/treasuries"
    const val TREASURY_TRANSFERS = "$PREFIX/treasuries/transfers"
    const val EXPENSES = "$PREFIX/expenses"
    const val EXPENSE_BY_ID = "$PREFIX/expenses/{id}"
    const val CHECKS = "$PREFIX/checks"
    const val CHECK_STATUS = "$PREFIX/checks/{id}/status"
    const val TAX_REPORT = "$PREFIX/reports/tax"
    const val PROFIT_AND_LOSS = "$PREFIX/reports/profit-loss"
    const val BALANCE_SHEET = "$PREFIX/reports/balance-sheet"
}
