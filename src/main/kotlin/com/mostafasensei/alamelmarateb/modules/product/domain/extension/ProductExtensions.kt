package com.mostafasensei.alamelmarateb.modules.product.domain.extension

import com.mostafasensei.alamelmarateb.modules.product.data.model.*
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductAttributeValueJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.data.repository.PresetAttributeValueJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.model.*
import java.math.BigDecimal

fun com.mostafasensei.alamelmarateb.modules.product.domain.model.AttributeValueRequest.toDomain(attributeId: UUID): ProductAttributeValue =
    ProductAttributeValue(
        attributeId = attributeId,
        value = when (this) {
            is com.mostafasensei.alamelmarateb.modules.product.domain.model.AttributeValueRequest.Text -> ProductAttributeValue.Text(value)
            is com.mostafasensei.alamelmarateb.modules.product.domain.model.AttributeValueRequest.Number -> ProductAttributeValue.Number(value = BigDecimal.valueOf(value))
            is com.mostafasensei.alamelmarateb.modules.product.domain.model.AttributeValueRequest.Boolean -> ProductAttributeValue.Boolean(value = value)
            is com.mostafasensei.alamelmarateb.modules.product.domain.model.AttributeValueRequest.Option -> ProductAttributeValue.Option(optionId = optionId)
            is com.mostafasensei.alamelmarateb.modules.product.domain.model.AttributeValueRequest.MultiOption -> ProductAttributeValue.MultiOption(optionIds = optionIds.toSet())
        }
    )

fun ProductAttributeValue.toResponse(): ProductAttributeResponse =
    ProductAttributeResponse(
        attributeId = attributeId,
        value = when (value) {
            is ProductAttributeValue.Text -> ProductAttributeResponse.Value.Text(value.value)
            is ProductAttributeValue.Number -> ProductAttributeResponse.Value.Number(value.value.toDouble())
            is ProductAttributeValue.Boolean -> ProductAttributeResponse.Value.Boolean(value.value)
            is ProductAttributeValue.Option -> ProductAttributeResponse.Value.Option(optionId = value.optionId)
            is ProductAttributeValue.MultiOption -> ProductAttributeResponse.Value.MultiOption(optionIds = value.optionIds.toList(), labels = emptyList())
        }
    )

fun ProductAttributeValue.toJpa(attributeId: UUID): ProductAttributeValueJpaEntity =
    ProductAttributeValueJpaEntity(
        productId = null,
        attributeId = attributeId,
        valueType = when (value) {
            is ProductAttributeValue.Text -> AttributeType.TEXT
            is ProductAttributeValue.Number -> AttributeType.NUMBER
            is ProductAttributeValue.Boolean -> AttributeType.BOOLEAN
            is ProductAttributeValue.Option -> AttributeType.SELECT
            is ProductAttributeValue.MultiOption -> AttributeType.MULTI_SELECT
        },
        valueText = when (value) {
            is ProductAttributeValue.Text -> value.value
            is ProductAttributeValue.Option -> null
            else -> null
        },
        valueNumber = when (value) {
            is ProductAttributeValue.Number -> value.value
            else -> null
        },
        valueBoolean = when (value) {
            is ProductAttributeValue.Boolean -> value.value
            else -> null
        },
        valueOptionId = when (value) {
            is ProductAttributeValue.Option -> value.optionId
            else -> null
        },
        selectedOptionIds = when (value) {
            is ProductAttributeValue.MultiOption -> value.optionIds.toMutableSet()
            else -> mutableSetOf()
        }
    )

fun ProductAttributeValueJpaEntity.toDomain(): ProductAttributeValue =
    ProductAttributeValue(
        attributeId = attributeId ?: throw IllegalStateException("attributeId needed"),
        value = when (valueType) {
            AttributeType.TEXT -> ProductAttributeValue.Text(valueText ?: "")
            AttributeType.NUMBER -> ProductAttributeValue.Number(valueNumber ?: BigDecimal.ZERO)
            AttributeType.BOOLEAN -> ProductAttributeValue.Boolean(valueBoolean ?: false)
            AttributeType.SELECT -> ProductAttributeValue.Option(valueOptionId ?: throw IllegalStateException("OptionId needed"))
            AttributeType.MULTI_SELECT -> ProductAttributeValue.MultiOption(selectedOptionIds.toSet())
        }
    )

fun PresetAttributeValueJpaEntity.toDomain(): ProductAttributeValue =
    ProductAttributeValue(
        attributeId = attributeId ?: throw IllegalStateException("attributeId needed"),
        value = when (valueType) {
            AttributeType.TEXT -> ProductAttributeValue.Text(valueText ?: "")
            AttributeType.NUMBER -> ProductAttributeValue.Number(valueNumber ?: BigDecimal.ZERO)
            AttributeType.BOOLEAN -> ProductAttributeValue.Boolean(valueBoolean ?: false)
            AttributeType.SELECT -> ProductAttributeValue.Option(valueOptionId ?: throw IllegalStateException("OptionId needed"))
            AttributeType.MULTI_SELECT -> ProductAttributeValue.MultiOption(selectedOptionIds.toSet())
        }
    )

fun ProductCategory.toResponse(): ProductCategoryResponse =
    ProductCategoryResponse(
        id = id,
        name = name,
        slug = slug,
        description = description,
        isActive = isActive,
        attributes = attributes.map { it.toResponse() },
    )

fun CategoryAttribute.toResponse(): CategoryAttributeResponse =
    CategoryAttributeResponse(
        attribute = attribute.toResponse(),
        required = required,
        sortOrder = sortOrder,
    )

fun ProductAttributeDefinition.toResponse(): ProductAttributeDefinitionResponse =
    ProductAttributeDefinitionResponse(
        id = id,
        name = name,
        key = key,
        type = type.name,
        options = options.map { it.toResponse() },
        isActive = isActive,
    )

fun ProductAttributeOption.toResponse(): ProductAttributeOptionResponse =
    ProductAttributeOptionResponse(
        id = id,
        value = value,
        label = label,
        sortOrder = sortOrder,
    )

fun ProductPreset.toResponse(): ProductPresetResponse =
    ProductPresetResponse(
        id = id,
        categoryId = categoryId,
        name = name,
        brand = brand,
        description = description,
        warrantyYears = warrantyYears,
        isActive = isActive,
        attributes = attributes.map { it.toResponse() },
        variants = variants.map { it.toResponse() },
    )

fun ProductPresetVariant.toResponse(): ProductPresetVariantResponse =
    ProductPresetVariantResponse(
        id = id,
        widthCm = widthCm,
        lengthCm = lengthCm,
        heightCm = heightCm,
        costPrice = costPrice.toDouble(),
        sellingPrice = sellingPrice.toDouble(),
        isActive = isActive,
    )

fun ProductVariant.toResponse(): ProductVariantResponse =
    ProductVariantResponse(
        id = id,
        sku = sku,
        barcode = barcode,
        widthCm = widthCm,
        lengthCm = lengthCm,
        heightCm = heightCm,
        costPrice = costPrice.toDouble(),
        sellingPrice = sellingPrice.toDouble(),
        isActive = isActive,
    )

fun Product.toResponse(): ProductResponse =
    ProductResponse(
        id = id,
        categoryId = categoryId,
        name = name,
        slug = slug,
        brand = brand,
        description = description,
        warrantyYears = warrantyYears,
        attributes = attributes.map { it.toResponse() },
        variants = variants.map { it.toResponse() },
        isActive = isActive,
    )

fun ProductAttributeOptionCreateRequest.toDomain(): ProductAttributeOption =
    ProductAttributeOption(value = value, label = label, sortOrder = sortOrder)

fun AddOptionRequest.toDomain(): ProductAttributeOption =
    ProductAttributeOption(value = value, label = label, sortOrder = sortOrder)

fun AttributeOptionCreateRequest.toDomain(): ProductAttributeOption =
    ProductAttributeOption(value = value, label = label, sortOrder = sortOrder)

fun AttributeDefinitionCreateRequest.toDomain(): ProductAttributeDefinition =
    ProductAttributeDefinition(
        name = name,
        key = key,
        type = when (type.uppercase()) {
            "TEXT" -> AttributeType.TEXT
            "NUMBER" -> AttributeType.NUMBER
            "BOOLEAN" -> AttributeType.BOOLEAN
            "SELECT" -> AttributeType.SELECT
            "MULTI_SELECT" -> AttributeType.MULTI_SELECT
            else -> throw IllegalArgumentException("Invalid type: $type")
        },
        options = options.map { it.toDomain() },
    )

fun CategoryAttributeLinkRequest.toDomain(attributeDef: ProductAttributeDefinition): CategoryAttribute =
    CategoryAttribute(attribute = attributeDef, required = required, sortOrder = sortOrder)

fun ProductAttributeValueCreateRequest.toDomain(): ProductAttributeValue =
    ProductAttributeValue(
        attributeId = attributeId,
        value = when (value) {
            is AttributeValueCreateRequest.Text -> ProductAttributeValue.Text(value.value)
            is AttributeValueCreateRequest.Number -> ProductAttributeValue.Number(value = BigDecimal.valueOf(value.value))
            is AttributeValueCreateRequest.Boolean -> ProductAttributeValue.Boolean(value.value)
            is AttributeValueCreateRequest.Option -> ProductAttributeValue.Option(optionId = value.optionId)
            is AttributeValueCreateRequest.MultiOption -> ProductAttributeValue.MultiOption(optionIds = value.optionIds.toSet())
        }
    )

fun ProductPresetAttributeCreateRequest.toDomain(): ProductAttributeValue =
    ProductAttributeValue(
        attributeId = attributeId,
        value = when (value) {
            is AttributeValueCreateRequest.Text -> ProductAttributeValue.Text(value.value)
            is AttributeValueCreateRequest.Number -> ProductAttributeValue.Number(value = BigDecimal.valueOf(value.value))
            is AttributeValueCreateRequest.Boolean -> ProductAttributeValue.Boolean(value.value)
            is AttributeValueCreateRequest.Option -> ProductAttributeValue.Option(optionId = value.optionId)
            is AttributeValueCreateRequest.MultiOption -> ProductAttributeValue.MultiOption(optionIds = value.optionIds.toSet())
        }
    )

fun ProductCreateRequest.toDomain(): Product =
    Product(
        categoryId = categoryId,
        name = name,
        slug = slug,
        brand = brand,
        description = description,
        warrantyYears = warrantyYears,
        attributes = attributes.map { it.toDomain() },
        variants = variants.map { it.toDomain() },
    )

fun ProductVariantCreateRequest.toDomain(): ProductVariant =
    ProductVariant(
        sku = sku,
        barcode = barcode,
        widthCm = widthCm,
        lengthCm = lengthCm,
        heightCm = heightCm,
        costPrice = BigDecimal.valueOf(costPrice),
        sellingPrice = BigDecimal.valueOf(sellingPrice),
    )

fun ProductPresetCreateRequest.toDomain(): ProductPreset =
    ProductPreset(
        categoryId = categoryId,
        name = name,
        brand = brand,
        description = description,
        warrantyYears = warrantyYears,
        attributes = attributes.map { it.toDomain() },
        variants = variants.map { it.toDomain() },
    )

fun ProductPresetVariantCreateRequest.toDomain(): ProductPresetVariant =
    ProductPresetVariant(
        widthCm = widthCm,
        lengthCm = lengthCm,
        heightCm = heightCm,
        costPrice = BigDecimal.valueOf(costPrice),
        sellingPrice = BigDecimal.valueOf(sellingPrice),
    )
