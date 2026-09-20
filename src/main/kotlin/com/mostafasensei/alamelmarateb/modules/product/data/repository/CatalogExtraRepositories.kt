package com.mostafasensei.alamelmarateb.modules.product.data.repository

import com.mostafasensei.alamelmarateb.modules.product.domain.entity.BrandJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductQuestionJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductReviewJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.QuizOptionJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.QuizQuestionJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.RecommendationRunJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.VariantAttributeValueJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional
import java.util.UUID

@Repository
interface BrandRepository : JpaRepository<BrandJpaEntity, UUID> {
    fun findBySlug(slug: String): Optional<BrandJpaEntity>
    fun existsBySlug(slug: String): Boolean
    fun findAllByIsActiveTrueOrderBySortOrderAsc(): List<BrandJpaEntity>
}

@Repository
interface ProductReviewRepository : JpaRepository<ProductReviewJpaEntity, UUID> {
    fun findByProductIdAndStatusOrderByCreatedAtDesc(productId: UUID, status: String): List<ProductReviewJpaEntity>
    fun findByUserIdAndProductId(userId: UUID, productId: UUID): Optional<ProductReviewJpaEntity>
    fun findByUserIdOrderByCreatedAtDesc(userId: UUID): List<ProductReviewJpaEntity>
}

@Repository
interface ProductQuestionRepository : JpaRepository<ProductQuestionJpaEntity, UUID> {
    fun findByProductIdAndStatusOrderByCreatedAtDesc(productId: UUID, status: String): List<ProductQuestionJpaEntity>
}

@Repository
interface QuizQuestionRepository : JpaRepository<QuizQuestionJpaEntity, UUID> {
    fun findByIsActiveTrueOrderBySortOrderAsc(): List<QuizQuestionJpaEntity>
}

@Repository
interface QuizOptionRepository : JpaRepository<QuizOptionJpaEntity, UUID> {
    fun findByQuestionId(questionId: UUID): List<QuizOptionJpaEntity>
}

@Repository
interface RecommendationRunRepository : JpaRepository<RecommendationRunJpaEntity, UUID>

@Repository
interface VariantAttributeValueRepository : JpaRepository<VariantAttributeValueJpaEntity, UUID> {
    fun findByVariantId(variantId: UUID): List<VariantAttributeValueJpaEntity>
}
