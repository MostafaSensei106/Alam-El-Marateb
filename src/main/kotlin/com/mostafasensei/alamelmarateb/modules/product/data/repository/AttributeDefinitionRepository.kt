package com.mostafasensei.alamelmarateb.modules.product.data.repository

import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductAttributeDefinition
import java.util.UUID

interface AttributeDefinitionRepository {
    fun findById(id: UUID): ProductAttributeDefinition?
    fun findByKey(key: String): ProductAttributeDefinition?
    fun findAllActive(): List<ProductAttributeDefinition>
    fun save(definition: ProductAttributeDefinition): ProductAttributeDefinition
}
