package com.mostafasensei.alamelmarateb.core.outbox

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

/**
 * Phase 2: outbox row is written atomically, the relay publishes it, and
 * redelivery never double-applies (guard) nor republishes (status flip).
 */
@SpringBootTest
class OutboxRelayTest {

    @Autowired
    private lateinit var writer: OutboxWriter

    @Autowired
    private lateinit var relay: OutboxRelay

    @Autowired
    private lateinit var jdbc: JdbcTemplate

    @Test
    fun `relay publishes pending row once and redelivery is a no-op`() {
        val branchId = UUID.randomUUID()
        val categoryId = UUID.randomUUID()
        val productId = UUID.randomUUID()
        val variantId = UUID.randomUUID()
        val orderId = UUID.randomUUID()
        val day = LocalDate.now()
        var eventId: UUID? = null
        try {
            jdbc.update(
                "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
                branchId, "Outbox Branch", "BR-O${System.nanoTime()}", "Cairo", "St",
            )
            jdbc.update(
                "INSERT INTO product_categories (id, name, slug) VALUES (?, ?, ?)",
                categoryId, "Mattresses", "matt-o${System.nanoTime()}",
            )
            jdbc.update(
                "INSERT INTO products (id, category_id, name, slug, brand) VALUES (?, ?, ?, ?, ?)",
                productId, categoryId, "Serta", "serta-o${System.nanoTime()}", "Serta",
            )
            jdbc.update(
                "INSERT INTO product_variants (id, product_id, sku, width_cm, length_cm, height_cm, cost_price, selling_price) VALUES (?, ?, ?, 120, 195, 25, 1000, 1500)",
                variantId, productId, "SKU-O${System.nanoTime()}",
            )
            val event = OrderInvoicedEvent(
                orderId = orderId, branchId = branchId, day = day,
                lines = listOf(InvoicedLine(variantId, 1, BigDecimal("1500.00"), BigDecimal("1000.00"))),
            )
            eventId = event.eventId
            writer.emit("order", orderId, OutboxWriter.ORDER_INVOICED, event)

            assertEquals(
                1,
                jdbc.queryForObject(
                    "SELECT COUNT(*) FROM outbox_events WHERE aggregate_id = ? AND status = 'PENDING'",
                    Int::class.java, orderId,
                ),
            )

            // Relay publishes -> in-process listener applies facts exactly once.
            relay.relay()

            assertEquals(
                0,
                jdbc.queryForObject(
                    "SELECT COUNT(*) FROM outbox_events WHERE aggregate_id = ? AND status = 'PENDING'",
                    Int::class.java, orderId,
                ),
            )
            val facts = jdbc.queryForMap(
                "SELECT qty FROM sales_daily_facts WHERE day = ? AND branch_id = ? AND variant_id = ?",
                day, branchId, variantId,
            )
            assertEquals(1, (facts["qty"] as Number).toInt())

            // Second relay run finds nothing due — no republish, no double facts.
            relay.relay()
            val facts2 = jdbc.queryForMap(
                "SELECT qty FROM sales_daily_facts WHERE day = ? AND branch_id = ? AND variant_id = ?",
                day, branchId, variantId,
            )
            assertEquals(1, (facts2["qty"] as Number).toInt())
        } finally {
            val notificationId = jdbc.query(
                "SELECT id FROM notification_outbox WHERE ref = ?",
                { rs, _ -> rs.getObject("id") as UUID? },
                "order-receipt:$orderId",
            ).firstOrNull()
            if (notificationId != null) {
                jdbc.update("DELETE FROM notification_translations WHERE notification_id = ?", notificationId)
                jdbc.update("DELETE FROM notification_outbox WHERE id = ?", notificationId)
            }
            jdbc.update("DELETE FROM outbox_events WHERE aggregate_id = ?", orderId)
            if (eventId != null) {
                jdbc.update("DELETE FROM consumer_processed_events WHERE event_id = ?", eventId)
            }
            jdbc.update("DELETE FROM sales_daily_facts WHERE branch_id = ?", branchId)
            jdbc.update("DELETE FROM product_variants WHERE id = ?", variantId)
            jdbc.update("DELETE FROM products WHERE id = ?", productId)
            jdbc.update("DELETE FROM product_categories WHERE id = ?", categoryId)
            jdbc.update("DELETE FROM branches WHERE id = ?", branchId)
        }
    }
}
