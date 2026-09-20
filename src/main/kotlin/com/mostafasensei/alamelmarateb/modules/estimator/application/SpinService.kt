package com.mostafasensei.alamelmarateb.modules.estimator.application

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.core.exceptions.UnprocessableException
import com.mostafasensei.alamelmarateb.modules.estimator.data.repository.SpinCampaignRepository
import com.mostafasensei.alamelmarateb.modules.estimator.data.repository.SpinPlayRepository
import com.mostafasensei.alamelmarateb.modules.estimator.data.repository.SpinPrizeRepository
import com.mostafasensei.alamelmarateb.modules.estimator.domain.entity.SpinCampaignJpaEntity
import com.mostafasensei.alamelmarateb.modules.estimator.domain.entity.SpinPlayJpaEntity
import com.mostafasensei.alamelmarateb.modules.estimator.domain.entity.SpinPrizeJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductVariantRepository
import com.mostafasensei.alamelmarateb.modules.sales.application.PromotionInput
import com.mostafasensei.alamelmarateb.modules.sales.application.PromotionService
import com.mostafasensei.alamelmarateb.modules.sales.domain.promotion.PromoType
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.math.RoundingMode
import java.time.Instant
import java.time.LocalDateTime
import java.util.UUID
import kotlin.random.Random

data class CampaignView(
    val id: UUID?,
    val name: String,
    val startsAt: String?,
    val endsAt: String?,
    val isActive: Boolean,
    val spinsPerCustomer: Int,
    val prizes: List<PrizeView> = emptyList(),
)

data class PrizeView(
    val id: UUID?,
    val label: String,
    val kind: String,
    val value: BigDecimal,
    val giftVariantId: UUID?,
    val weight: Int,
    val maxWins: Int?,
    val winsLeft: Int?,
    val sortOrder: Int,
)

data class SpinResult(
    val campaignId: UUID?,
    val label: String,
    val won: Boolean,
    val promoCode: String?,
    val kind: String,
)

/**
 * Prize wheel: the manager defines up to 6 prizes per campaign with an
 * active window; each customer gets spins_per_customer spins (default 1).
 * Wins grant a single-use promo code (percent / fixed / gift variant).
 */
@Service
class SpinService(
    private val campaignRepository: SpinCampaignRepository,
    private val prizeRepository: SpinPrizeRepository,
    private val playRepository: SpinPlayRepository,
    private val promotionService: PromotionService,
    private val variantRepository: ProductVariantRepository,
) {

    // ---- management ----

    @Transactional
    fun createCampaign(
        name: String, startsAt: LocalDateTime?, endsAt: LocalDateTime?,
        isActive: Boolean, spinsPerCustomer: Int,
    ): CampaignView {
        if (name.isBlank()) throw BadRequestException("error.spin.name_required")
        if (spinsPerCustomer <= 0) throw BadRequestException("error.spin.bad_spins")
        if (startsAt != null && endsAt != null && !endsAt.isAfter(startsAt)) {
            throw BadRequestException("error.spin.bad_dates")
        }
        return toView(
            campaignRepository.save(
                SpinCampaignJpaEntity(
                    name = name.trim(),
                    startsAt = startsAt ?: LocalDateTime.now(),
                    endsAt = endsAt, isActive = isActive, spinsPerCustomer = spinsPerCustomer,
                ),
            ),
        )
    }

    @Transactional(readOnly = true)
    fun campaigns(): List<CampaignView> =
        campaignRepository.findAll().map { toView(it) }

    @Transactional
    fun toggleCampaign(id: UUID): CampaignView {
        val campaign = campaignRepository.findById(id)
            .orElseThrow { NotFoundException("error.spin.campaign_not_found") }
        campaign.isActive = !campaign.isActive
        return toView(campaignRepository.save(campaign))
    }

    @Transactional
    fun addPrize(
        campaignId: UUID, label: String, kind: String, value: BigDecimal?,
        giftVariantId: UUID?, weight: Int, maxWins: Int?, sortOrder: Int,
    ): PrizeView {
        campaignRepository.findById(campaignId)
            .orElseThrow { NotFoundException("error.spin.campaign_not_found") }
        if (label.isBlank()) throw BadRequestException("error.spin.name_required")
        if (prizeRepository.countByCampaignId(campaignId) >= 6) {
            throw ConflictException("error.spin.too_many_prizes")
        }
        if (weight <= 0) throw BadRequestException("error.spin.bad_weight")
        val upperKind = kind.trim().uppercase()
        if (upperKind !in setOf("PERCENT", "FIXED", "GIFT", "NONE")) {
            throw BadRequestException("error.catalog.invalid_type", listOf(kind))
        }
        val amount = (value ?: BigDecimal.ZERO).setScale(2, RoundingMode.HALF_EVEN)
        when (upperKind) {
            "PERCENT" -> if (amount <= BigDecimal.ZERO || amount > BigDecimal(100)) {
                throw BadRequestException("error.promo.percent_range")
            }
            "FIXED" -> if (amount <= BigDecimal.ZERO) throw BadRequestException("error.promo.amount_positive")
            "GIFT" -> {
                if (giftVariantId == null || variantRepository.findById(giftVariantId) == null) {
                    throw BadRequestException("error.promo.unknown_gift_variant")
                }
            }
        }
        return toPrizeView(
            prizeRepository.save(
                SpinPrizeJpaEntity(
                    campaignId = campaignId, label = label.trim(), kind = upperKind,
                    value = amount, giftVariantId = giftVariantId, weight = weight,
                    maxWins = maxWins, sortOrder = sortOrder,
                ),
            ),
        )
    }

    @Transactional
    fun deletePrize(id: UUID) {
        if (!prizeRepository.existsById(id)) throw NotFoundException("error.spin.prize_not_found")
        prizeRepository.deleteById(id)
    }

    // ---- customer spin ----

    @Transactional
    fun spin(userId: UUID, campaignId: UUID?, random: Random = Random.Default): SpinResult {
        val campaign = resolveCampaign(campaignId)
        val prizes = prizeRepository.findByCampaignIdOrderBySortOrderAsc(campaign.id!!)
        if (prizes.isEmpty()) throw UnprocessableException("error.spin.empty_campaign")
        if (playRepository.countByCampaignIdAndUserId(campaign.id!!, userId) >= campaign.spinsPerCustomer) {
            throw ConflictException("error.spin.already_played")
        }
        val available = prizes.filter { prize ->
            prize.maxWins == null || playRepository.countByPrizeIdAndWonTrue(prize.id!!) < prize.maxWins!!
        }
        if (available.isEmpty()) {
            playRepository.save(SpinPlayJpaEntity(campaignId = campaign.id, userId = userId, won = false))
            return SpinResult(campaign.id, "حظ أوفر المرة الجاية", false, null, "NONE")
        }
        val totalWeight = available.sumOf { it.weight }
        var roll = random.nextInt(totalWeight)
        var picked = available.last()
        for (prize in available) {
            if (roll < prize.weight) {
                picked = prize
                break
            }
            roll -= prize.weight
        }
        if (picked.kind == "NONE") {
            playRepository.save(
                SpinPlayJpaEntity(campaignId = campaign.id, userId = userId, prizeId = picked.id, won = false),
            )
            return SpinResult(campaign.id, picked.label, false, null, "NONE")
        }
        val code = "SPIN-${UUID.randomUUID().toString().replace("-", "").take(10).uppercase()}"
        grantPromo(code, picked)
        playRepository.save(
            SpinPlayJpaEntity(
                campaignId = campaign.id, userId = userId,
                prizeId = picked.id, won = true, promoCode = code,
            ),
        )
        return SpinResult(campaign.id, picked.label, true, code, picked.kind)
    }

    private fun resolveCampaign(campaignId: UUID?): SpinCampaignJpaEntity {
        if (campaignId != null) {
            val campaign = campaignRepository.findById(campaignId)
                .orElseThrow { NotFoundException("error.spin.campaign_not_found") }
            if (!campaign.isActive) throw ConflictException("error.spin.no_active_campaign")
            return campaign
        }
        val now = LocalDateTime.now()
        val active = campaignRepository.findByIsActiveTrueOrderByStartsAtDesc()
            .filter { !it.startsAt.isAfter(now) && (it.endsAt == null || it.endsAt!!.isAfter(now)) }
        if (active.isEmpty()) throw NotFoundException("error.spin.no_active_campaign")
        if (active.size > 1) throw ConflictException("error.spin.multiple_active")
        return active.single()
    }

    private fun grantPromo(code: String, prize: SpinPrizeJpaEntity) {
        val now = Instant.now()
        val ends = now.plusSeconds(30L * 24 * 3600)
        val input = when (prize.kind) {
            "PERCENT" -> PromotionInput(
                code = code, name = "Spin: ${prize.label}", type = PromoType.CART_PERCENT,
                valuePercent = prize.value, maxUses = 1, startsAt = now, endsAt = ends,
            )
            "FIXED" -> PromotionInput(
                code = code, name = "Spin: ${prize.label}", type = PromoType.CART_FIXED,
                valueAmount = prize.value, maxUses = 1, startsAt = now, endsAt = ends,
            )
            else -> PromotionInput(
                code = code, name = "Spin: ${prize.label}", type = PromoType.GIFT,
                giftVariantId = prize.giftVariantId, maxUses = 1, startsAt = now, endsAt = ends,
            )
        }
        promotionService.create(input)
    }

    private fun toView(e: SpinCampaignJpaEntity): CampaignView {
        val prizes = prizeRepository.findByCampaignIdOrderBySortOrderAsc(e.id!!).map { toPrizeView(it) }
        return CampaignView(
            e.id, e.name, e.startsAt.toString(), e.endsAt?.toString(),
            e.isActive, e.spinsPerCustomer, prizes,
        )
    }

    private fun toPrizeView(e: SpinPrizeJpaEntity): PrizeView {
        val winsLeft = e.maxWins?.let { max ->
            (max - playRepository.countByPrizeIdAndWonTrue(e.id!!).toInt()).coerceAtLeast(0)
        }
        return PrizeView(
            e.id, e.label, e.kind, e.value, e.giftVariantId,
            e.weight, e.maxWins, winsLeft, e.sortOrder,
        )
    }
}
