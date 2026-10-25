package com.mostafasensei.alamelmarateb.modules.security.data.repository

import com.mostafasensei.alamelmarateb.modules.security.data.models.User
import com.mostafasensei.alamelmarateb.modules.security.domain.entity.UserJpaEntity
import java.util.UUID

interface UserRepository {
    fun findById(id: UUID): User?
    fun findByPhoneNumber(phoneNumber: String): User?
    fun findByEmail(email: String): User?
    fun existsByPhoneNumber(phoneNumber: String): Boolean
    fun existsByEmail(email: String): Boolean
    fun save(user: User): User
    fun findAllByBranchId(branchId: UUID): List<User>
}