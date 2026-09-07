package com.mostafasensei.alamelmarateb.core.router.admin

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object AdminAccountingRoutes {
    private const val PREFIX = "${ApiVersion.V1}/admin/accounting"

    const val BASE = PREFIX
    const val CHART_OF_ACCOUNTS = "/chart-of-accounts"
    const val ACCOUNT_BY_CODE = "/chart-of-accounts/{code}"
    const val JOURNAL_ENTRIES = "/journal-entries"
    const val GENERAL_LEDGER = "/general-ledger"
    const val TREASURIES = "/treasuries"
    const val TREASURY_TRANSFERS = "/treasuries/transfers"
    const val EXPENSES = "/expenses"
    const val EXPENSE_BY_ID = "/expenses/{id}"
    const val SUPPLIER_PAYMENTS = "/supplier-payments"
    const val CHECKS = "/checks"
    const val CHECK_STATUS = "/checks/{id}/status"
    const val TAX_REPORT = "/reports/tax"
    const val PROFIT_AND_LOSS = "/reports/profit-loss"
    const val BALANCE_SHEET = "/reports/balance-sheet"
}