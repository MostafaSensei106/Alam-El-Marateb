package com.mostafasensei.alamelmarateb.modules.product.domain.service
import com.fasterxml.jackson.annotation.JsonIgnore

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
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
    val photos: List<String>,
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
    fun submit(userId: UUID, productId: UUID, rating: Int, title: String?, body: String?, photos: List<String>): ReviewView {
        if (rating !in 1..5) throw UnprocessableException("error.review.rating_range")
        if (photos.size > 5) throw BadRequestException("error.review.photo_limit")
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
                title = title, body = body, photoUrls = photos.joinToString(","),
                verifiedPurchase = true, status = "pending",
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
        e.id, e.productId, e.rating, e.title, e.body,
        e.photoUrls.split(",").map { it.trim() }.filter { it.isNotEmpty() },
        e.verifiedPurchase, e.status, e.helpfulCount,
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
    @get:JsonIgnore
    val translations: Map<String, Map<String, String?>> = emptyMap(),
)

@Service
class BrandService(
    private val brandRepository: BrandRepository,
    private val translations: TranslationService,
) {

    @Transactional(readOnly = true)
    fun listAll(): List<BrandView> =
        brandRepository.findAll().sortedBy { it.sortOrder }.map { resolve(it) }

    @Transactional(readOnly = true)
    fun listActive(): List<BrandView> =
        brandRepository.findAllByIsActiveTrueOrderBySortOrderAsc().map { resolve(it) }

    @Transactional
    fun create(
        name: String, slug: String, logoUrl: String?, description: String?, sortOrder: Int,
        translationsMap: Map<String, Map<String, String>>? = null,
    ): BrandView {
        val normalized = slug.trim().lowercase()
        if (brandRepository.existsBySlug(normalized)) {
            throw ConflictException("error.brand.slug_exists", listOf(slug))
        }
        val saved = brandRepository.save(
            BrandJpaEntity(name = name.trim(), slug = normalized, logoUrl = logoUrl, description = description, sortOrder = sortOrder),
        )
        translations.saveBrand(saved.id!!, translationsMap)
        return resolve(saved)
    }

    @Transactional
    fun update(
        id: UUID, name: String?, slug: String?, logoUrl: String?, description: String?, sortOrder: Int?, isActive: Boolean?,
        translationsMap: Map<String, Map<String, String>>? = null,
    ): BrandView {
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
        val saved = brandRepository.save(entity)
        if (translationsMap != null) translations.saveBrand(id, translationsMap)
        return resolve(saved)
    }

    @Transactional
    fun delete(id: UUID) {
        if (!brandRepository.existsById(id)) throw NotFoundException("error.brand.not_found")
        brandRepository.deleteById(id)
    }

    private fun resolve(e: BrandJpaEntity): BrandView {
        val map = translations.brandMap(e.id!!)
        return BrandView(
            e.id, translations.pick(e.name, map.mapValues { it.value["name"] }, "name"),
            e.slug, e.logoUrl,
            translations.pick(e.description, map.mapValues { it.value["description"] }, "description").ifBlank { null },
            e.sortOrder, e.isActive, map,
        )
    }
}
