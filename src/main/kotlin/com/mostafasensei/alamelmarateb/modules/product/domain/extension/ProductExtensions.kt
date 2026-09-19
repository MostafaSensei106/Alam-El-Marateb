package com.mostafasensei.alamelmarateb.modules.product.domain.extension

import com.mostafasensei.alamelmarateb.modules.product.data.model.AttributeValue
import com.mostafasensei.alamelmarateb.modules.product.data.model.*
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.PresetAttributeValueJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.ProductAttributeValueJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.model.*
import java.math.BigDecimal
import java.util.UUID

fun ProductAttributeValueRequest.toDomain(): ProductAttributeValue =
    ProductAttributeValue(
        attributeId = attributeId,
        value = when (val v = value) {
            is AttributeValueRequest.Text -> AttributeValue.Text(v.value)
            is AttributeValueRequest.Number -> AttributeValue.Number(value = BigDecimal.valueOf(v.value))
            is AttributeValueRequest.Boolean -> AttributeValue.Boolean(value = v.value)
            is AttributeValueRequest.Option -> AttributeValue.Option(optionId = v.optionId)
            is AttributeValueRequest.MultiOption -> AttributeValue.MultiOption(optionIds = v.optionIds.toSet())
        }
    )

fun AttributeValueRequest.toDomain(attributeId: UUID): ProductAttributeValue =
    ProductAttributeValueRequest(attributeId = attributeId, value = this).toDomain()

fun ProductAttributeValue.toResponse(): ProductAttributeResponse =
    ProductAttributeResponse(
        attributeId = attributeId,
        value = when (value) {
            is AttributeValue.Text -> AttributeValueResponse.Text(value.value)
            is AttributeValue.Number -> AttributeValueResponse.Number(value.value.toDouble())
            is AttributeValue.Boolean -> AttributeValueResponse.Boolean(value.value)
            is AttributeValue.Option -> AttributeValueResponse.Option(optionId = value.optionId)
            is AttributeValue.MultiOption -> AttributeValueResponse.MultiOption(optionIds = value.optionIds.toList())
        }
    )

fun ProductAttributeValue.toJpa(attributeId: UUID): ProductAttributeValueJpaEntity =
    ProductAttributeValueJpaEntity(
        productId = null,
        attributeId = attributeId,
        valueType = when (value) {
            is AttributeValue.Text -> AttributeType.TEXT
            is AttributeValue.Number -> AttributeType.NUMBER
            is AttributeValue.Boolean -> AttributeType.BOOLEAN
            is AttributeValue.Option -> AttributeType.SELECT
            is AttributeValue.MultiOption -> AttributeType.MULTI_SELECT
        },
        valueText = when (value) {
            is AttributeValue.Text -> value.value
            is AttributeValue.Option -> null
            else -> null
        },
        valueNumber = when (value) {
            is AttributeValue.Number -> value.value
            else -> null
        },
        valueBoolean = when (value) {
            is AttributeValue.Boolean -> value.value
            else -> null
        },
        valueOptionId = when (value) {
            is AttributeValue.Option -> value.optionId
            else -> null
        },
        selectedOptionIds = when (value) {
            is AttributeValue.MultiOption -> value.optionIds.toMutableSet()
            else -> mutableSetOf()
        }
    )

fun ProductAttributeValueJpaEntity.toDomain(): ProductAttributeValue =
    ProductAttributeValue(
        attributeId = attributeId ?: throw IllegalStateException("attributeId needed"),
        value = when (valueType) {
            AttributeType.TEXT -> AttributeValue.Text(valueText ?: "")
            AttributeType.NUMBER -> AttributeValue.Number(valueNumber ?: BigDecimal.ZERO)
            AttributeType.BOOLEAN -> AttributeValue.Boolean(valueBoolean ?: false)
            AttributeType.SELECT -> AttributeValue.Option(valueOptionId ?: throw IllegalStateException("OptionId needed"))
            AttributeType.MULTI_SELECT -> AttributeValue.MultiOption(selectedOptionIds.toSet())
        }
    )

fun PresetAttributeValueJpaEntity.toDomain(): ProductAttributeValue =
    ProductAttributeValue(
        attributeId = attributeId ?: throw IllegalStateException("attributeId needed"),
        value = when (valueType) {
            AttributeType.TEXT -> AttributeValue.Text(valueText ?: "")
            AttributeType.NUMBER -> AttributeValue.Number(valueNumber ?: BigDecimal.ZERO)
            AttributeType.BOOLEAN -> AttributeValue.Boolean(valueBoolean ?: false)
            AttributeType.SELECT -> AttributeValue.Option(valueOptionId ?: throw IllegalStateException("OptionId needed"))
            AttributeType.MULTI_SELECT -> AttributeValue.MultiOption(selectedOptionIds.toSet())
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

fun ProductAttributeCreateRequest.toDomain(): ProductAttributeValue =
    ProductAttributeValue(
        attributeId = attributeId,
        value = when (value) {
            is AttributeValueCreateRequest.Text -> AttributeValue.Text(value.value)
            is AttributeValueCreateRequest.Number -> AttributeValue.Number(value = BigDecimal.valueOf(value.value))
            is AttributeValueCreateRequest.Boolean -> AttributeValue.Boolean(value.value)
            is AttributeValueCreateRequest.Option -> AttributeValue.Option(optionId = value.optionId)
            is AttributeValueCreateRequest.MultiOption -> AttributeValue.MultiOption(optionIds = value.optionIds.toSet())
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

fun ProductPresetVariant.toDomain(): ProductVariant =
    ProductVariant(
        sku = "PRESET-${id}",
        barcode = null,
        widthCm = widthCm,
        lengthCm = lengthCm,
        heightCm = heightCm,
        costPrice = costPrice,
        sellingPrice = sellingPrice,
    )

fun ProductPresetVariantCreateRequest.toDomain(): ProductPresetVariant =
    ProductPresetVariant(
        widthCm = widthCm,
        lengthCm = lengthCm,
        heightCm = heightCm,
        costPrice = BigDecimal.valueOf(costPrice),
        sellingPrice = BigDecimal.valueOf(sellingPrice),
    )
