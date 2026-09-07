package com.mostafasensei.alamelmarateb.modules.security.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import com.mostafasensei.alamelmarateb.modules.security.data.models.User
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.FetchType
import jakarta.persistence.JoinColumn
import jakarta.persistence.JoinTable
import jakarta.persistence.ManyToMany
import jakarta.persistence.Table
import java.util.UUID

@Entity
@Table(name = "users")
class UserJpaEntity(
    @Column(name = "branch_id", columnDefinition = "UUID")
    var branchId: UUID? = null,

    @Column(name = "full_name", nullable = false, length = 150)
    var fullName: String = "",

    @Column(name = "email", unique = true, length = 150)
    var email: String? = null,

    @Column(name = "phone_number", nullable = false, unique = true, length = 20)
    var phoneNumber: String = "",

    @Column(name = "password_hash", nullable = false, length = 255)
    var passwordHash: String = "",

    @Column(name = "is_active", nullable = false)
    var isActive: Boolean = true,

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "user_roles",
        joinColumns = [JoinColumn(name = "user_id")],
        inverseJoinColumns = [JoinColumn(name = "role_id")]
    )
    var roles: MutableSet<RoleJpaEntity> = mutableSetOf()
) : EntityBase<UUID>() {

    fun toDomain(): User =
        User(
            id = this.id,
            branchId = this.branchId,
            fullName = this.fullName,
            email = this.email,
            phoneNumber = this.phoneNumber,
            passwordHash = this.passwordHash,
            isActive = this.isActive,
            roles = this.roles.map { it.toDomain() }.toSet(),
            createdAt = this.createdAt,
            updatedAt = this.updatedAt
        )

    companion object {
        fun fromDomain(domain: User): UserJpaEntity {
            val entity = UserJpaEntity(
                branchId = domain.branchId,
                fullName = domain.fullName,
                email = domain.email,
                phoneNumber = domain.phoneNumber,
                passwordHash = domain.passwordHash,
                isActive = domain.isActive,
                roles = domain.roles.map { RoleJpaEntity.fromDomain(it) }.toMutableSet()
            )
            entity.id = domain.id
            return entity
        }
    }
}