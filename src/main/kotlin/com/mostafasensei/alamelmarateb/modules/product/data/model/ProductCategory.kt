package com.mostafasensei.alamelmarateb.modules.product.data.model

import java.util.UUID
import kotlin.time.Clock
import kotlin.time.Instant

data class CategoryAttribute(
    val attribute: ProductAttributeDefinition,
    val required: Boolean = false,
    val sortOrder: Int = 0,
)

data class ProductCategory(
    val id: UUID? = null,
    val name: String,
    val slug: String,
    val description: String? = null,
    val isActive: Boolean = true,
    val attributes: List<CategoryAttribute> = emptyList(),
    val translations: Map<String, Map<String, String?>> = emptyMap(),
    val createdAt: Instant = Clock.System.now(),
    val updatedAt: Instant = Clock.System.now(),
)
