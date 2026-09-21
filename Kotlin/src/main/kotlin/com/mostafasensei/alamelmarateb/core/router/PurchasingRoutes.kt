package com.mostafasensei.alamelmarateb.core.router

/**
 * Purchasing routes — owning module: purchasing.
 * Audience: branch managers (suppliers + purchase orders + goods receipt).
 * Required roles: BRANCH_MANAGER, SUPER_ADMIN.
 */
object PurchasingRoutes {
    private const val PREFIX = "/api/v1/purchasing"

    const val SUPPLIERS = "$PREFIX/suppliers"
    const val SUPPLIER_BY_ID = "$PREFIX/suppliers/{id}"
    const val PURCHASE_ORDERS = "$PREFIX/purchase-orders"
    const val PURCHASE_ORDER_BY_ID = "$PREFIX/purchase-orders/{id}"
    const val RECEIVE_GOODS = "$PREFIX/purchase-orders/{id}/receive"
    const val SUPPLIER_PAYMENTS = "$PREFIX/supplier-payments"
}
