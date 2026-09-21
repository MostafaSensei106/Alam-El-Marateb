package com.mostafasensei.alamelmarateb.modules.notifications.data.repository

import com.mostafasensei.alamelmarateb.modules.notifications.domain.entity.NotificationJpaEntity
import com.mostafasensei.alamelmarateb.modules.notifications.domain.entity.NotificationTranslationJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.time.Instant
import java.util.UUID

@Repository
interface NotificationRepository : JpaRepository<NotificationJpaEntity, UUID> {
    fun findByStatusOrderByCreatedAtAsc(status: String): List<NotificationJpaEntity>

    fun existsByRecipientAndRefAndStatus(recipient: String, ref: String, status: String): Boolean
}

@Repository
interface NotificationTranslationRepository : JpaRepository<NotificationTranslationJpaEntity, UUID> {
    fun findByNotificationId(notificationId: UUID): List<NotificationTranslationJpaEntity>
}
