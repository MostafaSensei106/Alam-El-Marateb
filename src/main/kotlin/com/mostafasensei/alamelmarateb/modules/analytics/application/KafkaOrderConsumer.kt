package com.mostafasensei.alamelmarateb.modules.analytics.application

import com.mostafasensei.alamelmarateb.core.events.OrderInvoicedEvent
import org.slf4j.LoggerFactory
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.stereotype.Component
import tools.jackson.databind.ObjectMapper
import tools.jackson.module.kotlin.readValue

/**
 * Kafka transport consumer (group `analytics`). Active only when
 * app.events.transport=kafka. Same upsert semantics as the in-process path.
 */
@Component
@ConditionalOnProperty(name = ["app.events.transport"], havingValue = "kafka")
class KafkaOrderInvoicedConsumer(
    private val updater: SalesFactsUpdater,
    private val objectMapper: ObjectMapper,
) {

    private val log = LoggerFactory.getLogger(KafkaOrderInvoicedConsumer::class.java)

    @KafkaListener(topics = ["order.invoiced"], groupId = "analytics")
    fun consume(record: String) {
        try {
            updater.apply(objectMapper.readValue<OrderInvoicedEvent>(record))
        } catch (ex: Exception) {
            log.error("order.invoiced consume failed, record skipped after logging: {}", ex.message)
            throw ex
        }
    }
}
