package com.mostafasensei.alamelmarateb.modules.product.data.repository

import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductPreset
import java.util.UUID

interface ProductPresetRepository {
    fun findById(id: UUID): ProductPreset?
    fun findByCategoryId(categoryId: UUID): List<ProductPreset>
    fun findAll(): List<ProductPreset>
    fun save(preset: ProductPreset): ProductPreset
    fun deleteById(id: UUID)
}
