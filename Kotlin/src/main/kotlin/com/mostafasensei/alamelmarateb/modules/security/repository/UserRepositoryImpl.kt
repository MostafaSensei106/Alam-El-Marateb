package com.mostafasensei.alamelmarateb.modules.security.repository

import com.mostafasensei.alamelmarateb.modules.security.data.repository.SpringDataJpaUserRepository
import com.mostafasensei.alamelmarateb.modules.security.data.models.User
import com.mostafasensei.alamelmarateb.modules.security.data.repository.UserRepository
import com.mostafasensei.alamelmarateb.modules.security.domain.entity.UserJpaEntity
import org.springframework.data.repository.findByIdOrNull
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
class UserRepositoryImpl(
    private val jpaRepository: SpringDataJpaUserRepository
) : UserRepository {
    override fun findById(id: UUID): User? =
        jpaRepository.findByIdOrNull(id)?.toDomain()

    override fun findByPhoneNumber(phoneNumber: String): User? =
        jpaRepository.findByPhoneNumber(phoneNumber)
            .map { it.toDomain() }
            .orElse(null)

    override fun findByEmail(email: String): User? =
        jpaRepository.findByEmail(email)
            .map { it.toDomain() }
            .orElse(null)

    override fun existsByPhoneNumber(phoneNumber: String): Boolean =
        jpaRepository.existsByPhoneNumber(phoneNumber)

    override fun existsByEmail(email: String): Boolean =
        jpaRepository.existsByEmail(email)

    override fun save(user: User): User =
        jpaRepository.save(UserJpaEntity.fromDomain(user)).toDomain()

    override fun findAllByBranchId(branchId: UUID): List<User> =
        jpaRepository.findAllByBranchId(branchId).map { it.toDomain() }
}