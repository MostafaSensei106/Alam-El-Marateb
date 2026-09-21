package com.mostafasensei.alamelmarateb.core.events

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.context.ApplicationEventPublisher
import org.springframework.kafka.core.KafkaTemplate
import org.springframework.stereotype.Component
import tools.jackson.databind.ObjectMapper

/**
 * Domain event transport (docs/modules/analytics.md §4).
 *
 * - `in-process` (default): Spring events + @TransactionalEventListener(AFTER_COMMIT).
 *   Same-transaction guarantees, zero infrastructure.
 * - `kafka`: JSON records on topics (see TOPICS); consumers join group
 *   `alamelmarateb`. Enable with EVENTS_TRANSPORT=kafka + broker at
 *   KAFKA_BOOTSTRAP (docker compose --profile kafka).
 */
interface DomainEventPublisher {
    fun publish(event: Any)
}

@Component
@ConditionalOnProperty(name = ["app.events.transport"], havingValue = "in-process", matchIfMissing = true)
class InProcessDomainEventPublisher(
    private val events: ApplicationEventPublisher,
) : DomainEventPublisher {
    override fun publish(event: Any) {
        events.publishEvent(event)
    }
}

@Component
@ConditionalOnProperty(name = ["app.events.transport"], havingValue = "kafka")
class KafkaDomainEventPublisher(
    private val kafka: KafkaTemplate<String, String>,
    private val objectMapper: ObjectMapper,
) : DomainEventPublisher {

    override fun publish(event: Any) {
        val topic = TOPICS[event::class] ?: "domain.events"
        // Key by aggregate so all events of one order land on one partition
        // (ordering per aggregate; consumers stay idempotent anyway).
        kafka.send(topic, routingKey(event), objectMapper.writeValueAsString(event))
    }

    companion object {
        val TOPICS: Map<kotlin.reflect.KClass<*>, String> = mapOf(
            OrderInvoicedEvent::class to "order.invoiced",
            OrderDeliveredEvent::class to "order.delivered",
            MediaUploadedEvent::class to "media.uploaded",
            CatalogProductChangedEvent::class to "catalog.product_changed",
        )

        fun routingKey(event: Any): String = when (event) {
            is OrderInvoicedEvent -> event.orderId.toString()
            is OrderDeliveredEvent -> event.orderId.toString()
            is MediaUploadedEvent -> event.productId.toString()
            is CatalogProductChangedEvent -> event.productId.toString()
            else -> event::class.simpleName ?: "event"
        }
    }
}
