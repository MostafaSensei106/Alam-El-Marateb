package com.mostafasensei.alamelmarateb.modules.product.domain.model

import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductVariant
import com.mostafasensei.alamelmarateb.modules.product.domain.extension.toResponse
import java.math.BigDecimal
import java.util.UUID

/**
 * Storefront-safe product shape (Phase: API contract hardening).
 *
 * Public/customer endpoints must never leak backoffice fields:
 * - no `costPrice` (margin data),
 * - no `translations` map (names/descriptions are already resolved per X-Lang),
 * - same keys otherwise, so the frontend uses one model.
 */
data class ProductPublicResponse(
    val id: UUID?,
    val categoryId: UUID,
    val name: String,
    val slug: String,
    val brand: String,
    val description: String?,
    val warrantyYears: Int?,
    val attributes: List<ProductAttributeResponse>,
    val variants: List<ProductVariantPublicResponse>,
    val isActive: Boolean,
)

data class ProductVariantPublicResponse(
    val id: UUID?,
    val sku: String,
    val barcode: String?,
    val widthCm: Int,
    val lengthCm: Int,
    val heightCm: Int,
    val sellingPrice: BigDecimal,
    val isActive: Boolean,
)

fun ProductVariant.toPublic(): ProductVariantPublicResponse =
    ProductVariantPublicResponse(
        id = id, sku = sku, barcode = barcode,
        widthCm = widthCm, lengthCm = lengthCm, heightCm = heightCm,
        sellingPrice = sellingPrice, isActive = isActive,
    )

fun Product.toPublic(): ProductPublicResponse =
    ProductPublicResponse(
        id = id, categoryId = categoryId, name = name, slug = slug, brand = brand,
        description = description, warrantyYears = warrantyYears,
        attributes = attributes.map { it.toResponse() },
        variants = variants.map { it.toPublic() },
        isActive = isActive,
    )
