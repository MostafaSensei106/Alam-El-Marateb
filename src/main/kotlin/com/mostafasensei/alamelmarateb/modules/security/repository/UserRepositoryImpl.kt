package com.mostafasensei.alamelmarateb.modules.security.repository

import com.mostafasensei.alamelmarateb.modules.security.data.repository.SpringDataJpaUserRepository
import com.mostafasensei.alamelmarateb.modules.security.data.models.User
import com.mostafasensei.alamelmarateb.modules.security.data.repository.UserRepository
import com.mostafasensei.alamelmarateb.modules.security.domain.entity.UserJpaEntity
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
class UserRepositoryImpl(
    private val jpaRepository: SpringDataJpaUserRepository
) : UserRepository {
    override fun findById(id: UUID): Result<User>? {
        TODO("Not yet implemented")
    }

    override fun findByPhoneNumber(phoneNumber: String): Result<User>? {
        TODO("Not yet implemented")
    }

    override fun findByEmail(email: String): Result<User>? {
        TODO("Not yet implemented")
    }

    override fun existsByPhoneNumber(phoneNumber: String): Boolean {
        TODO("Not yet implemented")
    }

    override fun existsByEmail(email: String): Boolean {
        TODO("Not yet implemented")
    }

    override fun save(user: User): User {
        TODO("Not yet implemented")
    }

    override fun findAllByBranchId(branchId: UUID): Result<List<User>> {
        TODO("Not yet implemented")
    }
}