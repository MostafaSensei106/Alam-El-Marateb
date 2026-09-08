package com.mostafasensei.alamelmarateb.modules.product.data.repository

import com.mostafasensei.alamelmarateb.modules.product.domain.entity.AttributeDefinitionJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.AttributeOptionJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.CategoryAttributeJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.PresetAttributeValueJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductAttributeValueJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductCategoryJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductPresetJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductPresetVariantJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductVariantJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional
import java.util.UUID

@Repository
interface SpringDataJpaCategoryRepository : JpaRepository<ProductCategoryJpaEntity, UUID> {
    fun findBySlug(slug: String): Optional<ProductCategoryJpaEntity>
    fun existsBySlug(slug: String): Boolean
}

@Repository
interface SpringDataJpaAttributeDefinitionRepository : JpaRepository<AttributeDefinitionJpaEntity, UUID> {
    fun findByKey(key: String): Optional<AttributeDefinitionJpaEntity>
    fun findByIsActiveTrue(): List<AttributeDefinitionJpaEntity>
    fun existsByKey(key: String): Boolean
}

@Repository
interface SpringDataJpaAttributeOptionRepository : JpaRepository<AttributeOptionJpaEntity, UUID> {
    fun findByAttributeId(attributeId: UUID): List<AttributeOptionJpaEntity>
}

@Repository
interface SpringDataJpaCategoryAttributeRepository : JpaRepository<CategoryAttributeJpaEntity, UUID> {
    fun findByCategoryId(categoryId: UUID): List<CategoryAttributeJpaEntity>
}

@Repository
interface SpringDataJpaProductRepository : JpaRepository<ProductJpaEntity, UUID> {
    fun findBySlug(slug: String): Optional<ProductJpaEntity>
    fun existsBySlug(slug: String): Boolean
    fun findByCategoryId(categoryId: UUID): List<ProductJpaEntity>
    fun findByIsActiveTrue(): List<ProductJpaEntity>
}

@Repository
interface SpringDataJpaProductVariantRepository : JpaRepository<ProductVariantJpaEntity, UUID> {
    fun findByBarcode(barcode: String): Optional<ProductVariantJpaEntity>
    fun existsBySku(sku: String): Boolean
}

@Repository
interface SpringDataJpaProductAttributeValueRepository : JpaRepository<ProductAttributeValueJpaEntity, UUID> {
    fun findByProductId(productId: UUID): List<ProductAttributeValueJpaEntity>
}

@Repository
interface SpringDataJpaProductPresetRepository : JpaRepository<ProductPresetJpaEntity, UUID> {
    fun findByCategoryId(categoryId: UUID): List<ProductPresetJpaEntity>
}

@Repository
interface SpringDataJpaPresetAttributeValueRepository : JpaRepository<PresetAttributeValueJpaEntity, UUID> {
    fun findByPresetId(presetId: UUID): List<PresetAttributeValueJpaEntity>
}

@Repository
interface SpringDataJpaProductPresetVariantRepository : JpaRepository<ProductPresetVariantJpaEntity, UUID> {
    fun findByPresetId(presetId: UUID): List<ProductPresetVariantJpaEntity>
}
