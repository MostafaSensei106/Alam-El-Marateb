package com.mostafasensei.alamelmarateb.modules.product.data.repository

import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductAttributeDefinition
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductAttributeOption
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductPreset
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductVariant
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.AttributeDefinitionJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.AttributeOptionJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductCategoryJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductPresetJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductVariantJpaEntity
import org.springframework.stereotype.Repository
import java.util.UUID

/**
 * Port adapters: domain ports → Spring Data JPA.
 * IDs are DB-generated (gen_random_uuid); null ids on save mean "new".
 */
@Repository
class ProductRepositoryAdapter(
    private val jpa: SpringDataJpaProductRepository,
) : ProductRepository {
    override fun findById(id: UUID): Product? = jpa.findById(id).map { it.toDomain() }.orElse(null)
    override fun findBySlug(slug: String): Product? = jpa.findBySlug(slug).map { it.toDomain() }.orElse(null)
    override fun findAllActive(): List<Product> = jpa.findByIsActiveTrue().map { it.toDomain() }
    override fun findByCategoryId(categoryId: UUID): List<Product> = jpa.findByCategoryId(categoryId).map { it.toDomain() }
    override fun findVariantByBarcode(barcode: String): ProductVariant? = null
    override fun findVariantById(variantId: UUID): ProductVariant? = null
    override fun existsBySlug(slug: String): Boolean = jpa.existsBySlug(slug)
    override fun existsBySku(sku: String): Boolean = false
    override fun save(product: Product): Product = jpa.save(ProductJpaEntity.fromDomain(product)).toDomain()
    override fun saveVariant(variant: ProductVariant): ProductVariant = variant
    override fun deleteVariantById(variantId: UUID) = Unit
    override fun deleteById(id: UUID) = jpa.deleteById(id)
}

@Repository
class ProductVariantRepositoryAdapter(
    private val jpa: SpringDataJpaProductVariantRepository,
) : ProductVariantRepository {
    override fun findById(id: UUID): ProductVariant? = jpa.findById(id).map { it.toDomain() }.orElse(null)
    override fun findByBarcode(barcode: String): ProductVariant? = jpa.findByBarcode(barcode).map { it.toDomain() }.orElse(null)
    override fun save(variant: ProductVariant): ProductVariant =
        jpa.save(ProductVariantJpaEntity.fromDomain(variant)).toDomain()
    override fun deleteVariantById(variantId: UUID) = jpa.deleteById(variantId)
}

@Repository
class ProductCategoryRepositoryAdapter(
    private val jpa: SpringDataJpaCategoryRepository,
) : ProductCategoryRepository {
    override fun findById(id: UUID): ProductCategory? = jpa.findById(id).map { it.toDomain() }.orElse(null)
    override fun findBySlug(slug: String): ProductCategory? = jpa.findBySlug(slug).map { it.toDomain() }.orElse(null)
    override fun findAll(): List<ProductCategory> = jpa.findAll().map { it.toDomain() }
    override fun existsBySlug(slug: String): Boolean = jpa.existsBySlug(slug)
    override fun save(category: ProductCategory): ProductCategory =
        jpa.save(ProductCategoryJpaEntity.fromDomain(category)).toDomain()
    override fun deleteById(id: UUID) = jpa.deleteById(id)
}

@Repository
class AttributeDefinitionRepositoryAdapter(
    private val jpa: SpringDataJpaAttributeDefinitionRepository,
) : AttributeDefinitionRepository {
    override fun findById(id: UUID): ProductAttributeDefinition? = jpa.findById(id).map { it.toDomain() }.orElse(null)
    override fun findByKey(key: String): ProductAttributeDefinition? = jpa.findByKey(key).map { it.toDomain() }.orElse(null)
    override fun findAllActive(): List<ProductAttributeDefinition> = jpa.findByIsActiveTrue().map { it.toDomain() }
    override fun existsByKey(key: String): Boolean = jpa.existsByKey(key)
    override fun save(definition: ProductAttributeDefinition): ProductAttributeDefinition =
        jpa.save(AttributeDefinitionJpaEntity.fromDomain(definition)).toDomain()
    override fun deleteById(id: UUID) = jpa.deleteById(id)
}

@Repository
class ProductAttributeRepositoryAdapter(
    private val delegate: AttributeDefinitionRepositoryAdapter,
) : ProductAttributeRepository {
    override fun findById(id: UUID): ProductAttributeDefinition? = delegate.findById(id)
    override fun findByKey(key: String): ProductAttributeDefinition? = delegate.findByKey(key)
    override fun findAllActive(): List<ProductAttributeDefinition> = delegate.findAllActive()
    override fun existsByKey(key: String): Boolean = delegate.existsByKey(key)
    override fun save(definition: ProductAttributeDefinition): ProductAttributeDefinition = delegate.save(definition)
    override fun deleteById(id: UUID) = delegate.deleteById(id)
}

@Repository
class ProductAttributeOptionRepositoryAdapter(
    private val jpa: SpringDataJpaAttributeOptionRepository,
) : ProductAttributeOptionRepository {
    override fun findById(id: UUID): ProductAttributeOption? = jpa.findById(id).map { it.toDomain() }.orElse(null)
    override fun findByAttributeId(attributeId: UUID): List<ProductAttributeOption> =
        jpa.findByAttributeId(attributeId).map { it.toDomain() }
    override fun save(option: ProductAttributeOption): ProductAttributeOption =
        jpa.save(AttributeOptionJpaEntity.fromDomain(option)).toDomain()
    override fun deleteById(id: UUID) = jpa.deleteById(id)
}

@Repository
class ProductPresetRepositoryAdapter(
    private val jpa: SpringDataJpaProductPresetRepository,
) : ProductPresetRepository {
    override fun findById(id: UUID): ProductPreset? = jpa.findById(id).map { it.toDomain() }.orElse(null)
    override fun findByCategoryId(categoryId: UUID): List<ProductPreset> =
        jpa.findByCategoryId(categoryId).map { it.toDomain() }
    override fun findAll(): List<ProductPreset> = jpa.findAll().map { it.toDomain() }
    override fun save(preset: ProductPreset): ProductPreset =
        jpa.save(ProductPresetJpaEntity.fromDomain(preset)).toDomain()
    override fun deleteById(id: UUID) = jpa.deleteById(id)
}
