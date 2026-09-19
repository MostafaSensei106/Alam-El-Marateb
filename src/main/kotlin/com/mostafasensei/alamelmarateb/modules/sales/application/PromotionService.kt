package com.mostafasensei.alamelmarateb.modules.sales.application

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
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
) {

    @Transactional
    fun create(input: PromotionInput): PromotionView {
        validate(input)
        val code = input.code.trim().uppercase()
        if (promotionRepository.existsByCode(code)) throw ConflictException("Promotion code exists: $code")
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
        return toView(promotionRepository.save(entity))
    }

    @Transactional(readOnly = true)
    fun listAll(): List<PromotionView> = promotionRepository.findAll().map { toView(it) }

    @Transactional
    fun toggle(id: UUID): PromotionView {
        val entity = promotionRepository.findById(id).orElseThrow { NotFoundException("Promotion not found") }
        entity.isActive = !entity.isActive
        return toView(promotionRepository.save(entity))
    }

    @Transactional(readOnly = true)
    fun preview(lines: List<PreviewLine>): PricePreview =
        PromotionEngine.calculate(lines, loadValid())

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
        if (items.isEmpty()) throw BadRequestException("Cart is empty")
        return items.map { (variantId, qty) ->
            if (qty <= 0) throw BadRequestException("Quantity must be positive")
            val variant = variantRepository.findById(variantId)
                ?: throw BadRequestException("Unknown variant: $variantId")
            val productId = variant.productId ?: throw BadRequestException("Variant has no product")
            PreviewLine(productId, variantId, qty, variant.sellingPrice)
        }
    }

    private fun loadValid(): List<Promotion> {
        val now = Instant.now()
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
        val errors = mutableListOf<String>()
        if (input.startsAt != null && input.endsAt != null && !input.endsAt.isAfter(input.startsAt)) {
            errors.add("endsAt must be after startsAt")
        }
        when (input.type) {
            PromoType.ITEM_PERCENT, PromoType.CART_PERCENT -> {
                val p = input.valuePercent
                if (p == null || p <= BigDecimal.ZERO || p > BigDecimal(100)) errors.add("valuePercent must be within (0, 100]")
            }
            PromoType.ITEM_FIXED, PromoType.CART_FIXED -> {
                if (input.valueAmount == null || input.valueAmount <= BigDecimal.ZERO) errors.add("valueAmount must be positive")
            }
            PromoType.BUNDLE_FIXED -> {
                if (input.bundlePrice == null || input.bundlePrice <= BigDecimal.ZERO) errors.add("bundlePrice must be positive")
                if (input.bundleItems.isEmpty()) errors.add("bundle needs items")
                if (input.bundleItems.any { it.productId == null && it.variantId == null }) errors.add("bundle items need product or variant")
            }
            PromoType.GIFT -> {
                if (input.giftVariantId == null && input.giftProductId == null) errors.add("gift needs a target")
                if (input.giftVariantId != null && variantRepository.findById(input.giftVariantId) == null) {
                    errors.add("unknown gift variant")
                }
            }
        }
        if ((input.type == PromoType.ITEM_PERCENT || input.type == PromoType.ITEM_FIXED) &&
            input.targetProductId == null && input.targetVariantId == null
        ) {
            errors.add("item promos need a target")
        }
        if (errors.isNotEmpty()) throw BadRequestException("Invalid promotion", errors)
    }

    private fun toView(e: PromotionJpaEntity) = PromotionView(
        e.id, e.code, e.name, PromoType.valueOf(e.promoType), e.isActive, e.exclusive,
    )
}
