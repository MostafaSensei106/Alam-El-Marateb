package com.mostafasensei.alamelmarateb.core.router

/**
 * Promotion MANAGEMENT routes — owning module: sales.
 * Audience: branch managers (create/disable discounts, bundles, gifts).
 * Required roles: BRANCH_MANAGER, SUPER_ADMIN.
 * Customers only see the EFFECT via ShopRoutes.price-preview — never these endpoints.
 */
object PromotionRoutes {
    private const val PREFIX = "/api/v1/sales/promotions"

    const val BASE = PREFIX
    const val BY_ID = "$PREFIX/{id}"
    const val TOGGLE = "$PREFIX/{id}/toggle"
}
