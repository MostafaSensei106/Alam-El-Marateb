package com.mostafasensei.alamelmarateb.modules.payments.data.repository

import com.mostafasensei.alamelmarateb.modules.payments.domain.entity.PaymentIntentJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional
import java.util.UUID

@Repository
interface PaymentIntentRepository : JpaRepository<PaymentIntentJpaEntity, UUID> {
    fun findByProviderRef(providerRef: String): Optional<PaymentIntentJpaEntity>
    fun findByOrderIdOrderByCreatedAtDesc(orderId: UUID): List<PaymentIntentJpaEntity>
}
