package com.mostafasensei.alamelmarateb.core.router.dashboard

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object DashboardInventoryRoutes {
    private const val PREFIX = "${ApiVersion.V1}/dashboard/inventory"

    const val BASE = PREFIX
    const val WAREHOUSES = "/warehouses"
    const val WAREHOUSE_BY_ID = "/warehouses/{id}"
    const val AUDIT_SESSIONS = "/audits"
    const val PURCHASE_ORDERS = "/purchases"
    const val PURCHASE_ORDER_BY_ID = "/purchases/{id}"
}