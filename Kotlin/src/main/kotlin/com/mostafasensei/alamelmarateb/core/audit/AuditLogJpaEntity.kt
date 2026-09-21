package com.mostafasensei.alamelmarateb.core.audit

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.util.UUID

@Entity
@Table(name = "audit_logs")
class AuditLogJpaEntity(
    @Column(name = "actor", length = 150)
    var actor: String? = null,

    @Column(name = "branch_id", columnDefinition = "UUID")
    var branchId: UUID? = null,

    @Column(name = "action", nullable = false, length = 100)
    var action: String = "",

    @Column(name = "entity", nullable = false, length = 100)
    var entity: String = "",

    @Column(name = "entity_id", columnDefinition = "UUID")
    var entityId: UUID? = null,

    @Column(name = "details", columnDefinition = "TEXT")
    var details: String? = null,
) : EntityBase<UUID>()
