package com.mostafasensei.alamelmarateb.core.router

/**
 * Analytics / dashboard routes — owning module: analytics (read-model over all modules).
 * Audience: management dashboard ONLY (aggregated business data).
 * Required roles: BRANCH_MANAGER, SUPER_ADMIN.
 * Never exposed to customers or operational staff.
 */
object AnalyticsRoutes {
    private const val PREFIX = "/api/v1/analytics"

    const val BASE = PREFIX
    const val SUMMARY = "$PREFIX/summary"
    const val EXECUTIVE_SUMMARY = "$PREFIX/executive-summary"
    const val REVENUE = "$PREFIX/revenue"
    const val REVENUE_AND_PROFIT = "$PREFIX/revenue-profit"
    const val PRODUCTS = "$PREFIX/products"
    const val PRODUCT_VELOCITY = "$PREFIX/product-velocity"
    const val SEASONS = "$PREFIX/seasons"
    const val GEO_HEATMAP = "$PREFIX/geo-heatmap"
    const val CHASSIS_TRENDS = "$PREFIX/chassis-trends"
    const val BRANCH_PERFORMANCE = "$PREFIX/performance/branches"
    const val SALES_REP_METRICS = "$PREFIX/performance/sales-reps"

    const val RFM = "$PREFIX/customers/rfm"
    const val TOP_VARIANTS = "$PREFIX/products/top"

    const val INQUIRIES = "$PREFIX/inquiries"
    const val INQUIRY_TOP = "$PREFIX/inquiries/top-asked"
    const val EVENTS = "$PREFIX/events"

    const val AUDIT_TRAIL = "$PREFIX/audit-trail/{entity}/{entityId}"
}
