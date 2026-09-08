package com.mostafasensei.alamelmarateb.modules.product.data.repository

import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductVariant
import java.util.UUID

interface ProductVariantRepository {
    fun findById(id: UUID): ProductVariant?
    fun findByBarcode(barcode: String): ProductVariant?
    fun save(variant: ProductVariant): ProductVariant
    fun deleteVariantById(id: UUID)
}
