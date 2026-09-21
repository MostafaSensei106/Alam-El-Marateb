package com.mostafasensei.alamelmarateb.core.outbox

import com.mostafasensei.alamelmarateb.core.events.DomainEventPublisher
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty
import org.springframework.data.domain.PageRequest
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Component
import org.springframework.transaction.annotation.Transactional
import tools.jackson.databind.ObjectMapper
import java.time.OffsetDateTime

/**
 * Polls outbox_events and publishes due rows via [DomainEventPublisher].
 *
 * Phase 1: transport is in-process (or Kafka if enabled) — same publisher
 * the app already uses. Phase 2 only swaps the publisher/consumer side;
 * this relay stays unchanged.
 *
 * - Batch-bounded, best-effort: a failed row is retried with backoff and
 *   never blocks other rows.
 * - Business transactions are never held open by broker I/O.
 */
@Component
@ConditionalOnProperty(name = ["app.outbox.relay-enabled"], havingValue = "true", matchIfMissing = true)
class OutboxRelay(
    private val repository: OutboxEventRepository,
    private val publisher: DomainEventPublisher,
    private val objectMapper: ObjectMapper,
    @Value("\${app.outbox.batch-size:100}") private val batchSize: Int,
    @Value("\${app.outbox.max-attempts:10}") private val maxAttempts: Int,
) {
    private val log = LoggerFactory.getLogger(OutboxRelay::class.java)

    @Scheduled(fixedDelayString = "\${app.outbox.poll-delay-ms:2000}")
    @Transactional
    fun relay() {
        val due = repository.findDue(OffsetDateTime.now(), PageRequest.of(0, batchSize))
        if (due.isEmpty()) return
        for (row in due) {
            try {
                val event = objectMapper.readValue(row.payload, OutboxWriter.eventClass(row.type))
                // Published outside the business tx: broker down => row stays PENDING.
                publisher.publish(event)
                row.status = "PUBLISHED"
                row.publishedAt = OffsetDateTime.now()
            } catch (ex: Exception) {
                row.attempts += 1
                row.lastError = ex.message?.take(1000)
                val backoffSeconds = minOf(300, 5L shl minOf(row.attempts, 6))
                row.nextAttemptAt = OffsetDateTime.now().plusSeconds(backoffSeconds)
                if (row.attempts >= maxAttempts) row.status = "FAILED"
                log.warn("outbox publish failed id={} type={}: {}", row.id, row.type, ex.message)
            }
        }
        repository.saveAll(due)
    }
}
