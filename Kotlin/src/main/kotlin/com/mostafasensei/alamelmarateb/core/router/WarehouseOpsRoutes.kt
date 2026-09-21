package com.mostafasensei.alamelmarateb.core.router

/**
 * Warehouse OPERATIONS routes — owning module: inventory.
 * Audience: warehouse keepers (daily floor operations: lookup, adjust, receive, count).
 * Required roles: WAREHOUSE_KEEPER, SUPER_ADMIN.
 */
object WarehouseOpsRoutes {
    private const val PREFIX = "/api/v1/warehouse"

    const val BASE = PREFIX
    const val STOCK_LOOKUP = "$PREFIX/stocks/lookup/{barcodeOrSku}"
    const val STOCK_ADJUSTMENT = "$PREFIX/stocks/adjustment"
    const val TRANSFERS_PENDING = "$PREFIX/transfers/pending"
    const val TRANSFER_CONFIRM = "$PREFIX/transfers/{transferId}/confirm-receipt"
    const val AUDIT_SUBMIT_COUNT = "$PREFIX/audits/{auditId}/count"
}
