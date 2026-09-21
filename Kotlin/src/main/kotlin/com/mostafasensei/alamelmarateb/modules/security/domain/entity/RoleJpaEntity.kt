package com.mostafasensei.alamelmarateb.modules.security.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import com.mostafasensei.alamelmarateb.modules.security.data.models.Role
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.util.UUID

@Entity
@Table(name = "roles")
class RoleJpaEntity(
    @Column(name = "name", nullable = false, unique = true, length = 50)
    var name: String = "",

    @Column(name = "description", length = 255)
    var description: String? = null
) : EntityBase<UUID>() {

    fun toDomain(): Role =
        Role(
            id = this.id,
            name = this.name,
            description = this.description
        )

    companion object {
        fun fromDomain(domain: Role): RoleJpaEntity {
            val entity = RoleJpaEntity(
                name = domain.name,
                description = domain.description
            )
            entity.id = domain.id
            return entity
        }
    }
}