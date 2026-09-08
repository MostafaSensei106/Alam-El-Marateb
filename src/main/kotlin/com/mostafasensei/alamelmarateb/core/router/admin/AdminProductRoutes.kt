package com.mostafasensei.alamelmarateb.core.router.admin

import com.mostafasensei.alamelmarateb.core.router.api.ApiVersion

object AdminProductRoutes {
    private const val PREFIX = "${ApiVersion.V1}/admin"

    const val CATEGORIES = "$PREFIX/categories"
    const val CATEGORY_BY_ID = "$PREFIX/categories/{id}"
    const val CATEGORY_ATTRIBUTES = "$PREFIX/categories/{id}/attributes"

    const val ATTRIBUTES = "$PREFIX/attributes"
    const val ATTRIBUTE_BY_ID = "$PREFIX/attributes/{id}"
    const val ATTRIBUTE_OPTIONS = "$PREFIX/attributes/{id}/options"
    const val ATTRIBUTE_OPTION_BY_ID = "$PREFIX/attributes/{id}/options/{optionId}"

    const val PRESETS = "$PREFIX/product-presets"
    const val PRESET_BY_ID = "$PREFIX/product-presets/{id}"

    const val PRODUCTS = "$PREFIX/products"
    const val PRODUCT_BY_ID = "$PREFIX/products/{id}"
    const val PRODUCT_FROM_PRESET = "$PREFIX/products/from-preset/{presetId}"
}
