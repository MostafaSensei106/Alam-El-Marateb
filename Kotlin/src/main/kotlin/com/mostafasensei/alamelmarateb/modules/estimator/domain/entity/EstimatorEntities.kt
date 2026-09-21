package com.mostafasensei.alamelmarateb.modules.estimator.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.Table
import java.math.BigDecimal
import java.time.Instant
import java.time.LocalDateTime
import java.util.UUID

@Entity
@Table(name = "estimate_runs")
class EstimateRunJpaEntity(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UUID")
    var id: UUID? = null,

    @Column(name = "user_id", columnDefinition = "UUID")
    var userId: UUID? = null,

    @Column(name = "branch_id", columnDefinition = "UUID")
    var branchId: UUID? = null,

    @Column(name = "channel", nullable = false, length = 10)
    var channel: String = "shop",

    @Column(name = "input", nullable = false, columnDefinition = "JSONB")
    @org.hibernate.annotations.ColumnTransformer(write = "?::jsonb")
    var input: String = "{}",

    @Column(name = "result", nullable = false, columnDefinition = "JSONB")
    @org.hibernate.annotations.ColumnTransformer(write = "?::jsonb")
    var result: String = "{}",

    @Column(name = "created_at", nullable = false, updatable = false, insertable = false)
    var createdAt: Instant? = null,
)

@Entity
@Table(name = "spin_campaigns")
class SpinCampaignJpaEntity(
    @Column(name = "name", nullable = false, length = 150)
    var name: String = "",

    @Column(name = "starts_at", nullable = false)
    var startsAt: LocalDateTime = LocalDateTime.now(),

    @Column(name = "ends_at")
    var endsAt: LocalDateTime? = null,

    @Column(name = "is_active", nullable = false)
    var isActive: Boolean = true,

    @Column(name = "spins_per_customer", nullable = false)
    var spinsPerCustomer: Int = 1,
) : EntityBase<UUID>()

@Entity
@Table(name = "spin_prizes")
class SpinPrizeJpaEntity(
    @Column(name = "campaign_id", nullable = false, columnDefinition = "UUID")
    var campaignId: UUID? = null,

    @Column(name = "label", nullable = false, length = 150)
    var label: String = "",

    @Column(name = "kind", nullable = false, length = 20)
    var kind: String = "NONE",

    @Column(name = "value", nullable = false, precision = 12, scale = 2)
    var value: BigDecimal = BigDecimal.ZERO,

    @Column(name = "gift_variant_id", columnDefinition = "UUID")
    var giftVariantId: UUID? = null,

    @Column(name = "weight", nullable = false)
    var weight: Int = 1,

    @Column(name = "max_wins")
    var maxWins: Int? = null,

    @Column(name = "sort_order", nullable = false)
    var sortOrder: Int = 0,
) : EntityBase<UUID>()

@Entity
@Table(name = "spin_plays")
class SpinPlayJpaEntity(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UUID")
    var id: UUID? = null,

    @Column(name = "campaign_id", nullable = false, columnDefinition = "UUID")
    var campaignId: UUID? = null,

    @Column(name = "user_id", nullable = false, columnDefinition = "UUID")
    var userId: UUID? = null,

    @Column(name = "prize_id", columnDefinition = "UUID")
    var prizeId: UUID? = null,

    @Column(name = "won", nullable = false)
    var won: Boolean = false,

    @Column(name = "promo_code", length = 60)
    var promoCode: String? = null,

    @Column(name = "created_at", nullable = false, updatable = false, insertable = false)
    var createdAt: Instant? = null,
)
