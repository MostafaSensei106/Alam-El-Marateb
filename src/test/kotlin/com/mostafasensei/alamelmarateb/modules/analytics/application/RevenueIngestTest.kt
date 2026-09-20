package com.mostafasensei.alamelmarateb.modules.analytics.application

import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.transaction.PlatformTransactionManager
import org.springframework.transaction.TransactionDefinition
import org.springframework.transaction.annotation.Transactional
import org.springframework.transaction.support.TransactionTemplate
import java.math.BigDecimal
import java.time.LocalDate
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertTrue

@SpringBootTest
@Transactional
class RevenueIngestTest {

    @Autowired private lateinit var revenueService: RevenueService
    @Autowired private lateinit var inquiryService: InquiryService
    @Autowired private lateinit var beaconService: BeaconService
    @Autowired private lateinit var jdbc: JdbcTemplate
    @Autowired private lateinit var txManager: PlatformTransactionManager

    private fun committed(sql: String, vararg args: Any?) {
        val template = TransactionTemplate(txManager)
        template.propagationBehavior = TransactionDefinition.PROPAGATION_REQUIRES_NEW
        template.execute { jdbc.update(sql, *args) }
    }

    @Test
    fun `revenue reads facts, beacon always stores with consent, inquiries logged`() {
        val suffix = System.nanoTime()
        val branchId = UUID.randomUUID()
        try {
        committed(
            "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
            branchId, "Rev Branch", "RVB-$suffix", "Cairo", "St",
        )
        val variantId = UUID.randomUUID()
        val day = LocalDate.now()
        committed(
            "INSERT INTO product_categories (id, name, slug) VALUES (?, ?, ?)",
            UUID.randomUUID(), "Rev Cat", "rev-cat-$suffix",
        )
        val catId = jdbc.queryForObject(
            "SELECT id FROM product_categories WHERE slug = ?", UUID::class.java, "rev-cat-$suffix",
        )
        val productId = UUID.randomUUID()
        committed(
            "INSERT INTO products (id, category_id, name, slug, brand) VALUES (?, ?, ?, ?, ?)",
            productId, catId, "Rev Mattress", "rev-mattress-$suffix", "B",
        )
        committed(
            "INSERT INTO product_variants (id, product_id, sku, width_cm, length_cm, height_cm, cost_price, selling_price) VALUES (?, ?, ?, 120, 195, 25, 8000, 16000)",
            variantId, productId, "REV-$suffix",
        )
        committed(
            "INSERT INTO sales_daily_facts (day, branch_id, variant_id, qty, revenue, cost, profit) VALUES (?, ?, ?, 2, 16000, 8000, 8000)",
            day, branchId, variantId,
        )

        val summary = revenueService.revenue(day, day, branchId)
        assertEquals(BigDecimal("16000.00"), summary.totalRevenue)
        assertEquals(BigDecimal("8000.00"), summary.totalProfit)
        assertEquals(2, summary.totalQty)
        assertEquals(1, summary.points.size)

        val top = revenueService.topVariants(day, day, 5)
        assertEquals(1, top.size)
        assertEquals(variantId, top.single().variantId)

        val perf = revenueService.branchPerformance(day, day)
        assertTrue(perf.any { it.branchId == branchId && it.revenue == BigDecimal("16000.00") })

        // Beacon: consent=false stores nothing, consent=true stores.
        val before = jdbc.queryForObject("SELECT COUNT(*) FROM app_events", Long::class.java) ?: 0
        beaconService.ingest("ProductViewed", null, "anon-1", mapOf("slug" to "x"), false)
        beaconService.ingest("ProductViewed", null, "anon-1", mapOf("slug" to "x"), true)
        val after = jdbc.queryForObject("SELECT COUNT(*) FROM app_events", Long::class.java) ?: 0
        assertEquals(before + 1, after)

        // Inquiry log + list.
        val logged = inquiryService.log(branchId, null, null, null, "سأل عن مرتبة", "price", "01000000001", "test")
        assertEquals("price", logged.outcome)
        assertTrue(inquiryService.list(branchId).any { it.id == logged.id })
        } finally {
            jdbc.update("DELETE FROM app_events WHERE anonymous_id = ?", "anon-1")
            jdbc.update("DELETE FROM inquiries WHERE branch_id = ?", branchId)
            jdbc.update("DELETE FROM sales_daily_facts WHERE branch_id = ?", branchId)
            jdbc.update("DELETE FROM product_variants WHERE sku = ?", "REV-$suffix")
            jdbc.update("DELETE FROM products WHERE slug = ?", "rev-mattress-$suffix")
            jdbc.update("DELETE FROM product_categories WHERE slug = ?", "rev-cat-$suffix")
            jdbc.update("DELETE FROM branches WHERE id = ?", branchId)
        }
    }
}
