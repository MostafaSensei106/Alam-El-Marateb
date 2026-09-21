package com.mostafasensei.alamelmarateb.modules.product.domain.service

import com.mostafasensei.alamelmarateb.core.outbox.IdempotencyGuard
import com.mostafasensei.alamelmarateb.core.search.ProductSearch
import com.mostafasensei.alamelmarateb.core.search.ProductSearchDoc
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.math.RoundingMode
import java.util.UUID

/**
 * Search index writer (Phase 3). Consumes `catalog.product_changed` events
 * (in-process or Kafka — same method) and upserts one Meilisearch document
 * per product. Idempotent: upsert-by-id plus [IdempotencyGuard], so replays
 * and rebalances are safe. Missing/inactive products delete the document,
 * which uniformly covers product deletes and deactivations.
 */
@Service
class CatalogSearchIndexer(
    private val catalogService: ProductCatalogService,
    private val search: ProductSearch,
    private val guard: IdempotencyGuard,
) {

    private val log = LoggerFactory.getLogger(CatalogSearchIndexer::class.java)

    fun indexProduct(productId: UUID, eventId: UUID) {
        if (!guard.claim(eventId, "search")) {
            log.debug("search skipped duplicate event={}", eventId)
            return
        }
        applyProduct(productId)
    }

    fun applyProduct(productId: UUID) {
        val product = catalogService.getProduct(productId)
        if (product == null || !product.isActive) {
            search.delete(productId)
            return
        }
        search.upsert(buildDoc(product.id!!, product.name, product.slug, product.brand, product.categoryId,
            product.variants.minOfOrNull { it.sellingPrice } ?: BigDecimal.ZERO,
            product.isActive, product.translations))
    }

    /** Full rebuild (admin endpoint, after enabling the backend). */
    @Transactional(readOnly = true)
    fun rebuildAll(): Int {
        val products = catalogService.getAllProducts()
        val docs = products.filter { it.isActive }.map {
            buildDoc(it.id!!, it.name, it.slug, it.brand, it.categoryId,
                it.variants.minOfOrNull { v -> v.sellingPrice } ?: BigDecimal.ZERO,
                it.isActive, it.translations)
        }
        // Drop stale docs for products that no longer exist/are inactive.
        val ok = search.rebuild(docs)
        log.info("search rebuild docs={} ok={}", docs.size, ok)
        return if (ok) docs.size else -1
    }

    companion object {
        fun buildDoc(
            id: UUID,
            name: String,
            slug: String,
            brand: String,
            categoryId: UUID?,
            minPrice: BigDecimal,
            isActive: Boolean,
            translations: Map<String, Map<String, String?>>,
        ): ProductSearchDoc {
            // Translated names (any `name` key) become searchable alternates.
            val altNames = translations.values.mapNotNull { it["name"] }
                .filter { it.isNotBlank() && !it.equals(name, ignoreCase = true) }
                .distinct()
            return ProductSearchDoc(
                id = id, name = name, slug = slug, brand = brand,
                categoryId = categoryId, categoryName = null,
                minPrice = minPrice.setScale(2, RoundingMode.HALF_EVEN),
                isActive = isActive, imageUrl = null, altNames = altNames,
            )
        }
    }
}
