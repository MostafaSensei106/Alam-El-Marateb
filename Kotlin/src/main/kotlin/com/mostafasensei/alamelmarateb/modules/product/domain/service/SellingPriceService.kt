package com.mostafasensei.alamelmarateb.modules.product.domain.service

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductVariantRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.SellingPriceRepository
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.SellingPriceJpaEntity
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.math.RoundingMode
import java.time.Instant
import java.util.UUID

object SalesChannels {
    const val PLATFORM = "PLATFORM"
    const val STAFF = "STAFF"
    const val DEALER = "DEALER"

    /** Order channel (pos/shop) -> price channel. */
    fun forOrder(orderChannel: String): String = when (orderChannel) {
        "shop" -> PLATFORM
        else -> STAFF
    }
}

data class SellingPriceView(
    val id: UUID?,
    val variantId: UUID?,
    val channel: String,
    val price: BigDecimal,
    val effectiveFrom: Instant,
)

@Service
class SellingPriceService(
    private val sellingPriceRepository: SellingPriceRepository,
    private val variantRepository: ProductVariantRepository,
) {
    @Transactional(readOnly = true)
    fun current(variantId: UUID, channel: String): BigDecimal {
        val now = Instant.now()
        val row = sellingPriceRepository
            .findByVariantIdAndChannelOrderByEffectiveFromDesc(variantId, channel)
            .firstOrNull { !it.effectiveFrom.isAfter(now) }
            ?: return variantRepository.findById(variantId)?.sellingPrice
            ?: throw NotFoundException("error.promo.unknown_variant", listOf(variantId))
        return row.price
    }

    @Transactional(readOnly = true)
    fun history(variantId: UUID, channel: String?): List<SellingPriceView> {
        val rows = if (channel == null) {
            sellingPriceRepository.findByVariantIdOrderByEffectiveFromDesc(variantId)
        } else {
            sellingPriceRepository.findByVariantIdAndChannelOrderByEffectiveFromDesc(variantId, channel)
        }
        return rows.map { toView(it) }
    }

    @Transactional
    fun setPrice(
        variantId: UUID,
        channel: String,
        price: BigDecimal,
        effectiveFrom: Instant = Instant.now(),
        by: String? = null,
    ): SellingPriceView {
        if (channel != SalesChannels.PLATFORM && channel != SalesChannels.STAFF && channel != SalesChannels.DEALER) {
            throw BadRequestException("error.pricing.unknown_channel", listOf(channel))
        }
        if (price.compareTo(BigDecimal.ZERO) < 0) throw BadRequestException("error.pricing.price_negative")
        variantRepository.findById(variantId)
            ?: throw NotFoundException("error.promo.unknown_variant", listOf(variantId))
        val saved = sellingPriceRepository.save(
            SellingPriceJpaEntity(
                variantId = variantId,
                channel = channel,
                price = price.setScale(2, RoundingMode.HALF_EVEN),
                effectiveFrom = effectiveFrom,
            ),
        )
        saved.createdBy = by
        return toView(saved)
    }

    private fun toView(e: SellingPriceJpaEntity) = SellingPriceView(
        id = e.id,
        variantId = e.variantId,
        channel = e.channel,
        price = e.price,
        effectiveFrom = e.effectiveFrom,
    )
}
