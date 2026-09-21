package com.mostafasensei.alamelmarateb.core.search

import java.math.BigDecimal
import java.util.UUID

/**
 * Search document (Phase 3). The DB stays the source of truth — search only
 * ranks/filters and returns ids; the service hydrates full products from
 * Postgres. `altNames` carries translated names so EN queries match.
 */
data class ProductSearchDoc(
    val id: UUID,
    val name: String,
    val slug: String,
    val brand: String,
    val categoryId: UUID?,
    val categoryName: String?,
    val minPrice: BigDecimal,
    val isActive: Boolean,
    val imageUrl: String?,
    val altNames: List<String> = emptyList(),
)

data class ProductSearchQuery(
    val q: String?,
    val categoryId: UUID?,
    val brand: String?,
    val minPrice: BigDecimal?,
    val maxPrice: BigDecimal?,
    val limit: Int = 50,
)

/**
 * Search port (Strategy): Meilisearch today, swappable tomorrow.
 * Nullable results mean "backend unavailable/disabled" — callers MUST fall
 * back to the Postgres filter so search never breaks the storefront.
 */
interface ProductSearch {
    fun upsert(doc: ProductSearchDoc): Boolean
    fun delete(id: UUID): Boolean
    fun searchIds(query: ProductSearchQuery): List<UUID>?
    fun suggest(q: String, limit: Int = 8): List<String>?
    fun rebuild(docs: List<ProductSearchDoc>): Boolean
}
