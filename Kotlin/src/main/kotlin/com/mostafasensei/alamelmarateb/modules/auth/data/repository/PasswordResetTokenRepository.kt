package com.mostafasensei.alamelmarateb.modules.auth.data.repository

import com.mostafasensei.alamelmarateb.modules.auth.domain.entity.PasswordResetTokenJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional
import java.util.UUID

@Repository
interface PasswordResetTokenRepository : JpaRepository<PasswordResetTokenJpaEntity, UUID> {
    fun findByTokenHash(tokenHash: String): Optional<PasswordResetTokenJpaEntity>
    fun deleteByUserId(userId: UUID)
    fun deleteByUserIdAndIdNot(userId: UUID, id: UUID)
}
