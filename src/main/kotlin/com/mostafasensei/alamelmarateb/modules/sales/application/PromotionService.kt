package com.mostafasensei.alamelmarateb.modules.sales.application

import com.mostafasensei.alamelmarateb.core.cache.RedisCache
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.ErrorDetail
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.core.exceptions.UnprocessableException
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductVariantRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.PromotionBundleItemRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.PromotionRepository
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.PromotionBundleItemJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.PromotionJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.promotion.BundleRequirement
import com.mostafasensei.alamelmarateb.modules.sales.domain.promotion.PreviewLine
import com.mostafasensei.alamelmarateb.modules.sales.domain.promotion.PricePreview
import com.mostafasensei.alamelmarateb.modules.sales.domain.promotion.PromoType
import com.mostafasensei.alamelmarateb.modules.sales.domain.promotion.Promotion
import com.mostafasensei.alamelmarateb.modules.sales.domain.promotion.PromotionEngine
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.time.Duration
import java.time.Instant
import java.util.UUID

data class BundleItemInput(val productId: UUID?, val variantId: UUID?, val requiredQty: Int)

data class PromotionInput(
    val code: String,
    val name: String,
    val type: PromoType,
    val valuePercent: BigDecimal? = null,
    val valueAmount: BigDecimal? = null,
    val bundlePrice: BigDecimal? = null,
    val targetProductId: UUID? = null,
    val targetVariantId: UUID? = null,
    val bundleItems: List<BundleItemInput> = emptyList(),
    val giftVariantId: UUID? = null,
    val giftProductId: UUID? = null,
    val giftQty: Int = 1,
    val minCartTotal: BigDecimal? = null,
    val startsAt: Instant? = null,
    val endsAt: Instant? = null,
    val maxUses: Int? = null,
    val exclusive: Boolean = false,
)

data class PromotionView(
    val id: UUID?,
    val code: String,
    val name: String,
    val type: PromoType,
    val isActive: Boolean,
    val exclusive: Boolean,
)

@Service
class PromotionService(
    private val promotionRepository: PromotionRepository,
    private val bundleItemRepository: PromotionBundleItemRepository,
    private val variantRepository: ProductVariantRepository,
    private val cache: RedisCache,
) {

    companion object {
        private val PREVIEW_TTL: Duration = Duration.ofSeconds(60)
    }

    @Transactional
    fun create(input: PromotionInput): PromotionView {
        validate(input)
        val code = input.code.trim().uppercase()
        if (promotionRepository.existsByCode(code)) throw ConflictException("error.promo.code_exists", listOf(code))
        val entity = PromotionJpaEntity(
            code = code, name = input.name, promoType = input.type.name,
            valuePercent = input.valuePercent, valueAmount = input.valueAmount, bundlePrice = input.bundlePrice,
            targetProductId = input.targetProductId, targetVariantId = input.targetVariantId,
            minCartTotal = input.minCartTotal, startsAt = input.startsAt, endsAt = input.endsAt,
            maxUses = input.maxUses, exclusive = input.exclusive, isActive = true,
        )
        input.bundleItems.forEach { item ->
            entity.bundleItems.add(
                PromotionBundleItemJpaEntity(
                    promotion = entity, productId = item.productId,
                    variantId = item.variantId, requiredQty = item.requiredQty,
                ),
            )
        }
        if (input.type == PromoType.GIFT) {
            entity.bundleItems.add(
                PromotionBundleItemJpaEntity(
                    promotion = entity, productId = input.giftProductId,
                    variantId = input.giftVariantId, requiredQty = input.giftQty,
                ),
            )
        }
        val saved = toView(promotionRepository.save(entity))
        cache.evict("promo:valid")
        return saved
    }

    @Transactional(readOnly = true)
    fun listAll(): List<PromotionView> = promotionRepository.findAll().map { toView(it) }

    @Transactional
    fun toggle(id: UUID): PromotionView {
        val entity = promotionRepository.findById(id).orElseThrow { NotFoundException("error.promo.not_found") }
        entity.isActive = !entity.isActive
        val saved = toView(promotionRepository.save(entity))
        cache.evict("promo:valid")
        return saved
    }

    /**
     * Non-binding preview path may use a short-lived cached promo list
     * (price-preview is explicitly non-binding). The binding path
     * [priceAndConsume] always loads fresh so maxUses is exact.
     */
    @Transactional(readOnly = true)
    fun preview(lines: List<PreviewLine>): PricePreview =
        PromotionEngine.calculate(lines, cachedValid())

    /** Applies usage counters for codes the engine actually used. Returns the preview. */
    @Transactional
    fun priceAndConsume(lines: List<PreviewLine>): PricePreview {
        val preview = PromotionEngine.calculate(lines, loadValid())
        if (preview.appliedCodes.isNotEmpty()) {
            promotionRepository.findByIsActiveTrue()
                .filter { it.code in preview.appliedCodes }
                .forEach {
                    it.usedCount += 1
                    promotionRepository.save(it)
                }
        }
        return preview
    }

    fun resolveLines(items: List<Pair<UUID, Int>>): List<PreviewLine> {
        if (items.isEmpty()) throw UnprocessableException("error.promo.cart_empty")
        return items.map { (variantId, qty) ->
            if (qty <= 0) throw BadRequestException("error.promo.qty_positive")
            val variant = variantRepository.findById(variantId)
                ?: throw NotFoundException("error.promo.unknown_variant", listOf(variantId))
            val productId = variant.productId ?: throw UnprocessableException("error.promo.variant_no_product", listOf(variantId))
            PreviewLine(productId, variantId, qty, variant.sellingPrice)
        }
    }

    private fun cachedValid(): List<Promotion> =
        cache.getOrLoadList("promo:valid", PREVIEW_TTL, Promotion::class.java) { loadValid() }

    private fun loadValid(): List<Promotion> {        val now = Instant.now()
        val entities = promotionRepository.findByIsActiveTrue().filter { e ->
            (e.startsAt == null || !now.isBefore(e.startsAt)) &&
                (e.endsAt == null || !now.isAfter(e.endsAt)) &&
                (e.maxUses == null || e.usedCount < e.maxUses!!)
        }
        if (entities.isEmpty()) return emptyList()
        val rows = bundleItemRepository.findByPromotionIdIn(entities.mapNotNull { it.id }).groupBy { it.promotion!!.id }
        return entities.map { e ->
            val type = PromoType.valueOf(e.promoType)
            val own = rows[e.id].orEmpty()
            val gift = if (type == PromoType.GIFT) own.firstOrNull() else null
            Promotion(
                id = e.id, code = e.code, name = e.name, type = type,
                valuePercent = e.valuePercent, valueAmount = e.valueAmount, bundlePrice = e.bundlePrice,
                targetProductId = e.targetProductId, targetVariantId = e.targetVariantId,
                bundleItems = own.filter { type != PromoType.GIFT }
                    .map { BundleRequirement(it.productId, it.variantId, it.requiredQty) },
                giftVariantId = gift?.variantId, giftProductId = gift?.productId,
                giftQty = gift?.requiredQty ?: 1,
                giftUnitPrice = gift?.variantId?.let { variantRepository.findById(it)?.sellingPrice },
                minCartTotal = e.minCartTotal, exclusive = e.exclusive,
            )
        }
    }

    private fun validate(input: PromotionInput) {
        val errors = mutableListOf<ErrorDetail>()
        if (input.startsAt != null && input.endsAt != null && !input.endsAt.isAfter(input.startsAt)) {
            errors.add(ErrorDetail("error.promo.ends_after_starts"))
        }
        when (input.type) {
            PromoType.ITEM_PERCENT, PromoType.CART_PERCENT -> {
                val p = input.valuePercent
                if (p == null || p <= BigDecimal.ZERO || p > BigDecimal(100)) errors.add(ErrorDetail("error.promo.percent_range"))
            }
            PromoType.ITEM_FIXED, PromoType.CART_FIXED -> {
                if (input.valueAmount == null || input.valueAmount <= BigDecimal.ZERO) errors.add(ErrorDetail("error.promo.amount_positive"))
            }
            PromoType.BUNDLE_FIXED -> {
                if (input.bundlePrice == null || input.bundlePrice <= BigDecimal.ZERO) errors.add(ErrorDetail("error.promo.bundle_price_positive"))
                if (input.bundleItems.isEmpty()) errors.add(ErrorDetail("error.promo.bundle_needs_items"))
                if (input.bundleItems.any { it.productId == null && it.variantId == null }) errors.add(ErrorDetail("error.promo.bundle_item_target"))
            }
            PromoType.GIFT -> {
                if (input.giftVariantId == null && input.giftProductId == null) errors.add(ErrorDetail("error.promo.gift_needs_target"))
                if (input.giftVariantId != null && variantRepository.findById(input.giftVariantId) == null) {
                    errors.add(ErrorDetail("error.promo.unknown_gift_variant"))
                }
            }
        }
        if ((input.type == PromoType.ITEM_PERCENT || input.type == PromoType.ITEM_FIXED) &&
            input.targetProductId == null && input.targetVariantId == null
        ) {
            errors.add(ErrorDetail("error.promo.item_needs_target"))
        }
        if (errors.isNotEmpty()) throw BadRequestException("error.promo.invalid", errorDetails = errors)
    }

    private fun toView(e: PromotionJpaEntity) = PromotionView(
        e.id, e.code, e.name, PromoType.valueOf(e.promoType), e.isActive, e.exclusive,
    )
}
