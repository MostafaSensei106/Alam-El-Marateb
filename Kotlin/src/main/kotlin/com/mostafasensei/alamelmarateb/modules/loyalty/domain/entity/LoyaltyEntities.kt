package com.mostafasensei.alamelmarateb.modules.loyalty.domain.entity

import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Id
import jakarta.persistence.Table
import jakarta.persistence.Version
import java.time.Instant
import java.util.UUID

@Entity
@Table(name = "loyalty_accounts")
class LoyaltyAccountJpaEntity(
    @Id
    @Column(name = "user_id", nullable = false, columnDefinition = "UUID")
    var userId: UUID? = null,

    @Column(name = "points", nullable = false)
    var points: Int = 0,

    @Column(name = "lifetime_earned", nullable = false)
    var lifetimeEarned: Int = 0,

    @Column(name = "created_at", nullable = false, updatable = false, insertable = false)
    var createdAt: Instant? = null,

    @Column(name = "updated_at", nullable = false, updatable = false, insertable = false)
    var updatedAt: Instant? = null,

    @Version
    @Column(name = "version", nullable = false)
    var version: Long = 0,
)

@Entity
@Table(name = "loyalty_ledger")
class LoyaltyLedgerJpaEntity(
    @Id
    @jakarta.persistence.GeneratedValue(strategy = jakarta.persistence.GenerationType.IDENTITY)
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UUID")
    var id: UUID? = null,

    @Column(name = "user_id", nullable = false, columnDefinition = "UUID")
    var userId: UUID? = null,

    @Column(name = "order_id", columnDefinition = "UUID")
    var orderId: UUID? = null,

    @Column(name = "delta", nullable = false)
    var delta: Int = 0,

    @Column(name = "reason", nullable = false, length = 40)
    var reason: String = "",

    @Column(name = "balance_after", nullable = false)
    var balanceAfter: Int = 0,

    @Column(name = "created_at", nullable = false, updatable = false, insertable = false)
    var createdAt: Instant? = null,
)
