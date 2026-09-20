package com.mostafasensei.alamelmarateb.modules.product.domain.service

import com.mostafasensei.alamelmarateb.core.exceptions.ErrorDetail
import com.mostafasensei.alamelmarateb.core.cache.RedisCache
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.product.data.model.AttributeType
import com.mostafasensei.alamelmarateb.modules.product.data.model.AttributeValue
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductAttributeDefinition
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductAttributeOption
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductAttributeValue
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductPreset
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductVariant
import com.mostafasensei.alamelmarateb.modules.product.data.repository.AttributeDefinitionRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductAttributeOptionRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductAttributeRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductCategoryRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductPresetRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductVariantRepository
import com.mostafasensei.alamelmarateb.modules.product.domain.extension.toDomain
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.Duration
import java.util.UUID

@Service
class ProductCatalogService(
    private val productRepository: ProductRepository,
    private val categoryRepository: ProductCategoryRepository,
    private val attributeDefinitionRepository: AttributeDefinitionRepository,
    private val attributeOptionRepository: ProductAttributeOptionRepository,
    private val variantRepository: ProductVariantRepository,
    private val presetRepository: ProductPresetRepository,
    private val cache: RedisCache,
) {

    companion object {
        private val CATALOG_TTL: Duration = Duration.ofMinutes(10)
    }

    @Transactional(readOnly = true)
    fun getCategory(id: UUID): ProductCategory? =
        cache.getOrLoad("cat:cat:$id", CATALOG_TTL, ProductCategory::class.java) { categoryRepository.findById(id) }

    @Transactional(readOnly = true)
    fun getCategoryBySlug(slug: String): ProductCategory? =
        cache.getOrLoad("cat:cat:slug:$slug", CATALOG_TTL, ProductCategory::class.java) { categoryRepository.findBySlug(slug) }

    @Transactional(readOnly = true)
    fun getAllCategories(): List<ProductCategory> = categoryRepository.findAll()

    @Transactional
    fun createCategory(category: ProductCategory): ProductCategory = categoryRepository.save(category)

    @Transactional
    fun updateCategory(id: UUID, category: ProductCategory): ProductCategory {
        categoryRepository.findById(id) ?: throw NotFoundException("error.catalog.category_not_found")
        val saved = categoryRepository.save(category.copy(id = id))
        cache.evict("cat:cat:$id")
        return saved
    }

    @Transactional
    fun deleteCategory(id: UUID) {
        if (categoryRepository.findById(id) == null) throw NotFoundException("error.catalog.category_not_found")
        categoryRepository.deleteById(id)
        cache.evict("cat:cat:$id")
    }

    @Transactional(readOnly = true)
    fun getAttributeDefinition(id: UUID): ProductAttributeDefinition? =
        cache.getOrLoad("cat:attr:$id", CATALOG_TTL, ProductAttributeDefinition::class.java) { attributeDefinitionRepository.findById(id) }

    @Transactional(readOnly = true)
    fun getAttributeByKey(key: String): ProductAttributeDefinition? =
        cache.getOrLoad("cat:attr:key:$key", CATALOG_TTL, ProductAttributeDefinition::class.java) { attributeDefinitionRepository.findByKey(key) }

    @Transactional(readOnly = true)
    fun getAllAttributeDefinitions(): List<ProductAttributeDefinition> = attributeDefinitionRepository.findAllActive()

    @Transactional(readOnly = true)
    fun getOptionsForAttribute(attributeId: UUID): List<ProductAttributeOption> = attributeOptionRepository.findByAttributeId(attributeId)

    @Transactional
    fun createAttributeDefinition(definition: ProductAttributeDefinition): ProductAttributeDefinition =
        attributeDefinitionRepository.save(definition)

    @Transactional
    fun updateAttributeDefinition(id: UUID, definition: ProductAttributeDefinition): ProductAttributeDefinition {
        attributeDefinitionRepository.findById(id) ?: throw NotFoundException("error.catalog.attribute_not_found")
        val saved = attributeDefinitionRepository.save(definition.copy(id = id))
        cache.evict("cat:attr:$id")
        return saved
    }

    @Transactional
    fun deleteAttributeDefinition(id: UUID) {
        if (attributeDefinitionRepository.findById(id) == null) throw NotFoundException("error.catalog.attribute_not_found")
        attributeDefinitionRepository.deleteById(id)
        cache.evict("cat:attr:$id")
    }

    @Transactional
    fun addOptionToAttribute(attributeId: UUID, option: ProductAttributeOption): ProductAttributeOption =
        attributeOptionRepository.save(option)

    @Transactional
    fun removeOptionFromAttribute(optionId: UUID) {
        attributeOptionRepository.deleteById(optionId)
    }

    @Transactional(readOnly = true)
    fun getProduct(id: UUID): Product? =
        cache.getOrLoad("cat:prod:$id", CATALOG_TTL, Product::class.java) { productRepository.findById(id) }

    @Transactional(readOnly = true)
    fun getProductBySlug(slug: String): Product? =
        cache.getOrLoad("cat:prod:slug:$slug", CATALOG_TTL, Product::class.java) { productRepository.findBySlug(slug) }

    @Transactional(readOnly = true)
    fun getAllProducts(): List<Product> = productRepository.findAllActive()

    @Transactional(readOnly = true)
    fun getProductsByCategory(categoryId: UUID): List<Product> = productRepository.findByCategoryId(categoryId)

    @Transactional
    fun createProduct(product: Product): Product = productRepository.save(product)

    @Transactional
    fun updateProduct(id: UUID, product: Product): Product {
        productRepository.findById(id) ?: throw NotFoundException("error.catalog.product_not_found")
        val saved = productRepository.save(product.copy(id = id))
        cache.evict("cat:prod:$id", "cat:prod:slug:${saved.slug}")
        return saved
    }

    @Transactional
    fun deleteProduct(id: UUID) {
        if (productRepository.findById(id) == null) throw NotFoundException("error.catalog.product_not_found")
        productRepository.deleteById(id)
        cache.evict("cat:prod:$id")
    }

    @Transactional(readOnly = true)
    fun getVariantById(variantId: UUID): ProductVariant? =
        cache.getOrLoad("cat:var:$variantId", CATALOG_TTL, ProductVariant::class.java) { variantRepository.findById(variantId) }

    @Transactional(readOnly = true)
    fun getVariantByBarcode(barcode: String): ProductVariant? =
        cache.getOrLoad("cat:var:bc:$barcode", CATALOG_TTL, ProductVariant::class.java) { variantRepository.findByBarcode(barcode) }

    @Transactional
    fun createVariant(variant: ProductVariant): ProductVariant = variantRepository.save(variant)

    @Transactional
    fun deleteVariant(variantId: UUID) {
        variantRepository.findById(variantId) ?: throw NotFoundException("error.catalog.variant_not_found")
        variantRepository.deleteVariantById(variantId)
        cache.evict("cat:var:$variantId")
    }

    @Transactional(readOnly = true)
    fun getPreset(id: UUID): ProductPreset? =
        cache.getOrLoad("cat:preset:$id", CATALOG_TTL, ProductPreset::class.java) { presetRepository.findById(id) }

    /**
     * Quick-create (arch.md §8.1): preset + ONE size only. Price is taken from
     * the preset variant with the same width/length (or overridden manually),
     * SKU auto-generated as {SLUG}-{W}X{L}X{H}.
     */
    @Transactional
    fun quickCreate(
        presetId: UUID,
        slug: String,
        name: String?,
        widthCm: Int,
        lengthCm: Int,
        heightCm: Int?,
        sku: String?,
        costPrice: java.math.BigDecimal?,
        sellingPrice: java.math.BigDecimal?,
        brandId: UUID?,
    ): Product {
        val preset = presetRepository.findById(presetId)
            ?: throw NotFoundException("error.catalog.preset_not_found")
        if (productRepository.findBySlug(slug) != null) {
            throw ConflictException("error.catalog.slug_exists", listOf(slug))
        }
        val match = preset.variants.firstOrNull { it.widthCm == widthCm && it.lengthCm == lengthCm }
        val height = heightCm ?: match?.heightCm ?: 25
        val finalSku = sku?.trim()?.uppercase()
            ?: "${slug.trim().uppercase()}-${widthCm}X${lengthCm}X$height"
        val product = Product(
            categoryId = preset.categoryId,
            name = name?.ifBlank { preset.name } ?: preset.name,
            slug = slug,
            brand = preset.brand,
            brandId = brandId,
            description = preset.description,
            warrantyYears = null,
            attributes = preset.attributes,
            variants = listOf(
                ProductVariant(
                    sku = finalSku,
                    barcode = null,
                    widthCm = widthCm,
                    lengthCm = lengthCm,
                    heightCm = height,
                    costPrice = costPrice ?: match?.costPrice ?: java.math.BigDecimal.ZERO,
                    sellingPrice = sellingPrice ?: match?.sellingPrice ?: java.math.BigDecimal.ZERO,
                ),
            ),
        )
        val errors = validateProductAttributes(product)
        if (errors.isNotEmpty()) throw BadRequestException("error.catalog.validation_failed", errorDetails = errors)
        return productRepository.save(product)
    }

    @Transactional(readOnly = true)
    fun search(
        query: String?,
        categoryId: UUID?,
        brand: String?,
        minPrice: java.math.BigDecimal?,
        maxPrice: java.math.BigDecimal?,
    ): List<Product> =
        productRepository.findAllActive().filter { product ->
            (query.isNullOrBlank() || product.name.contains(query, ignoreCase = true) || product.slug.contains(query, ignoreCase = true)) &&
                (categoryId == null || product.categoryId == categoryId) &&
                (brand.isNullOrBlank() || product.brand.equals(brand, ignoreCase = true)) &&
                (minPrice == null || (product.variants.minOfOrNull { it.sellingPrice } ?: java.math.BigDecimal.ZERO) >= minPrice) &&
                (maxPrice == null || (product.variants.minOfOrNull { it.sellingPrice } ?: java.math.BigDecimal.ZERO) <= maxPrice)
        }

    @Transactional(readOnly = true)
    fun featured(): List<Product> =
        productRepository.findAllActive().filter { it.isFeatured }

    @Transactional(readOnly = true)
    fun compare(ids: List<UUID>): List<Product> =
        ids.distinct().take(4).mapNotNull { productRepository.findById(it)?.takeIf { p -> p.isActive } }

    @Transactional(readOnly = true)
    fun getAllPresets(): List<ProductPreset> = presetRepository.findAll()

    @Transactional
    fun createPreset(preset: ProductPreset): ProductPreset = presetRepository.save(preset)

    @Transactional
    fun updatePreset(id: UUID, preset: ProductPreset): ProductPreset {
        presetRepository.findById(id) ?: throw NotFoundException("error.catalog.preset_not_found")
        val saved = presetRepository.save(preset.copy(id = id))
        cache.evict("cat:preset:$id")
        return saved
    }

    @Transactional
    fun deletePreset(id: UUID) {
        if (presetRepository.findById(id) == null) throw NotFoundException("error.catalog.preset_not_found")
        presetRepository.deleteById(id)
        cache.evict("cat:preset:$id")
    }

    @Transactional
    fun createProductFromPreset(presetId: UUID, slug: String): Product {
        val preset = presetRepository.findById(presetId)
            ?: throw NotFoundException("error.catalog.preset_not_found")

        val product = productRepository.save(
            Product(
                categoryId = preset.categoryId,
                name = preset.name,
                slug = slug,
                brand = preset.brand,
                description = preset.description,
                warrantyYears = preset.warrantyYears,
                isActive = preset.isActive,
                attributes = preset.attributes.map { it.copy() },
                variants = emptyList()
            )
        )

        val savedVariants = preset.variants.map { variant ->
            val v = variantRepository.save(variant.toDomain())
            v
        }

        return product.copy(variants = savedVariants)
    }

    @Transactional
    fun validateProductAttributes(product: Product): List<ErrorDetail> {
        val errors = mutableListOf<ErrorDetail>()
        val category = categoryRepository.findById(product.categoryId) ?: return errors

        val requiredAttributes = category.attributes.filter { it.required }
        for (required in requiredAttributes) {
            val hasValue = product.attributes.any { it.attributeId == required.attribute.id }
            if (!hasValue) {
                errors.add(ErrorDetail("error.catalog.required_attr_missing", listOf(required.attribute.name)))
            }
        }

        for (attrValue in product.attributes) {
            val definition = attributeDefinitionRepository.findById(attrValue.attributeId)
            definition?.let { defn ->
                val optionIds = defn.options.mapNotNull { it.id }.toSet()
                when (defn.type) {
                     AttributeType.SELECT -> {
                        if (attrValue.value is AttributeValue.Option) {
                            val optionId = attrValue.value.optionId
                            if (optionId !in optionIds) {
                                errors.add(ErrorDetail("error.catalog.invalid_option", listOf(defn.key)))
                            }
                        }
                     }
                     AttributeType.MULTI_SELECT -> {
                        if (attrValue.value is AttributeValue.MultiOption) {
                            val optionIdsSet = attrValue.value.optionIds
                            val invalid = optionIdsSet.filter { it !in optionIds }
                            if (invalid.isNotEmpty()) {
                                errors.add(ErrorDetail("error.catalog.invalid_option", listOf(defn.key)))
                            }
                        }
                     }
                    else -> {}
                }
            }
        }

        return errors
    }
}
