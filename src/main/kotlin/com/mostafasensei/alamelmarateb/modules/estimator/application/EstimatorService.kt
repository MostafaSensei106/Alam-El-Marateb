package com.mostafasensei.alamelmarateb.modules.estimator.application

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.estimator.data.repository.EstimateRunRepository
import com.mostafasensei.alamelmarateb.modules.estimator.domain.entity.EstimateRunJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.pricing.CustomQuote
import com.mostafasensei.alamelmarateb.modules.product.domain.service.CustomSizeService
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import com.mostafasensei.alamelmarateb.modules.sales.application.ShippingRates
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import tools.jackson.databind.ObjectMapper
import java.math.BigDecimal
import java.math.RoundingMode
import java.util.UUID

data class EstimatorModel(
    val productId: UUID?,
    val name: String,
    val slug: String,
    val brand: String,
    val categoryId: UUID,
    val pricePerMeter: BigDecimal?,
    val hasMeterPrice: Boolean,
    val heightsCm: List<Int>,
)

data class EstimateBreakdown(
    val mattressTotal: BigDecimal,
    val areaM2: BigDecimal,
    val operatingPct: Int,
    val shape: String,
    val widthCm: Int,
    val lengthCm: Int,
    val deliveryFee: BigDecimal,
    val carryUpFee: BigDecimal,
    val grandTotal: BigDecimal,
    val skuSuggestion: String,
)

@Service
class EstimatorService(
    private val catalogService: ProductCatalogService,
    private val customSizeService: CustomSizeService,
    private val shippingRates: ShippingRates,
    private val runRepository: EstimateRunRepository,
    private val objectMapper: ObjectMapper,
) {

    /**
     * Step 1: catalog details for the picker (models + available heights +
     * whether custom-size pricing is supported).
     */
    @Transactional(readOnly = true)
    fun catalog(categoryId: UUID? = null): List<EstimatorModel> {
        val products = if (categoryId != null) catalogService.getProductsByCategory(categoryId)
        else catalogService.getAllProducts()
        return products.map { p ->
            EstimatorModel(
                productId = p.id,
                name = p.name,
                slug = p.slug,
                brand = p.brand,
                categoryId = p.categoryId,
                pricePerMeter = p.pricePerMeter,
                hasMeterPrice = p.pricePerMeter != null && p.pricePerMeter > BigDecimal.ZERO,
                heightsCm = p.variants.map { it.heightCm }.distinct().sorted(),
            )
        }
    }

    /**
     * Steps 2+3: price a concrete configuration automatically —
     * mattress (geometry + operating %) + shipping + carry-up = grand total.
     * Works for storefront (channel=shop) and in-store staff (channel=pos).
     */
    @Transactional
    fun quote(
        userId: UUID?,
        branchId: UUID?,
        channel: String,
        productId: UUID,
        shape: String,
        widthCm: Int,
        lengthCm: Int,
        heightCm: Int?,
        governorate: String?,
        area: String?,
        floor: Int?,
        qty: Int,
    ): EstimateBreakdown {
        val useChannel = if (channel == "pos") "pos" else "shop"
        if (qty <= 0) throw BadRequestException("error.cart.qty_positive")
        val quote: CustomQuote = customSizeService.quoteByProduct(productId, shape, widthCm, lengthCm)
        val height = (heightCm?.takeIf { it > 0 }) ?: 25
        val mattressTotal = quote.total.multiply(qty.toBigDecimal()).scaled()

        var deliveryFee = BigDecimal.ZERO
        var carryUpFee = BigDecimal.ZERO
        if (!governorate.isNullOrBlank() && !area.isNullOrBlank()) {
            val zoneId = shippingRates.zoneId(governorate, area)
            deliveryFee = shippingRates.zoneFee(zoneId)
            carryUpFee = shippingRates.carryFee(floor)
        }
        val grand = mattressTotal.add(deliveryFee).add(carryUpFee).scaled()
        val result = EstimateBreakdown(
            mattressTotal = mattressTotal,
            areaM2 = quote.areaM2,
            operatingPct = quote.operatingPct,
            shape = quote.shape.name,
            widthCm = widthCm,
            lengthCm = lengthCm,
            deliveryFee = deliveryFee.scaled(),
            carryUpFee = carryUpFee.scaled(),
            grandTotal = grand,
            skuSuggestion = "EST-${productId.toString().take(8).uppercase()}-${widthCm}X${lengthCm}X$height",
        )
        runRepository.save(
            EstimateRunJpaEntity(
                userId = userId, branchId = branchId, channel = useChannel,
                input = objectMapper.writeValueAsString(
                    mapOf(
                        "productId" to productId, "shape" to shape, "widthCm" to widthCm,
                        "lengthCm" to lengthCm, "heightCm" to height, "qty" to qty,
                        "governorate" to governorate, "area" to area, "floor" to floor,
                    ),
                ),
                result = objectMapper.writeValueAsString(result),
            ),
        )
        return result
    }

    private fun BigDecimal.scaled(): BigDecimal = setScale(2, RoundingMode.HALF_EVEN)
}
