package com.mostafasensei.alamelmarateb.modules.security.data.repository

import com.mostafasensei.alamelmarateb.modules.security.domain.entity.BranchJpaEntity
import com.mostafasensei.alamelmarateb.modules.security.domain.entity.RoleJpaEntity
import com.mostafasensei.alamelmarateb.modules.security.domain.entity.UserJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional

@Repository
interface SpringDataJpaUserRepository : JpaRepository<BranchJpaEntity, Long> {
    fun findByPhoneNumber(phoneNumber: String): Optional<UserJpaEntity>
    fun findByEmail(email: String): Optional<UserJpaEntity>
    fun existsByPhoneNumber(phoneNumber: String): Boolean
    fun existsByEmail(email: String): Boolean
    fun findAllByBranchId(branchId: String): List<UserJpaEntity>
}

@Repository
interface SpringDataJpaRoleRepository : JpaRepository<RoleJpaEntity, Long> {
    fun findByName(name: String): Optional<RoleJpaEntity>
}