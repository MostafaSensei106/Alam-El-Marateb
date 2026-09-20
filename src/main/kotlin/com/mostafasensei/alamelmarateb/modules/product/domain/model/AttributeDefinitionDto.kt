package com.mostafasensei.alamelmarateb.modules.product.domain.model

import jakarta.validation.constraints.NotBlank

data class AttributeDefinitionCreateRequest(
    @field:NotBlank val name: String,
    @field:NotBlank val key: String,
    @field:NotBlank val type: String,
    val options: List<AttributeOptionCreateRequest> = emptyList(),
    val translations: Map<String, Map<String, String>>? = null,
)

data class AttributeOptionCreateRequest(
    @field:NotBlank val value: String,
    @field:NotBlank val label: String,
    val sortOrder: Int = 0,
    val translations: Map<String, Map<String, String>>? = null,
)

data class AttributeDefinitionUpdateRequest(
    val name: String? = null,
    val key: String? = null,
    val type: String? = null,
    val isActive: Boolean? = null,
    val translations: Map<String, Map<String, String>>? = null,
)

data class AddOptionRequest(
    @field:NotBlank val value: String,
    @field:NotBlank val label: String,
    val sortOrder: Int = 0,
    val translations: Map<String, Map<String, String>>? = null,
)
