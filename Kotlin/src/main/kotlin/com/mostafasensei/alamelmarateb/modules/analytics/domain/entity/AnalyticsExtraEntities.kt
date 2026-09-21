package com.mostafasensei.alamelmarateb.modules.analytics.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.util.UUID

@Entity
@Table(name = "inquiries")
class InquiryJpaEntity(
    @Column(name = "branch_id", columnDefinition = "UUID")
    var branchId: UUID? = null,

    @Column(name = "staff_id", columnDefinition = "UUID")
    var staffId: UUID? = null,

    @Column(name = "product_id", columnDefinition = "UUID")
    var productId: UUID? = null,

    @Column(name = "variant_id", columnDefinition = "UUID")
    var variantId: UUID? = null,

    @Column(name = "note", columnDefinition = "TEXT")
    var note: String? = null,

    @Column(name = "outcome", nullable = false, length = 30)
    var outcome: String = "just_asking",

    @Column(name = "customer_phone", length = 20)
    var customerPhone: String? = null,
) : EntityBase<UUID>()

@Entity
@Table(name = "app_events")
class AppEventJpaEntity(
    @Column(name = "type", nullable = false, length = 80)
    var type: String = "",

    @Column(name = "actor_id", columnDefinition = "UUID")
    var actorId: UUID? = null,

    @Column(name = "anonymous_id", length = 80)
    var anonymousId: String? = null,

    @Column(name = "payload", nullable = false, columnDefinition = "JSONB")
    @org.hibernate.annotations.ColumnTransformer(write = "?::jsonb")
    var payload: String = "{}",

    @Column(name = "created_at", nullable = false, updatable = false, insertable = false)
    var createdAt: java.time.Instant? = null,
) {
    @jakarta.persistence.Id
    @jakarta.persistence.GeneratedValue(strategy = jakarta.persistence.GenerationType.IDENTITY)
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UUID")
    var id: UUID? = null
}
