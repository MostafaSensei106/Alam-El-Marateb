package com.mostafasensei.alamelmarateb.core.outbox

import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Id
import jakarta.persistence.Table
import java.time.OffsetDateTime
import java.util.UUID

/**
 * Transactional outbox row (V28__outbox.sql).
 *
 * Written atomically with business data in the same DB transaction.
 * [OutboxRelay] publishes PENDING rows afterwards, so a broker outage
 * never loses an event — the row stays PENDING and is retried.
 */
@Entity
@Table(name = "outbox_events")
class OutboxEventJpaEntity(
    @Id
    @Column(name = "id", nullable = false, updatable = false)
    var id: UUID = UUID.randomUUID(),

    @Column(name = "aggregate_type", nullable = false)
    var aggregateType: String = "",

    @Column(name = "aggregate_id")
    var aggregateId: UUID? = null,

    @Column(name = "type", nullable = false)
    var type: String = "",

    @Column(name = "payload", nullable = false, columnDefinition = "jsonb")
    @org.hibernate.annotations.ColumnTransformer(write = "?::jsonb")
    var payload: String = "{}",

    @Column(name = "status", nullable = false)
    var status: String = "PENDING",

    @Column(name = "attempts", nullable = false)
    var attempts: Int = 0,

    @Column(name = "next_attempt_at", nullable = false)
    var nextAttemptAt: OffsetDateTime = OffsetDateTime.now(),

    @Column(name = "created_at", nullable = false, updatable = false)
    var createdAt: OffsetDateTime = OffsetDateTime.now(),

    @Column(name = "published_at")
    var publishedAt: OffsetDateTime? = null,

    @Column(name = "last_error", columnDefinition = "TEXT")
    var lastError: String? = null,
)
