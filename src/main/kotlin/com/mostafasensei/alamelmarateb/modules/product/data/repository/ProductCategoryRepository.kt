package com.mostafasensei.alamelmarateb.modules.product.data.repository

import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import java.util.UUID

interface ProductCategoryRepository {
    fun findById(id: UUID): ProductCategory?
    fun findBySlug(slug: String): ProductCategory?
    fun findAll(): List<ProductCategory>
    fun save(category: ProductCategory): ProductCategory
}
