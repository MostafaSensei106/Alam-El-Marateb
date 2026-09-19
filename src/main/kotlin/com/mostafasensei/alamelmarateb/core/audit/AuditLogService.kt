package com.mostafasensei.alamelmarateb.core.audit

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Propagation
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

@Repository
interface AuditLogRepository : JpaRepository<AuditLogJpaEntity, UUID> {
    fun findByEntityAndEntityIdOrderByCreatedAtDesc(entity: String, entityId: UUID): List<AuditLogJpaEntity>
}

/**
 * Cross-cutting "who did what" log. Lives in core so every module
 * can record without creating module cycles.
 * REQUIRES_NEW so the trail survives even if the outer tx rolls back.
 */
@Service
class AuditLogService(
    private val repository: AuditLogRepository,
) {
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    fun record(
        action: String,
        entity: String,
        entityId: UUID?,
        branchId: UUID? = null,
        actor: String? = null,
        details: String? = null,
    ) {
        repository.save(
            AuditLogJpaEntity(
                actor = actor, branchId = branchId, action = action,
                entity = entity, entityId = entityId, details = details,
            ),
        )
    }
}
