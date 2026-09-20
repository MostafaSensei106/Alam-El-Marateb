package com.mostafasensei.alamelmarateb.modules.analytics.application

import com.mostafasensei.alamelmarateb.core.events.OrderInvoicedEvent
import org.slf4j.LoggerFactory
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.stereotype.Service
import org.springframework.transaction.event.TransactionPhase
import org.springframework.transaction.event.TransactionalEventListener
import java.time.LocalDate

/**
 * Builds `sales_daily_facts` incrementally from every invoice
 * (docs/database.md 10 — read-model, no strict FKs needed at write time).
 *
 * AFTER_COMMIT => a rolled-back sale never produces facts. Idempotent per
 * (day, branch, variant) upsert, so a redelivered event only accumulates
 * once per delivery... replays must therefore be de-duplicated upstream
 * (idempotency keys) — same rule Kafka consumers would follow.
 */
@Service
class SalesFactsUpdater(
    private val jdbc: JdbcTemplate,
) {

    private val log = LoggerFactory.getLogger(SalesFactsUpdater::class.java)

    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT)
    fun onOrderInvoiced(event: OrderInvoicedEvent) {
        val day: LocalDate = event.day
        event.lines.forEach { line ->
            val revenue = line.net
            val cost = line.costPrice.multiply(line.qty.toBigDecimal())
            val profit = revenue.subtract(cost)
            jdbc.update(
                """
                INSERT INTO sales_daily_facts (day, branch_id, variant_id, qty, revenue, cost, profit)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                ON CONFLICT (day, branch_id, variant_id) DO UPDATE SET
                    qty = sales_daily_facts.qty + EXCLUDED.qty,
                    revenue = sales_daily_facts.revenue + EXCLUDED.revenue,
                    cost = sales_daily_facts.cost + EXCLUDED.cost,
                    profit = sales_daily_facts.profit + EXCLUDED.profit
                """.trimIndent(),
                day, event.branchId, line.variantId, line.qty, revenue, cost, profit,
            )
        }
        log.debug("facts updated order={} lines={}", event.orderId, event.lines.size)
    }
}
