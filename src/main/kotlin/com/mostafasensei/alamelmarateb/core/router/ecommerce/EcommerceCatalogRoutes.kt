package com.mostafasensei.alamelmarateb.core.router.ecommerce

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object EcommerceCatalogRoutes {
    private const val PREFIX = "${ApiVersion.V1}/ecommerce/products"

    const val BASE = PREFIX
    const val BY_SLUG = "/{slug}"
    const val VARIANTS = "/{id}/variants"
    const val COMPARE = "/compare"
    const val FEATURED = "/featured"
    const val SEARCH = "/search"
    const val CATEGORIES = "${ApiVersion.V1}/ecommerce/categories"
}