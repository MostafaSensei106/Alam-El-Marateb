package com.mostafasensei.alamelmarateb.modules.analytics.application

import com.mostafasensei.alamelmarateb.core.events.InvoicedLine
import com.mostafasensei.alamelmarateb.core.events.OrderInvoicedEvent
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.jdbc.core.JdbcTemplate
import java.math.BigDecimal
import java.time.LocalDate
import java.util.UUID
import kotlin.test.assertEquals

@SpringBootTest
class SalesFactsUpdaterTest {

    @Autowired
    private lateinit var updater: SalesFactsUpdater

    @Autowired
    private lateinit var jdbc: JdbcTemplate

    @Test
    fun `invoiced event accumulates facts per day branch variant`() {
        val branchId = UUID.randomUUID()
        val categoryId = UUID.randomUUID()
        val productId = UUID.randomUUID()
        val variantId = UUID.randomUUID()
        val day = LocalDate.now()
        try {
            jdbc.update(
                "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
                branchId, "Facts Branch", "BR-F${System.nanoTime()}", "Cairo", "St",
            )
            jdbc.update(
                "INSERT INTO product_categories (id, name, slug) VALUES (?, ?, ?)",
                categoryId, "Mattresses", "matt-${System.nanoTime()}",
            )
            jdbc.update(
                "INSERT INTO products (id, category_id, name, slug, brand) VALUES (?, ?, ?, ?, ?)",
                productId, categoryId, "Serta", "serta-${System.nanoTime()}", "Serta",
            )
            jdbc.update(
                "INSERT INTO product_variants (id, product_id, sku, width_cm, length_cm, height_cm, cost_price, selling_price) VALUES (?, ?, ?, 120, 195, 25, 1000, 1500)",
                variantId, productId, "SKU-${System.nanoTime()}",
            )
            val event = OrderInvoicedEvent(
                orderId = UUID.randomUUID(), branchId = branchId, day = day,
                lines = listOf(InvoicedLine(variantId, 2, BigDecimal("3000.00"), BigDecimal("1000.00"))),
            )
            updater.onOrderInvoiced(event)
            // At-least-once redelivery of the SAME event must not double-count.
            updater.onOrderInvoiced(event)

            val row = jdbc.queryForMap(
                "SELECT qty, revenue, cost, profit FROM sales_daily_facts WHERE day = ? AND branch_id = ? AND variant_id = ?",
                day, branchId, variantId,
            )
            assertEquals(2, (row["qty"] as Number).toInt())
            assertEquals(BigDecimal("3000.00"), BigDecimal(row["revenue"].toString()))
            assertEquals(BigDecimal("2000.00"), BigDecimal(row["cost"].toString()))
            assertEquals(BigDecimal("1000.00"), BigDecimal(row["profit"].toString()))

            // A DIFFERENT event (new eventId) for the same facts still accumulates.
            updater.onOrderInvoiced(
                OrderInvoicedEvent(
                    orderId = UUID.randomUUID(), branchId = branchId, day = day,
                    lines = listOf(InvoicedLine(variantId, 2, BigDecimal("3000.00"), BigDecimal("1000.00"))),
                ),
            )
            val row2 = jdbc.queryForMap(
                "SELECT qty, revenue, cost, profit FROM sales_daily_facts WHERE day = ? AND branch_id = ? AND variant_id = ?",
                day, branchId, variantId,
            )
            assertEquals(4, (row2["qty"] as Number).toInt())
            assertEquals(BigDecimal("6000.00"), BigDecimal(row2["revenue"].toString()))
        } finally {
            jdbc.update("DELETE FROM sales_daily_facts WHERE branch_id = ?", branchId)
            jdbc.update("DELETE FROM product_variants WHERE id = ?", variantId)
            jdbc.update("DELETE FROM products WHERE id = ?", productId)
            jdbc.update("DELETE FROM product_categories WHERE id = ?", categoryId)
            jdbc.update("DELETE FROM branches WHERE id = ?", branchId)
        }
    }
}
