package com.mostafasensei.alamelmarateb.modules.auth.data.repository

import com.mostafasensei.alamelmarateb.modules.auth.domain.entity.RoleJpaEntity
import com.mostafasensei.alamelmarateb.modules.auth.domain.entity.UserJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional
import java.util.UUID

@Repository
interface SpringDataJpaUserRepository : JpaRepository<UserJpaEntity, UUID> {
    fun findByPhoneNumber(phoneNumber: String): Optional<UserJpaEntity>
    fun findByEmail(email: String): Optional<UserJpaEntity>
    fun existsByPhoneNumber(phoneNumber: String): Boolean
    fun existsByEmail(email: String): Boolean
    fun findAllByBranchId(branchId: UUID): List<UserJpaEntity>
}

@Repository
interface SpringDataJpaRoleRepository : JpaRepository<RoleJpaEntity, UUID> {
    fun findByName(name: String): Optional<RoleJpaEntity>
}