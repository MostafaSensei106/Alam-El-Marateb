package com.mostafasensei.alamelmarateb.modules.product.data.model
import com.fasterxml.jackson.annotation.JsonIgnore

import java.util.UUID
import kotlin.time.Clock
import kotlin.time.Instant

data class CategoryAttribute(
    val attribute: ProductAttributeDefinition,
    val required: Boolean = false,
    val sortOrder: Int = 0,
)

/**
 * Category aggregate as seen by the domain layer.
 *
 * Required: [id] (always assigned, never null), [name], [slug], [createdAt], [updatedAt].
 * Optional: [description], [translations]; [attributes] defaults to empty.
 */
data class ProductCategory(
    /** **Required.** Assigned at construction; identical to the persisted primary key. */
    val id: UUID = UUID.randomUUID(),
    /** **Required.** Display name. */
    val name: String,
    val slug: String,
    val description: String? = null,
    val isActive: Boolean = true,
    val attributes: List<CategoryAttribute> = emptyList(),
    @get:JsonIgnore
    val translations: Map<String, Map<String, String?>> = emptyMap(),
    val createdAt: Instant = Clock.System.now(),
    val updatedAt: Instant = Clock.System.now(),
)
