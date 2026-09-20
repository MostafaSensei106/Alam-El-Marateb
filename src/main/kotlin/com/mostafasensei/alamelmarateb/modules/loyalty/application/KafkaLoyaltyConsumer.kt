package com.mostafasensei.alamelmarateb.modules.loyalty.application

import com.mostafasensei.alamelmarateb.core.events.OrderDeliveredEvent
import org.slf4j.LoggerFactory
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.stereotype.Component
import tools.jackson.databind.ObjectMapper
import tools.jackson.module.kotlin.readValue

/**
 * Kafka transport consumer (group `loyalty`). Active only when
 * app.events.transport=kafka. Delegates to [LoyaltyService.awardFor],
 * which deduplicates via IdempotencyGuard + per-order ledger check,
 * so rebalances and redeliveries never double-award.
 */
@Component
@ConditionalOnProperty(name = ["app.events.transport"], havingValue = "kafka")
class KafkaLoyaltyConsumer(
    private val loyalty: LoyaltyService,
    private val objectMapper: ObjectMapper,
) {

    private val log = LoggerFactory.getLogger(KafkaLoyaltyConsumer::class.java)

    @KafkaListener(topics = ["order.delivered"], groupId = "loyalty")
    fun consume(record: String) {
        try {
            loyalty.awardFor(objectMapper.readValue<OrderDeliveredEvent>(record))
        } catch (ex: Exception) {
            log.error("order.delivered consume failed, will retry via Kafka: {}", ex.message)
            throw ex
        }
    }
}
