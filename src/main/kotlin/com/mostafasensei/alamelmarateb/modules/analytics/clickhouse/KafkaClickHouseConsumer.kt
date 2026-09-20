package com.mostafasensei.alamelmarateb.modules.analytics.clickhouse

import com.mostafasensei.alamelmarateb.core.events.OrderInvoicedEvent
import org.slf4j.LoggerFactory
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.stereotype.Component
import tools.jackson.databind.ObjectMapper
import tools.jackson.module.kotlin.readValue

/**
 * Kafka transport consumer (group `clickhouse`). Active only when both
 * app.events.transport=kafka and the ClickHouse store is enabled.
 * Delegates to [ClickHouseReplicator.replicate], which deduplicates via
 * IdempotencyGuard; ClickHouse inserts themselves stay best-effort inside
 * the client — analytics never break sales.
 */
@Component
@ConditionalOnProperty(name = ["app.events.transport"], havingValue = "kafka")
@ConditionalOnProperty(name = ["app.clickhouse.enabled"], havingValue = "true")
class KafkaClickHouseConsumer(
    private val replicator: ClickHouseReplicator,
    private val objectMapper: ObjectMapper,
) {

    private val log = LoggerFactory.getLogger(KafkaClickHouseConsumer::class.java)

    @KafkaListener(topics = ["order.invoiced"], groupId = "clickhouse")
    fun consume(record: String) {
        try {
            replicator.replicate(objectMapper.readValue<OrderInvoicedEvent>(record))
        } catch (ex: Exception) {
            log.error("order.invoiced (clickhouse) consume failed, will retry via Kafka: {}", ex.message)
            throw ex
        }
    }
}
