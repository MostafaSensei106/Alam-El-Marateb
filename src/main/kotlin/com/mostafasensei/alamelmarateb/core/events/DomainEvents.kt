package com.mostafasensei.alamelmarateb.core.events

import java.math.BigDecimal
import java.time.LocalDate
import java.util.UUID

/**
 * Domain events spine (docs/modules/analytics.md 4, arch.md 5).
 *
 * Modules never call each other directly: sales publishes facts about what
 * happened, analytics (and later accounting) consume. Today the transport is
 * in-process Spring events with @TransactionalEventListener(AFTER_COMMIT) —
 * same transaction guarantees as an outbox (rollback => no event), zero new
 * infrastructure. When volume demands it, replace the publisher with Kafka
 * topics of the same names/shapes (docker-compose `kafka` profile is ready).
 */
data class InvoicedLine(
    val variantId: UUID,
    val qty: Int,
    /** Revenue share of this line (net after discounts + gift handling). */
    val net: BigDecimal,
    /** Unit cost at sale time (for profit facts). */
    val costPrice: BigDecimal,
)

data class OrderInvoicedEvent(
    val orderId: UUID,
    val branchId: UUID,
    val day: LocalDate,
    val lines: List<InvoicedLine>,
)
