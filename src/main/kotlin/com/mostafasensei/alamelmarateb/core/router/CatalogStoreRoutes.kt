package com.mostafasensei.alamelmarateb.core.router

/**
 * Catalog STOREFRONT routes — owning module: catalog (product).
 * Audience: public (anonymous browsing).
 * Access: GET permitAll, no auth required.
 */
object CatalogStoreRoutes {
    private const val PREFIX = "/api/v1/catalog/public"

    const val PRODUCTS = "$PREFIX/products"
    const val PRODUCT_BY_SLUG = "$PREFIX/products/{slug}"
    const val PRODUCT_VARIANTS = "$PREFIX/products/{id}/variants"
    const val PRODUCT_COMPARE = "$PREFIX/products/compare"
    const val PRODUCT_FEATURED = "$PREFIX/products/featured"
    const val PRODUCT_SEARCH = "$PREFIX/products/search"
    const val CATEGORIES = "$PREFIX/categories"
    const val PRODUCT_REVIEWS = "$PREFIX/products/{slug}/reviews"
    const val QUIZ = "$PREFIX/quiz"
    const val QUIZ_RECOMMEND = "$PREFIX/quiz/recommend"
    const val BRANDS = "$PREFIX/brands"
    const val PRODUCT_IMAGES = "$PREFIX/products/{slug}/images"
    const val CUSTOM_QUOTE = "$PREFIX/products/{slug}/custom-quote"
}
