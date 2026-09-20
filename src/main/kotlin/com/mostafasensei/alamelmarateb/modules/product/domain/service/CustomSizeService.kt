package com.mostafasensei.alamelmarateb.modules.product.domain.service

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.product.data.repository.MeterPriceRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.OperatingBracketRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductRepository
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.MeterPriceJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.OperatingBracketJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.pricing.CustomQuote
import com.mostafasensei.alamelmarateb.modules.product.domain.pricing.CustomShape
import com.mostafasensei.alamelmarateb.modules.product.domain.pricing.CustomSizeEngine
import com.mostafasensei.alamelmarateb.modules.product.domain.pricing.CustomSizeEngine.Bracket
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.math.RoundingMode
import java.util.UUID

data class MeterPriceView(
    val id: UUID?,
    val productId: UUID?,
    val shape: String,
    val price: BigDecimal,
)

data class BracketView(
    val id: UUID?,
    val productId: UUID?,
    val widthFrom: Int,
    val widthTo: Int,
    val pct: Int,
)

/**
 * Variable pricing tables (no hardcoded ratios):
 * - meter price per (model, shape), falling back to the product's generic
 *   price_per_meter;
 * - operating brackets global, or per-model overrides when rows exist.
 */
@Service
class CustomSizeService(
    private val productRepository: ProductRepository,
    private val meterRepository: MeterPriceRepository,
    private val bracketRepository: OperatingBracketRepository,
) {

    @Transactional(readOnly = true)
    fun quoteByProduct(productId: UUID, shape: String, widthCm: Int, lengthCm: Int): CustomQuote {
        val product = productRepository.findById(productId)
            ?: throw NotFoundException("error.catalog.product_not_found")
        val parsed = CustomShape.parse(shape)
        val meter = meterRepository.findByProductIdAndShape(productId, parsed.name)
            .map { it.price }
            .orElse(product.pricePerMeter)
        return CustomSizeEngine.quote(shape, widthCm, lengthCm, meter, bracketsFor(productId))
    }

    @Transactional(readOnly = true)
    fun quoteBySlug(slug: String, shape: String, widthCm: Int, lengthCm: Int): CustomQuote {
        val product = productRepository.findBySlug(slug)
            ?: throw NotFoundException("error.catalog.product_not_found")
        return quoteByProduct(product.id!!, shape, widthCm, lengthCm)
    }

    @Transactional(readOnly = true)
    fun bracketsFor(productId: UUID): List<Bracket> {
        // Model rows overlay the global table: a model range wins for its own
        // span, every other width keeps falling back to the global table.
        val specific = bracketRepository.findByProductId(productId)
        if (specific.isEmpty()) {
            return bracketRepository.findByProductIdIsNull().map { Bracket(it.widthFrom, it.widthTo, it.pct) }
        }
        val global = bracketRepository.findByProductIdIsNull()
        return (specific + global).map { Bracket(it.widthFrom, it.widthTo, it.pct) }
    }

    // ---- meter prices (management) ----

    @Transactional(readOnly = true)
    fun meterPrices(productId: UUID): List<MeterPriceView> {
        productRepository.findById(productId)
            ?: throw NotFoundException("error.catalog.product_not_found")
        return meterRepository.findByProductId(productId).map { toMeterView(it) }
    }

    @Transactional
    fun setMeterPrice(productId: UUID, shape: String, price: BigDecimal): MeterPriceView {
        productRepository.findById(productId)
            ?: throw NotFoundException("error.catalog.product_not_found")
        val parsed = CustomShape.parse(shape)
        if (price <= BigDecimal.ZERO) throw BadRequestException("error.promo.amount_positive")
        val entity = meterRepository.findByProductIdAndShape(productId, parsed.name)
            .map { it.apply { this.price = price.scaled() } }
            .orElseGet {
                MeterPriceJpaEntity(productId = productId, shape = parsed.name, price = price.scaled())
            }
        return toMeterView(meterRepository.save(entity))
    }

    @Transactional
    fun deleteMeterPrice(id: UUID) {
        if (!meterRepository.existsById(id)) throw NotFoundException("error.pricing.meter_not_found")
        meterRepository.deleteById(id)
    }

    // ---- operating brackets (management) ----

    @Transactional(readOnly = true)
    fun brackets(productId: UUID?): List<BracketView> {
        val rows = if (productId != null) bracketRepository.findByProductId(productId)
        else bracketRepository.findByProductIdIsNull()
        return rows.map { toBracketView(it) }
    }

    @Transactional
    fun createBracket(productId: UUID?, widthFrom: Int, widthTo: Int, pct: Int): BracketView {
        if (productId != null) {
            productRepository.findById(productId)
                ?: throw NotFoundException("error.catalog.product_not_found")
        }
        validateBracket(widthFrom, widthTo, pct)
        return toBracketView(
            bracketRepository.save(
                OperatingBracketJpaEntity(
                    productId = productId, widthFrom = widthFrom, widthTo = widthTo, pct = pct,
                ),
            ),
        )
    }

    @Transactional
    fun updateBracket(id: UUID, widthFrom: Int?, widthTo: Int?, pct: Int?): BracketView {
        val entity = bracketRepository.findById(id)
            .orElseThrow { NotFoundException("error.pricing.bracket_not_found") }
        if (widthFrom != null) entity.widthFrom = widthFrom
        if (widthTo != null) entity.widthTo = widthTo
        if (pct != null) entity.pct = pct
        validateBracket(entity.widthFrom, entity.widthTo, entity.pct)
        return toBracketView(bracketRepository.save(entity))
    }

    @Transactional
    fun deleteBracket(id: UUID) {
        if (!bracketRepository.existsById(id)) throw NotFoundException("error.pricing.bracket_not_found")
        bracketRepository.deleteById(id)
    }

    private fun validateBracket(widthFrom: Int, widthTo: Int, pct: Int) {
        if (widthFrom <= 0 || widthTo <= 0 || widthFrom > widthTo) {
            throw BadRequestException("error.pricing.bad_range")
        }
        if (pct < 0 || pct > 100) throw BadRequestException("error.pricing.bad_pct")
    }

    private fun toMeterView(e: MeterPriceJpaEntity) = MeterPriceView(e.id, e.productId, e.shape, e.price)

    private fun toBracketView(e: OperatingBracketJpaEntity) =
        BracketView(e.id, e.productId, e.widthFrom, e.widthTo, e.pct)

    private fun BigDecimal.scaled(): BigDecimal = setScale(2, RoundingMode.HALF_EVEN)
}
