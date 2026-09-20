package com.mostafasensei.alamelmarateb.modules.analytics.clickhouse

import com.mostafasensei.alamelmarateb.core.events.OrderInvoicedEvent
import com.mostafasensei.alamelmarateb.core.outbox.IdempotencyGuard
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.stereotype.Component
import org.springframework.transaction.event.TransactionPhase
import org.springframework.transaction.event.TransactionalEventListener

/**
 * Replicates invoice lines into ClickHouse `order_lines` (star schema for
 * heavy drilldowns). AFTER_COMMIT like the Postgres facts; failures are
 * swallowed inside the client — sales never break for analytics.
 * At-least-once safe via [IdempotencyGuard] (same event redelivered).
 */
@Component
@ConditionalOnProperty(name = ["app.clickhouse.enabled"], havingValue = "true")
class ClickHouseReplicator(
    private val clickHouse: ClickHouseClient,
    private val guard: IdempotencyGuard,
) {

    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT, fallbackExecution = true)
    fun onOrderInvoiced(event: OrderInvoicedEvent) {
        replicate(event)
    }

    /** Shared by the in-process listener and the Kafka consumer. */
    fun replicate(event: OrderInvoicedEvent) {
        if (!guard.claim(event.eventId, "clickhouse")) return
        clickHouse.insertJsonEachRow(
            "order_lines",
            event.lines.map { line ->
                mapOf(
                    "day" to event.day.toString(),
                    "order_id" to event.orderId.toString(),
                    "branch_id" to event.branchId.toString(),
                    "variant_id" to line.variantId.toString(),
                    "qty" to line.qty,
                    "net" to line.net.toPlainString(),
                    "cost" to line.costPrice.multiply(line.qty.toBigDecimal()).toPlainString(),
                )
            },
        )
    }
}
