package com.mostafasensei.alamelmarateb.core.router.admin

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object AdminInventoryRoutes {
    private const val PREFIX = "${ApiVersion.V1}/admin/inventory"

    const val BASE = PREFIX
    const val WAREHOUSES = "/warehouses"
    const val WAREHOUSE_BY_ID = "/warehouses/{warehouseId}"
    const val STOCKS_OVERVIEW = "/stocks"
    const val LOW_STOCK_ALERTS = "/stocks/low-alerts"
    const val TRANSFERS = "/transfers"
    const val TRANSFER_BY_ID = "/transfers/{transferId}"
    const val AUDITS = "/audits"
    const val AUDIT_RECONCILE = "/audits/{auditId}/reconcile"
    const val SUPPLIERS = "/suppliers"
    const val SUPPLIER_BY_ID = "/suppliers/{id}"
    const val PURCHASE_ORDERS = "/purchases"
    const val PURCHASE_ORDER_BY_ID = "/purchases/{id}"
    const val RECEIVE_GOODS = "/purchases/{id}/receive"
}