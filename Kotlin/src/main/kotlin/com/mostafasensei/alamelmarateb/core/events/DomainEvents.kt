package com.mostafasensei.alamelmarateb.core.events

import java.math.BigDecimal
import java.time.LocalDate
import java.time.OffsetDateTime
import java.util.UUID

/**
 * Domain events spine (docs/modules/analytics.md 4, arch.md 5).
 *
 * Modules never call each other directly: sales publishes facts about what
 * happened, analytics (and later accounting) consume. Delivery is
 * at-least-once (outbox relay + Kafka), so every event carries a stable
 * [eventId] and every consumer deduplicates via `consumer_processed_events`
 * (see core/outbox/IdempotencyGuard) — never rely on "exactly once".
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
    val eventId: UUID = UUID.randomUUID(),
    val occurredAt: OffsetDateTime = OffsetDateTime.now(),
)

data class OrderDeliveredEvent(
    val orderId: UUID,
    val customerId: UUID?,
    val grandTotal: BigDecimal,
    val eventId: UUID = UUID.randomUUID(),
    val occurredAt: OffsetDateTime = OffsetDateTime.now(),
)

/** Emitted when a product image lands in storage (future: search index, thumbnails). */
data class MediaUploadedEvent(
    val imageId: UUID,
    val productId: UUID,
    val url: String,
    val eventId: UUID = UUID.randomUUID(),
    val occurredAt: OffsetDateTime = OffsetDateTime.now(),
)

/** Emitted on any catalog mutation affecting search (product/variant create, update, delete). */
data class CatalogProductChangedEvent(
    val productId: UUID,
    val eventId: UUID = UUID.randomUUID(),
    val occurredAt: OffsetDateTime = OffsetDateTime.now(),
)
