package com.mostafasensei.alamelmarateb.modules.product.data.repository

import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductVariant
import java.util.UUID

interface ProductRepository {
    fun findById(id: UUID): Product?
    fun findBySlug(slug: String): Product?
    fun findAllActive(): List<Product>
    fun findByCategoryId(categoryId: UUID): List<Product>
    fun findVariantByBarcode(barcode: String): ProductVariant?
    fun findVariantById(variantId: UUID): ProductVariant?
    fun existsBySlug(slug: String): Boolean
    fun existsBySku(sku: String): Boolean
    fun save(product: Product): Product
    fun saveVariant(variant: ProductVariant): ProductVariant
    fun deleteVariantById(variantId: UUID)
    fun deleteById(id: UUID)
}