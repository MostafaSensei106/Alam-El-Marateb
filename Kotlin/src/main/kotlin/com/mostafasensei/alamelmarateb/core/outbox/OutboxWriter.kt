package com.mostafasensei.alamelmarateb.core.outbox

import com.mostafasensei.alamelmarateb.core.events.CatalogProductChangedEvent
import com.mostafasensei.alamelmarateb.core.events.MediaUploadedEvent
import com.mostafasensei.alamelmarateb.core.events.OrderDeliveredEvent
import com.mostafasensei.alamelmarateb.core.events.OrderInvoicedEvent
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import tools.jackson.databind.ObjectMapper
import java.util.UUID

/**
 * Writes domain events into outbox_events in the caller's transaction
 * (Strategy: same-transaction guarantee today, Kafka envelope in Phase 2
 * without changing callers — they only know aggregate + type + object).
 */
@Service
class OutboxWriter(
    private val repository: OutboxEventRepository,
    private val objectMapper: ObjectMapper,
) {
    @Transactional
    fun emit(aggregateType: String, aggregateId: UUID?, type: String, event: Any) {
        repository.save(
            OutboxEventJpaEntity(
                aggregateType = aggregateType,
                aggregateId = aggregateId,
                type = type,
                payload = objectMapper.writeValueAsString(event),
            ),
        )
    }

    companion object {
        const val ORDER_INVOICED = "order.invoiced"
        const val ORDER_DELIVERED = "order.delivered"
        const val MEDIA_UPLOADED = "media.uploaded"
        const val CATALOG_PRODUCT_CHANGED = "catalog.product_changed"

        fun eventClass(type: String): Class<*> = when (type) {
            ORDER_INVOICED -> OrderInvoicedEvent::class.java
            ORDER_DELIVERED -> OrderDeliveredEvent::class.java
            MEDIA_UPLOADED -> MediaUploadedEvent::class.java
            CATALOG_PRODUCT_CHANGED -> CatalogProductChangedEvent::class.java
            else -> throw IllegalArgumentException("unknown outbox type: $type")
        }
    }
}
