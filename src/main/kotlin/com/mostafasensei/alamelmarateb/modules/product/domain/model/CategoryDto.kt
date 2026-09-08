package com.mostafasensei.alamelmarateb.modules.product.domain.model

import java.util.UUID

data class CategoryCreateRequest(
    val name: String,
    val slug: String,
    val description: String? = null,
)

data class CategoryUpdateRequest(
    val name: String? = null,
    val description: String? = null,
    val isActive: Boolean? = null,
)

data class CategoryAttributeLinkRequest(
    val attributeId: UUID,
    val required: Boolean = false,
    val sortOrder: Int = 0,
)
