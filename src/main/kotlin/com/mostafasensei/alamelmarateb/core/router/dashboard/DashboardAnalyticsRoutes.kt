package com.mostafasensei.alamelmarateb.core.router.dashboard

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object DashboardAnalyticsRoutes {
    private const val PREFIX = "${ApiVersion.V1}/dashboard/analytics"

    const val BASE = PREFIX
    const val SUMMARY = "/summary"
    const val REVENUE = "/revenue"
    const val PRODUCTS = "/products"
    const val SEASONS = "/seasons"
    const val GEO_HEATMAP = "/geo-heatmap"
    const val VELOCITY = "/product-velocity"

}