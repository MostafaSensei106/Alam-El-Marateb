package com.mostafasensei.alamelmarateb.modules.product.domain.service

import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductRepository
import com.mostafasensei.alamelmarateb.modules.product.domain.pricing.CustomQuote
import com.mostafasensei.alamelmarateb.modules.product.domain.pricing.CustomSizeEngine
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

/**
 * Custom-size quoting (catalog P2 future): price by shape geometry plus the
 * width-driven operating surcharge. The product carries price_per_meter.
 */
@Service
class CustomSizeService(
    private val productRepository: ProductRepository,
) {

    @Transactional(readOnly = true)
    fun quoteByProduct(productId: UUID, shape: String, widthCm: Int, lengthCm: Int): CustomQuote {
        val product = productRepository.findById(productId)
            ?: throw NotFoundException("error.catalog.product_not_found")
        return CustomSizeEngine.quote(shape, widthCm, lengthCm, product.pricePerMeter)
    }

    @Transactional(readOnly = true)
    fun quoteBySlug(slug: String, shape: String, widthCm: Int, lengthCm: Int): CustomQuote {
        val product = productRepository.findBySlug(slug)
            ?: throw NotFoundException("error.catalog.product_not_found")
        return CustomSizeEngine.quote(shape, widthCm, lengthCm, product.pricePerMeter)
    }
}
