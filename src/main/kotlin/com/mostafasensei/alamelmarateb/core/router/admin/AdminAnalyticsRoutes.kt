package com.mostafasensei.alamelmarateb.core.router.admin

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object AdminAnalyticsRoutes {
    private const val PREFIX = "${ApiVersion.V1}/admin/analytics"

    const val BASE = PREFIX
    const val EXECUTIVE_SUMMARY = "/summary"
    const val REVENUE_AND_PROFIT = "/revenue-profit"
    const val SEASONS = "/seasons"
    const val GEO_HEATMAP = "/geo-heatmap"
    const val PRODUCT_VELOCITY = "/product-velocity"
    const val CHASSIS_COMPARISON = "/chassis-trends"
    const val BRANCH_PERFORMANCE = "/performance/branches"
    const val SALES_REP_METRICS = "/performance/sales-reps"

}