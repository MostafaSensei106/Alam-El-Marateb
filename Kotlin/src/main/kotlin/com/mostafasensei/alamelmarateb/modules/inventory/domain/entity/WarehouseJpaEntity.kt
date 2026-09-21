package com.mostafasensei.alamelmarateb.modules.inventory.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.util.UUID

@Entity
@Table(name = "warehouses")
class WarehouseJpaEntity(
    @Column(name = "branch_id", columnDefinition = "UUID")
    var branchId: UUID? = null,

    @Column(name = "name", nullable = false, length = 150)
    var name: String = "",

    @Column(name = "code", nullable = false, unique = true, length = 50)
    var code: String = "",

    @Column(name = "is_active", nullable = false)
    var isActive: Boolean = true,
) : EntityBase<UUID>()
