package com.mostafasensei.alamelmarateb.core.router.ecommerce

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object EcommerceCartRoutes {
    private const val PREFIX = "${ApiVersion.V1}/ecommerce/cart"

    const val BASE = PREFIX
    const val ITEMS = "/items"
    const val ITEM_BY_ID = "/items/{itemId}"
    const val MERGE = "/merge"
    const val CLEAR = "/clear"
    const val DRAFT = "/draft"
}