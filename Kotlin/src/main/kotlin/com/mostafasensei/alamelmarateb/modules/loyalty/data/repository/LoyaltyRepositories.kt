package com.mostafasensei.alamelmarateb.modules.loyalty.data.repository

import com.mostafasensei.alamelmarateb.modules.loyalty.domain.entity.LoyaltyAccountJpaEntity
import com.mostafasensei.alamelmarateb.modules.loyalty.domain.entity.LoyaltyLedgerJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface LoyaltyAccountRepository : JpaRepository<LoyaltyAccountJpaEntity, UUID>

@Repository
interface LoyaltyLedgerRepository : JpaRepository<LoyaltyLedgerJpaEntity, UUID> {
    fun findByUserIdOrderByCreatedAtDesc(userId: UUID): List<LoyaltyLedgerJpaEntity>
    fun existsByOrderIdAndReason(orderId: UUID, reason: String): Boolean
}
