package com.mostafasensei.alamelmarateb.modules.product.domain.service

import com.mostafasensei.alamelmarateb.core.events.CatalogProductChangedEvent
import org.slf4j.LoggerFactory
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.stereotype.Component
import org.springframework.transaction.event.TransactionPhase
import org.springframework.transaction.event.TransactionalEventListener
import tools.jackson.databind.ObjectMapper
import tools.jackson.module.kotlin.readValue

/**
 * Consumes `catalog.product_changed` in both transports: in-process Spring
 * events (default) and the `catalog.product_changed` Kafka topic (group
 * `search`). Both funnel into [CatalogSearchIndexer.indexProduct], which
 * deduplicates — safe under redelivery and rebalances.
 */
@Component
class CatalogSearchListener(
    private val indexer: CatalogSearchIndexer,
) {

    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT, fallbackExecution = true)
    fun onProductChanged(event: CatalogProductChangedEvent) {
        indexer.indexProduct(event.productId, event.eventId)
    }
}

@Component
@ConditionalOnProperty(name = ["app.events.transport"], havingValue = "kafka")
class KafkaCatalogSearchConsumer(
    private val indexer: CatalogSearchIndexer,
    private val objectMapper: ObjectMapper,
) {

    private val log = LoggerFactory.getLogger(KafkaCatalogSearchConsumer::class.java)

    @KafkaListener(topics = ["catalog.product_changed"], groupId = "search")
    fun consume(record: String) {
        try {
            val event = objectMapper.readValue<CatalogProductChangedEvent>(record)
            indexer.indexProduct(event.productId, event.eventId)
        } catch (ex: Exception) {
            log.error("catalog.product_changed consume failed, will retry via Kafka: {}", ex.message)
            throw ex
        }
    }
}
