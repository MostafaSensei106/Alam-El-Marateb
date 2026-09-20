package com.mostafasensei.alamelmarateb.modules.notifications.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import jakarta.persistence.UniqueConstraint
import java.time.Instant
import java.util.UUID

@Entity
@Table(name = "notification_outbox")
class NotificationJpaEntity(
    @Column(name = "channel", nullable = false, length = 20)
    var channel: String = "log",

    @Column(name = "recipient", nullable = false, length = 80)
    var recipient: String = "",

    @Column(name = "ref", length = 120)
    var ref: String? = null,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "pending",

    @Column(name = "attempts", nullable = false)
    var attempts: Int = 0,

    @Column(name = "next_attempt_at")
    var nextAttemptAt: Instant? = null,

    @Column(name = "sent_at")
    var sentAt: Instant? = null,
) : EntityBase<UUID>()

@Entity
@Table(
    name = "notification_translations",
    uniqueConstraints = [UniqueConstraint(columnNames = ["notification_id", "lang"])],
)
class NotificationTranslationJpaEntity(
    @Column(name = "notification_id", nullable = false, columnDefinition = "UUID")
    var notificationId: UUID? = null,

    @Column(name = "lang", nullable = false, length = 10)
    var lang: String = "",

    @Column(name = "title", columnDefinition = "TEXT")
    var title: String? = null,

    @Column(name = "body", columnDefinition = "TEXT")
    var body: String? = null,
) : EntityBase<UUID>()
