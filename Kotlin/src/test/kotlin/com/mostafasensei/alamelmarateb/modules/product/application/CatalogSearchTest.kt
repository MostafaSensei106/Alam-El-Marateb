package com.mostafasensei.alamelmarateb.modules.product.application

import com.mostafasensei.alamelmarateb.core.outbox.OutboxRelay
import com.mostafasensei.alamelmarateb.core.search.ProductSearch
import com.mostafasensei.alamelmarateb.core.search.ProductSearchDoc
import com.mostafasensei.alamelmarateb.core.search.ProductSearchQuery
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.domain.service.CatalogSearchIndexer
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.jdbc.core.JdbcTemplate
import java.math.BigDecimal
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertNotNull
import kotlin.test.assertTrue

/**
 * Phase 3: with the default `none` backend, search/suggest fall back to the
 * Postgres filter; mutations still emit `catalog.product_changed` outbox rows
 * so enabling Meilisearch later only needs a rebuild.
 */
@SpringBootTest
class CatalogSearchTest {

    @Autowired
    private lateinit var catalogService: ProductCatalogService

    @Autowired
    private lateinit var indexer: CatalogSearchIndexer

    @Autowired
    private lateinit var relay: OutboxRelay

    @Autowired
    private lateinit var jdbc: JdbcTemplate

    @Autowired
    private lateinit var guard: com.mostafasensei.alamelmarateb.core.outbox.IdempotencyGuard

    class FakeSearch : ProductSearch {
        val upserts = mutableListOf<ProductSearchDoc>()
        val deletes = mutableListOf<UUID>()
        override fun upsert(doc: ProductSearchDoc): Boolean {
            upserts.add(doc)
            return true
        }
        override fun delete(id: UUID): Boolean {
            deletes.add(id)
            return true
        }
        override fun searchIds(query: ProductSearchQuery): List<UUID>? = null
        override fun suggest(q: String, limit: Int): List<String>? = null
        override fun rebuild(docs: List<ProductSearchDoc>): Boolean = true
    }

    @Test
    fun `fallback search and suggest work without a backend`() {
        val suffix = System.nanoTime()
        val category = catalogService.createCategory(ProductCategory(name = "Search Cat", slug = "search-cat-$suffix"))
        val product = catalogService.createProduct(
            Product(categoryId = category.id!!, name = "مرتبة سيرش الفاخرة", slug = "search-mattress-$suffix", brand = "TestBrand"),
        )
        try {
            val found = catalogService.search("سيرش", null, null, null, null)
            assertTrue(found.any { it.id == product.id }, "fallback filter must match by name")

            val byBrand = catalogService.search(null, null, "testbrand", null, null)
            assertTrue(byBrand.any { it.id == product.id }, "fallback filter must match brand case-insensitively")

            val suggestions = catalogService.suggest("سيرش")
            assertTrue(suggestions.contains(product.name))

            // Mutation emitted the async index event; relay consumes it (NoOp backend).
            val outboxCount = jdbc.queryForObject(
                "SELECT COUNT(*) FROM outbox_events WHERE aggregate_id = ? AND type = 'catalog.product_changed'",
                Int::class.java, product.id,
            )
            assertEquals(1, outboxCount)
            relay.relay()
            val pending = jdbc.queryForObject(
                "SELECT COUNT(*) FROM outbox_events WHERE aggregate_id = ? AND status = 'PENDING'",
                Int::class.java, product.id,
            )
            assertEquals(0, pending)
        } finally {
            jdbc.update("DELETE FROM outbox_events WHERE aggregate_id = ?", product.id)
            jdbc.update("DELETE FROM consumer_processed_events WHERE consumer = 'search'")
            jdbc.update("DELETE FROM products WHERE id = ?", product.id)
            jdbc.update("DELETE FROM product_categories WHERE id = ?", category.id)
        }
    }

    @Test
    fun `indexer builds ranked docs and deletes missing products`() {
        val suffix = System.nanoTime()
        val category = catalogService.createCategory(ProductCategory(name = "Idx Cat", slug = "idx-cat-$suffix"))
        val product = catalogService.createProduct(
            Product(
                categoryId = category.id!!, name = "Idx Mattress", slug = "idx-mattress-$suffix", brand = "IdxBrand",
                translations = mapOf(
                    "ar" to mapOf("name" to "مرتبة إندكس"),
                    "en" to mapOf("name" to "Index Mattress EN"),
                ),
            ),
        )
        val fake = FakeSearch()
        val direct = CatalogSearchIndexer(catalogService, fake, guard)
        try {
            direct.applyProduct(product.id!!)
            assertEquals(1, fake.upserts.size)
            val doc = fake.upserts.single()
            assertEquals(product.id, doc.id)
            // Resolved display name + alternates cover all translations,
            // regardless of the request language.
            assertEquals(
                setOf("مرتبة إندكس", "Index Mattress EN"),
                (setOf(doc.name) + doc.altNames).filter { it.isNotBlank() }.toSet(),
            )

            direct.applyProduct(UUID.randomUUID())
            assertEquals(1, fake.deletes.size)
        } finally {
            val found = jdbc.queryForObject(
                "SELECT id FROM products WHERE id = ?", UUID::class.java, product.id,
            )
            assertNotNull(found)
            jdbc.update("DELETE FROM outbox_events WHERE aggregate_id = ?", product.id)
            jdbc.update("DELETE FROM consumer_processed_events WHERE consumer = 'search'")
            jdbc.update("DELETE FROM products WHERE id = ?", product.id)
            jdbc.update("DELETE FROM product_categories WHERE id = ?", category.id)
        }
    }
}
