package com.mostafasensei.alamelmarateb.core.outbox

import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Propagation
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

/**
 * Transport-level dedup for at-least-once delivery (Phase 2).
 *
 * Every consumer calls [claim] before applying an event. First claim wins
 * (INSERT ... ON CONFLICT DO NOTHING); redeliveries from outbox retries or
 * Kafka rebalances return false and must be skipped.
 *
 * REQUIRES_NEW so the claim commits even if the surrounding handler rolls
 * back — a poison event is still marked processed and won't loop forever.
 * (Business-level guards, e.g. loyalty's per-order ledger check, stay as a
 * second layer for same-order/different-event cases.)
 */
@Service
class IdempotencyGuard(
    private val jdbc: JdbcTemplate,
) {
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    fun claim(eventId: UUID, consumer: String): Boolean {
        val rows = jdbc.update(
            "INSERT INTO consumer_processed_events (consumer, event_id) VALUES (?, ?) ON CONFLICT DO NOTHING",
            consumer, eventId,
        )
        return rows == 1
    }
}
