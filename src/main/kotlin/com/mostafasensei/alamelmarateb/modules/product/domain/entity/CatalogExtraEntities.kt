package com.mostafasensei.alamelmarateb.modules.product.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.util.UUID

@Entity
@Table(name = "brands")
class BrandJpaEntity(
    @Column(name = "name", nullable = false, length = 120)
    var name: String = "",

    @Column(name = "slug", nullable = false, unique = true, length = 140)
    var slug: String = "",

    @Column(name = "logo_url", columnDefinition = "TEXT")
    var logoUrl: String? = null,

    @Column(name = "description", columnDefinition = "TEXT")
    var description: String? = null,

    @Column(name = "sort_order", nullable = false)
    var sortOrder: Int = 0,

    @Column(name = "is_active", nullable = false)
    var isActive: Boolean = true,
) : EntityBase<UUID>()

@Entity
@Table(name = "product_reviews")
class ProductReviewJpaEntity(
    @Column(name = "product_id", nullable = false, columnDefinition = "UUID")
    var productId: UUID? = null,

    @Column(name = "user_id", nullable = false, columnDefinition = "UUID")
    var userId: UUID? = null,

    @Column(name = "rating", nullable = false)
    var rating: Int = 5,

    @Column(name = "title", length = 150)
    var title: String? = null,

    @Column(name = "body", columnDefinition = "TEXT")
    var body: String? = null,

    @Column(name = "verified_purchase", nullable = false)
    var verifiedPurchase: Boolean = false,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "pending",

    @Column(name = "helpful_count", nullable = false)
    var helpfulCount: Int = 0,
) : EntityBase<UUID>()

@Entity
@Table(name = "quiz_questions")
class QuizQuestionJpaEntity(
    @Column(name = "sort_order", nullable = false)
    var sortOrder: Int = 0,

    @Column(name = "text_ar", nullable = false, columnDefinition = "TEXT")
    var textAr: String = "",

    @Column(name = "text_en", columnDefinition = "TEXT")
    var textEn: String? = null,

    @Column(name = "dimension", nullable = false, length = 30)
    var dimension: String = "",

    @Column(name = "is_active", nullable = false)
    var isActive: Boolean = true,
) : EntityBase<UUID>()

@Entity
@Table(name = "quiz_options")
class QuizOptionJpaEntity(
    @Column(name = "question_id", nullable = false, columnDefinition = "UUID")
    var questionId: UUID? = null,

    @Column(name = "label_ar", nullable = false, columnDefinition = "TEXT")
    var labelAr: String = "",

    @Column(name = "label_en", columnDefinition = "TEXT")
    var labelEn: String? = null,

    @Column(name = "scores", nullable = false, columnDefinition = "JSONB")
    var scores: String = "{}",
) : EntityBase<UUID>()

@Entity
@Table(name = "recommendation_runs")
class RecommendationRunJpaEntity(
    @jakarta.persistence.Id
    @jakarta.persistence.GeneratedValue(strategy = jakarta.persistence.GenerationType.IDENTITY)
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UUID")
    var id: UUID? = null,

    @Column(name = "user_id", columnDefinition = "UUID")
    var userId: UUID? = null,

    @Column(name = "answers", nullable = false, columnDefinition = "JSONB")
    var answers: String = "[]",

    @Column(name = "results", nullable = false, columnDefinition = "JSONB")
    var results: String = "[]",

    @Column(name = "created_at", nullable = false, updatable = false, insertable = false)
    var runAt: java.time.Instant? = null,
)

@Entity
@Table(name = "variant_attribute_values")
class VariantAttributeValueJpaEntity(
    @Column(name = "variant_id", nullable = false, columnDefinition = "UUID")
    var variantId: UUID? = null,

    @Column(name = "attribute_id", nullable = false, columnDefinition = "UUID")
    var attributeId: UUID? = null,

    @Column(name = "value_type", nullable = false, length = 20)
    var valueType: String = "TEXT",

    @Column(name = "value_text", columnDefinition = "TEXT")
    var valueText: String? = null,

    @Column(name = "value_number", precision = 19, scale = 4)
    var valueNumber: java.math.BigDecimal? = null,

    @Column(name = "value_boolean")
    var valueBoolean: Boolean? = null,

    @Column(name = "value_option_id", columnDefinition = "UUID")
    var valueOptionId: UUID? = null,
) : EntityBase<UUID>()
