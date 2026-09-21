package com.mostafasensei.alamelmarateb.core.router

/**
 * Inventory MANAGEMENT routes — owning module: inventory.
 * Audience: branch managers (warehouses, stock policy, transfers, audits, alerts).
 * Required roles: BRANCH_MANAGER, SUPER_ADMIN.
 * Warehouse keepers must use WarehouseOpsRoutes instead.
 */
object InventoryAdminRoutes {
    private const val PREFIX = "/api/v1/inventory"

    const val BASE = PREFIX
    const val WAREHOUSES = "$PREFIX/warehouses"
    const val WAREHOUSE_BY_ID = "$PREFIX/warehouses/{warehouseId}"
    const val STOCKS = "$PREFIX/stocks"
    const val LOW_STOCK_ALERTS = "$PREFIX/stocks/low-alerts"
    const val TRANSFERS = "$PREFIX/transfers"
    const val TRANSFER_BY_ID = "$PREFIX/transfers/{transferId}"
    const val TRANSFER_APPROVE = "$PREFIX/transfers/{transferId}/approve"
    const val AUDITS = "$PREFIX/audits"
    const val AUDIT_RECONCILE = "$PREFIX/audits/{auditId}/reconcile"
}
