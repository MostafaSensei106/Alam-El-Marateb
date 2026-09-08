package com.mostafasensei.alamelmarateb.modules.product.domain.model

import java.util.UUID

data class ProductCategoryResponse(
    val id: UUID? = null,
    val name: String,
    val slug: String,
    val description: String? = null,
    val isActive: Boolean = true,
    val attributes: List<CategoryAttributeResponse> = emptyList(),
)

data class CategoryAttributeResponse(
    val attribute: ProductAttributeDefinitionResponse,
    val required: Boolean = false,
    val sortOrder: Int = 0,
)

data class ProductAttributeDefinitionResponse(
    val id: UUID? = null,
    val name: String,
    val key: String,
    val type: String,
    val options: List<ProductAttributeOptionResponse> = emptyList(),
    val isActive: Boolean = true,
)

data class ProductAttributeOptionResponse(
    val id: UUID? = null,
    val value: String,
    val label: String,
    val sortOrder: Int = 0,
)
