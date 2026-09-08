package com.mostafasensei.alamelmarateb.modules.product.domain.model

data class AttributeDefinitionCreateRequest(
    val name: String,
    val key: String,
    val type: String,
    val options: List<AttributeOptionCreateRequest> = emptyList(),
)

data class AttributeOptionCreateRequest(
    val value: String,
    val label: String,
    val sortOrder: Int = 0,
)

data class AttributeDefinitionUpdateRequest(
    val name: String? = null,
    val key: String? = null,
    val type: String? = null,
    val isActive: Boolean? = null,
)

data class AddOptionRequest(
    val value: String,
    val label: String,
    val sortOrder: Int = 0,
)
