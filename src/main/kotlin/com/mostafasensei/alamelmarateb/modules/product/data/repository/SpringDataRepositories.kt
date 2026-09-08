package com.mostafasensei.alamelmarateb.modules.product.data.repository

import com.mostafasensei.alamelmarateb.modules.product.domain.entity.AttributeDefinitionJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductCategoryJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductPresetJpaEntity
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
interface SpringDataJpaProductPresetRepository : JpaRepository<ProductPresetJpaEntity, UUID> {
    fun findByCategoryId(categoryId: UUID): List<ProductPresetJpaEntity>
}
