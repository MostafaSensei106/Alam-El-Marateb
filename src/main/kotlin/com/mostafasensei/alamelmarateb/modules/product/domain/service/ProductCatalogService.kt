package com.mostafasensei.alamelmarateb.modules.product.domain.service

import com.mostafasensei.alamelmarateb.modules.product.data.model.AttributeType
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
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductVariantRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.util.UUID

@Service
class ProductCatalogService(
    private val productRepository: ProductRepository,
    private val categoryRepository: ProductCategoryRepository,
    private val attributeDefinitionRepository: AttributeDefinitionRepository,
    private val attributeOptionRepository: ProductAttributeOptionRepository,
    private val variantRepository: ProductVariantRepository,
    private val presetRepository: ProductPresetRepository,
) {

    @Transactional(readOnly = true)
    fun getCategory(id: UUID): ProductCategory? = categoryRepository.findById(id)

    @Transactional(readOnly = true)
    fun getCategoryBySlug(slug: String): ProductCategory? = categoryRepository.findBySlug(slug)

    @Transactional(readOnly = true)
    fun getAllCategories(): List<ProductCategory> = categoryRepository.findAll()

    @Transactional
    fun createCategory(category: ProductCategory): ProductCategory = categoryRepository.save(category)

    @Transactional
    fun updateCategory(id: UUID, category: ProductCategory): ProductCategory {
        categoryRepository.findById(id) ?: throw IllegalArgumentException("Category not found")
        return categoryRepository.save(category.copy(id = id))
    }

    @Transactional
    fun deleteCategory(id: UUID) {
        if (categoryRepository.findById(id) == null) throw IllegalArgumentException("Category not found")
        categoryRepository.deleteById(id)
    }

    @Transactional(readOnly = true)
    fun getAttributeDefinition(id: UUID): ProductAttributeDefinition? = attributeDefinitionRepository.findById(id)

    @Transactional(readOnly = true)
    fun getAttributeByKey(key: String): ProductAttributeDefinition? = attributeDefinitionRepository.findByKey(key)

    @Transactional(readOnly = true)
    fun getAllAttributeDefinitions(): List<ProductAttributeDefinition> = attributeDefinitionRepository.findAllActive()

    @Transactional(readOnly = true)
    fun getOptionsForAttribute(attributeId: UUID): List<ProductAttributeOption> = attributeOptionRepository.findByAttributeId(attributeId)

    @Transactional
    fun createAttributeDefinition(definition: ProductAttributeDefinition): ProductAttributeDefinition =
        attributeDefinitionRepository.save(definition)

    @Transactional
    fun updateAttributeDefinition(id: UUID, definition: ProductAttributeDefinition): ProductAttributeDefinition {
        attributeDefinitionRepository.findById(id) ?: throw IllegalArgumentException("Attribute not found")
        return attributeDefinitionRepository.save(definition.copy(id = id))
    }

    @Transactional
    fun deleteAttributeDefinition(id: UUID) {
        if (attributeDefinitionRepository.findById(id) == null) throw IllegalArgumentException("Attribute not found")
        attributeDefinitionRepository.deleteById(id)
    }

    @Transactional
    fun addOptionToAttribute(attributeId: UUID, option: ProductAttributeOption): ProductAttributeOption =
        attributeOptionRepository.save(option)

    @Transactional
    fun removeOptionFromAttribute(optionId: UUID) {
        attributeOptionRepository.deleteById(optionId)
    }

    @Transactional(readOnly = true)
    fun getProduct(id: UUID): Product? = productRepository.findById(id)

    @Transactional(readOnly = true)
    fun getProductBySlug(slug: String): Product? = productRepository.findBySlug(slug)

    @Transactional(readOnly = true)
    fun getAllProducts(): List<Product> = productRepository.findAllActive()

    @Transactional(readOnly = true)
    fun getProductsByCategory(categoryId: UUID): List<Product> = productRepository.findByCategoryId(categoryId)

    @Transactional
    fun createProduct(product: Product): Product = productRepository.save(product)

    @Transactional
    fun updateProduct(id: UUID, product: Product): Product {
        productRepository.findById(id) ?: throw IllegalArgumentException("Product not found")
        return productRepository.save(product.copy(id = id))
    }

    @Transactional
    fun deleteProduct(id: UUID) {
        if (productRepository.findById(id) == null) throw IllegalArgumentException("Product not found")
        productRepository.deleteById(id)
    }

    @Transactional(readOnly = true)
    fun getVariantById(variantId: UUID): ProductVariant? = variantRepository.findVariantById(variantId)

    @Transactional(readOnly = true)
    fun getVariantByBarcode(barcode: String): ProductVariant? = variantRepository.findVariantByBarcode(barcode)

    @Transactional
    fun createVariant(variant: ProductVariant): ProductVariant = variantRepository.saveVariant(variant)

    @Transactional
    fun deleteVariant(variantId: UUID) {
        variantRepository.findVariantById(variantId) ?: throw IllegalArgumentException("Variant not found")
        variantRepository.deleteById(variantId)
    }

    @Transactional(readOnly = true)
    fun getPreset(id: UUID): ProductPreset? = presetRepository.findById(id)

    @Transactional(readOnly = true)
    fun getPresetsByCategory(categoryId: UUID): List<ProductPreset> = presetRepository.findByCategoryId(categoryId)

    @Transactional(readOnly = true)
    fun getAllPresets(): List<ProductPreset> = presetRepository.findAll()

    @Transactional
    fun createPreset(preset: ProductPreset): ProductPreset = presetRepository.save(preset)

    @Transactional
    fun updatePreset(id: UUID, preset: ProductPreset): ProductPreset {
        presetRepository.findById(id) ?: throw IllegalArgumentException("Preset not found")
        return presetRepository.save(preset.copy(id = id))
    }

    @Transactional
    fun deletePreset(id: UUID) {
        if (presetRepository.findById(id) == null) throw IllegalArgumentException("Preset not found")
        presetRepository.deleteById(id)
    }

    @Transactional
    fun createProductFromPreset(presetId: UUID): Product {
        val preset = presetRepository.findById(presetId)
            ?: throw IllegalArgumentException("Preset not found")

        val product = productRepository.save(
            Product(
                categoryId = preset.categoryId,
                name = preset.name,
                slug = preset.slug,
                brand = preset.brand,
                description = preset.description,
                warrantyYears = preset.warrantyYears,
                isActive = preset.isActive,
                attributes = preset.attributes.map { it.copy() },
                variants = emptyList()
            )
        )

        val savedVariants = preset.variants.map { variant ->
            variantRepository.saveVariant(variant.copy())
        }

        return product.copy(variants = savedVariants)
    }

    @Transactional
    fun validateProductAttributes(product: Product): List<String> {
        val errors = mutableListOf<String>()
        val category = categoryRepository.findById(product.categoryId) ?: return errors

        val requiredAttributes = category.attributes.filter { it.required }
        for (required in requiredAttributes) {
            val hasValue = product.attributes.any { it.attributeId == required.attribute.id }
            if (!hasValue) {
                errors.add("Required attribute missing: ${required.attribute.name}")
            }
        }

        for (attrValue in product.attributes) {
            val definition = attributeDefinitionRepository.findById(attrValue.attributeId)
            definition?.let { defn ->
                when (defn.type) {
                    AttributeType.SELECT -> {
                        if (attrValue.value is ProductAttributeValue.Option) {
                            val optionIds = defn.options.mapNotNull { it.id }.toSet()
                            if (attrValue.value.value.optionId !in optionIds) {
                                errors.add("Invalid option for attribute ${defn.key}")
                            }
                        }
                    }
                    AttributeType.MULTI_SELECT -> {
                        if (attrValue.value is ProductAttributeValue.MultiOption) {
                            val optionIds = defn.options.mapNotNull { it.id }.toSet()
                            val invalid = attrValue.value.value.optionIds.filter { it !in optionIds }
                            if (invalid.isNotEmpty()) {
                                errors.add("Invalid option(s) for attribute ${defn.key}")
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
