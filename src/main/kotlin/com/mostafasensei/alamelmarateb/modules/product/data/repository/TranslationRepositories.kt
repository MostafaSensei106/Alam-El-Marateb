package com.mostafasensei.alamelmarateb.modules.product.data.repository

import com.mostafasensei.alamelmarateb.modules.product.domain.entity.AttributeOptionTranslationJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.AttributeTranslationJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.BrandTranslationJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.CategoryTranslationJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductImageJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductTranslationJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface ProductTranslationRepository : JpaRepository<ProductTranslationJpaEntity, UUID> {
    fun findByProductId(productId: UUID): List<ProductTranslationJpaEntity>
    fun findByProductIdIn(productIds: Collection<UUID>): List<ProductTranslationJpaEntity>
    fun deleteByProductId(productId: UUID)
}

@Repository
interface CategoryTranslationRepository : JpaRepository<CategoryTranslationJpaEntity, UUID> {
    fun findByCategoryId(categoryId: UUID): List<CategoryTranslationJpaEntity>
    fun findByCategoryIdIn(categoryIds: Collection<UUID>): List<CategoryTranslationJpaEntity>
    fun deleteByCategoryId(categoryId: UUID)
}

@Repository
interface BrandTranslationRepository : JpaRepository<BrandTranslationJpaEntity, UUID> {
    fun findByBrandId(brandId: UUID): List<BrandTranslationJpaEntity>
    fun deleteByBrandId(brandId: UUID)
}

@Repository
interface AttributeTranslationRepository : JpaRepository<AttributeTranslationJpaEntity, UUID> {
    fun findByAttributeId(attributeId: UUID): List<AttributeTranslationJpaEntity>
    fun findByAttributeIdIn(attributeIds: Collection<UUID>): List<AttributeTranslationJpaEntity>
    fun deleteByAttributeId(attributeId: UUID)
}

@Repository
interface AttributeOptionTranslationRepository : JpaRepository<AttributeOptionTranslationJpaEntity, UUID> {
    fun findByOptionId(optionId: UUID): List<AttributeOptionTranslationJpaEntity>
    fun findByOptionIdIn(optionIds: Collection<UUID>): List<AttributeOptionTranslationJpaEntity>
    fun deleteByOptionId(optionId: UUID)
}

@Repository
interface ProductImageRepository : JpaRepository<ProductImageJpaEntity, UUID> {
    fun findByProductIdOrderBySortOrderAsc(productId: UUID): List<ProductImageJpaEntity>
    fun findByProductIdIn(productIds: Collection<UUID>): List<ProductImageJpaEntity>
}
