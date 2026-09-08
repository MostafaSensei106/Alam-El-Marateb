package com.mostafasensei.alamelmarateb.modules.product.data.repository

import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductAttributeOption
import java.util.UUID

interface ProductAttributeOptionRepository {
    fun findById(id: UUID): ProductAttributeOption?
    fun findByAttributeId(attributeId: UUID): List<ProductAttributeOption>
    fun save(option: ProductAttributeOption): ProductAttributeOption
    fun deleteById(id: UUID)
}
