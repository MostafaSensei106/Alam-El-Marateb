package com.mostafasensei.alamelmarateb.modules.security.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.util.UUID

@Entity
@Table(name = "branches")
class BranchJpaEntity (
    @Column(name = "name", nullable = false, length = 150)
    var name: String = "",

    @Column(name = "code", nullable = false, unique = true, length = 50)
    var code: String = "",

    @Column(name = "phone", length = 20)
    var phone: String = "",

    @Column(name = "city", nullable = false, length = 100)
    var city: String = "Tanta",

    @Column(name = "is_active", nullable = false)
    var isActive: Boolean = true,
) : EntityBase<UUID>()