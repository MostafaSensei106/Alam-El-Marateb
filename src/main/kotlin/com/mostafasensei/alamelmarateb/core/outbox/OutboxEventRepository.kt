package com.mostafasensei.alamelmarateb.core.outbox

import org.springframework.data.domain.Pageable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.stereotype.Repository
import java.time.OffsetDateTime
import java.util.UUID

@Repository
interface OutboxEventRepository : JpaRepository<OutboxEventJpaEntity, UUID> {
    @Query(
        """
        SELECT e FROM OutboxEventJpaEntity e
        WHERE e.status = 'PENDING' AND e.nextAttemptAt <= :now
        ORDER BY e.createdAt ASC
        """,
    )
    fun findDue(now: OffsetDateTime, pageable: Pageable): List<OutboxEventJpaEntity>
}
