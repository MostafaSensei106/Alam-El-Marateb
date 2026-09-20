package com.mostafasensei.alamelmarateb.modules.product.domain.service

import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.core.exceptions.UnprocessableException
import com.mostafasensei.alamelmarateb.modules.product.data.repository.BrandRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductReviewRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.SpringDataJpaProductRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.SpringDataJpaProductVariantRepository
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.BrandJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductReviewJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.OrderRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

data class ReviewView(
    val id: UUID?,
    val productId: UUID?,
    val rating: Int,
    val title: String?,
    val body: String?,
    val verifiedPurchase: Boolean,
    val status: String,
    val helpfulCount: Int,
)

data class ReviewSummary(
    val average: Double,
    val count: Int,
)

@Service
class ReviewService(
    private val reviewRepository: ProductReviewRepository,
    private val productRepository: SpringDataJpaProductRepository,
    private val variantRepository: SpringDataJpaProductVariantRepository,
    private val orderRepository: OrderRepository,
) {

    @Transactional(readOnly = true)
    fun publicReviews(productId: UUID): Pair<List<ReviewView>, ReviewSummary> {
        productRepository.findById(productId)
            .orElseThrow { NotFoundException("error.catalog.product_not_found") }
        val approved = reviewRepository.findByProductIdAndStatusOrderByCreatedAtDesc(productId, "approved")
        val avg = if (approved.isEmpty()) 0.0 else approved.map { it.rating }.average()
        return approved.map { toView(it) } to ReviewSummary(avg, approved.size)
    }

    @Transactional
    fun submit(userId: UUID, productId: UUID, rating: Int, title: String?, body: String?): ReviewView {
        if (rating !in 1..5) throw UnprocessableException("error.review.rating_range")
        productRepository.findById(productId)
            .orElseThrow { NotFoundException("error.catalog.product_not_found") }
        if (reviewRepository.findByUserIdAndProductId(userId, productId).isPresent) {
            throw ConflictException("error.review.already_reviewed")
        }
        if (!hasDelivered(productId, userId)) {
            throw UnprocessableException("error.review.not_purchased")
        }
        val saved = reviewRepository.save(
            ProductReviewJpaEntity(
                productId = productId, userId = userId, rating = rating,
                title = title, body = body, verifiedPurchase = true, status = "pending",
            ),
        )
        return toView(saved)
    }

    @Transactional
    fun moderate(id: UUID, approve: Boolean): ReviewView {
        val entity = reviewRepository.findById(id)
            .orElseThrow { NotFoundException("error.review.not_found") }
        entity.status = if (approve) "approved" else "rejected"
        return toView(reviewRepository.save(entity))
    }

    @Transactional
    fun helpful(id: UUID): ReviewView {
        val entity = reviewRepository.findById(id)
            .orElseThrow { NotFoundException("error.review.not_found") }
        entity.helpfulCount += 1
        return toView(reviewRepository.save(entity))
    }

    @Transactional(readOnly = true)
    fun myReviews(userId: UUID): List<ReviewView> =
        reviewRepository.findByUserIdOrderByCreatedAtDesc(userId).map { toView(it) }

    private fun hasDelivered(productId: UUID, userId: UUID): Boolean {
        val variantIds = variantRepository.findAll()
            .filter { it.productId == productId }.mapNotNull { it.id }.toSet()
        if (variantIds.isEmpty()) return false
        return orderRepository.findByCustomerIdOrderByCreatedAtDesc(userId)
            .filter { it.status == "delivered" }
            .flatMap { it.lines.mapNotNull { line -> line.variantId } }
            .any { it in variantIds }
    }

    private fun toView(e: ProductReviewJpaEntity) = ReviewView(
        e.id, e.productId, e.rating, e.title, e.body, e.verifiedPurchase, e.status, e.helpfulCount,
    )
}

data class BrandView(
    val id: UUID?,
    val name: String,
    val slug: String,
    val logoUrl: String?,
    val description: String?,
    val sortOrder: Int,
    val isActive: Boolean,
)

@Service
class BrandService(
    private val brandRepository: BrandRepository,
) {

    @Transactional(readOnly = true)
    fun listAll(): List<BrandView> =
        brandRepository.findAll().sortedBy { it.sortOrder }.map { toView(it) }

    @Transactional(readOnly = true)
    fun listActive(): List<BrandView> =
        brandRepository.findAllByIsActiveTrueOrderBySortOrderAsc().map { toView(it) }

    @Transactional
    fun create(name: String, slug: String, logoUrl: String?, description: String?, sortOrder: Int): BrandView {
        val normalized = slug.trim().lowercase()
        if (brandRepository.existsBySlug(normalized)) {
            throw ConflictException("error.brand.slug_exists", listOf(slug))
        }
        return toView(
            brandRepository.save(
                BrandJpaEntity(name = name.trim(), slug = normalized, logoUrl = logoUrl, description = description, sortOrder = sortOrder),
            ),
        )
    }

    @Transactional
    fun update(id: UUID, name: String?, slug: String?, logoUrl: String?, description: String?, sortOrder: Int?, isActive: Boolean?): BrandView {
        val entity = brandRepository.findById(id)
            .orElseThrow { NotFoundException("error.brand.not_found") }
        if (name != null) entity.name = name.trim()
        if (slug != null) {
            val normalized = slug.trim().lowercase()
            if (normalized != entity.slug && brandRepository.existsBySlug(normalized)) {
                throw ConflictException("error.brand.slug_exists", listOf(slug))
            }
            entity.slug = normalized
        }
        if (logoUrl != null) entity.logoUrl = logoUrl
        if (description != null) entity.description = description
        if (sortOrder != null) entity.sortOrder = sortOrder
        if (isActive != null) entity.isActive = isActive
        return toView(brandRepository.save(entity))
    }

    @Transactional
    fun delete(id: UUID) {
        if (!brandRepository.existsById(id)) throw NotFoundException("error.brand.not_found")
        brandRepository.deleteById(id)
    }

    private fun toView(e: BrandJpaEntity) = BrandView(
        e.id, e.name, e.slug, e.logoUrl, e.description, e.sortOrder, e.isActive,
    )
}
