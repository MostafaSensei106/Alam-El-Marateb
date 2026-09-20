package com.mostafasensei.alamelmarateb.core.router

/**
 * Estimator routes — owning module: estimator.
 * Audience: storefront customers (quote + spin), in-store staff (same quote
 * with channel=pos), managers (spin campaigns + prizes).
 * Public reads/computes are open; spin needs CUSTOMER; management needs BRANCH_MANAGER.
 */
object EstimatorRoutes {
    private const val PREFIX = "/api/v1/estimator"

    const val BASE = PREFIX
    const val CATALOG = "$PREFIX/catalog"
    const val QUOTE = "$PREFIX/quote"

    const val SPIN = "$PREFIX/spin"
    const val SPIN_CAMPAIGNS = "$PREFIX/spin/campaigns"
    const val SPIN_CAMPAIGN_BY_ID = "$PREFIX/spin/campaigns/{id}"
    const val SPIN_PRIZES = "$PREFIX/spin/campaigns/{campaignId}/prizes"
    const val SPIN_PRIZE_BY_ID = "$PREFIX/spin/prizes/{id}"
}
