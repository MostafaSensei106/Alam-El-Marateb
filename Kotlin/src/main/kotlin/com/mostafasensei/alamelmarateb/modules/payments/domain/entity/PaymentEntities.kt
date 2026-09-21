package com.mostafasensei.alamelmarateb.modules.payments.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.math.BigDecimal
import java.util.UUID

@Entity
@Table(name = "payment_intents")
class PaymentIntentJpaEntity(
    @Column(name = "order_id", nullable = false, columnDefinition = "UUID")
    var orderId: UUID? = null,

    @Column(name = "gateway", nullable = false, length = 20)
    var gateway: String = "fake",

    @Column(name = "amount", nullable = false, precision = 12, scale = 2)
    var amount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "currency", nullable = false, length = 10)
    var currency: String = "EGP",

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "pending",

    @Column(name = "provider_ref", unique = true, length = 160)
    var providerRef: String? = null,

    @Column(name = "payload", nullable = false, columnDefinition = "JSONB")
    @org.hibernate.annotations.ColumnTransformer(write = "?::jsonb")
    var payload: String = "{}",
) : EntityBase<UUID>()
