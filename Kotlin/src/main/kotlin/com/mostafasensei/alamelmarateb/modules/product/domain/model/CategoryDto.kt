package com.mostafasensei.alamelmarateb.modules.product.domain.model

import jakarta.validation.constraints.NotBlank
import java.util.UUID

data class CategoryCreateRequest(
    @field:NotBlank val name: String,
    @field:NotBlank val slug: String,
    val description: String? = null,
    val translations: Map<String, Map<String, String>>? = null,
)

data class CategoryUpdateRequest(
    val name: String? = null,
    val description: String? = null,
    val isActive: Boolean? = null,
    val translations: Map<String, Map<String, String>>? = null,
)

data class CategoryAttributeLinkRequest(
    val attributeId: UUID,
    val required: Boolean = false,
    val sortOrder: Int = 0,
)
