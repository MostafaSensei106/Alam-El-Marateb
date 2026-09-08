package com.mostafasensei.alamelmarateb.modules.product.domain.controller

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.router.admin.AdminProductRoutes
import com.mostafasensei.alamelmarateb.modules.product.data.model.AttributeType
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductAttributeDefinition
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductAttributeOption
import com.mostafasensei.alamelmarateb.modules.product.data.repository.AttributeDefinitionRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductAttributeOptionRepository
import com.mostafasensei.alamelmarateb.modules.product.domain.extension.*
import com.mostafasensei.alamelmarateb.modules.product.domain.model.*
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping(AdminProductRoutes.ATTRIBUTES)
class AttributeDefinitionController(
    private val catalogService: ProductCatalogService,
    private val attributeDefinitionRepository: AttributeDefinitionRepository,
    private val attributeOptionRepository: ProductAttributeOptionRepository,
) {

    @GetMapping
    fun getAll(): ResponseEntity<ApiResponse<List<ProductAttributeDefinitionResponse>>> =
        ResponseEntity.ok(ApiResponse.success(catalogService.getAllAttributeDefinitions().map { it.toResponse() }))

    @GetMapping("/{id}")
    fun getById(@PathVariable id: UUID): ResponseEntity<ApiResponse<ProductAttributeDefinitionResponse>> =
        catalogService.getAttributeDefinition(id)
            ?.let { ResponseEntity.ok(ApiResponse.success(it.toResponse())) }
            ?: ResponseEntity.status(404).body(ApiResponse.failure("Attribute not found"))

    @PostMapping
    fun create(@RequestBody request: AttributeDefinitionCreateRequest): ResponseEntity<ApiResponse<ProductAttributeDefinitionResponse>> {
        val definition = request.toDomain()
        val saved = catalogService.createAttributeDefinition(definition)
        return ResponseEntity.ok(ApiResponse.success(saved.toResponse()))
    }

    @PutMapping("/{id}")
    fun update(@PathVariable id: UUID, @RequestBody request: AttributeDefinitionUpdateRequest): ResponseEntity<ApiResponse<ProductAttributeDefinitionResponse>> {
        val existing = catalogService.getAttributeDefinition(id) ?: return ResponseEntity.status(404).body(ApiResponse.failure("Attribute not found"))
        val type = request.type?.let {
            when (it.uppercase()) {
                "TEXT" -> AttributeType.TEXT
                "NUMBER" -> AttributeType.NUMBER
                "BOOLEAN" -> AttributeType.BOOLEAN
                "SELECT" -> AttributeType.SELECT
                "MULTI_SELECT" -> AttributeType.MULTI_SELECT
                else -> throw IllegalArgumentException("Invalid attribute type")
            }
        } ?: existing.type
        val updated = existing.copy(
            name = request.name ?: existing.name,
            key = request.key ?: existing.key,
            type = type,
            isActive = request.isActive ?: existing.isActive,
        )
        val saved = catalogService.updateAttributeDefinition(id, updated)
        return ResponseEntity.ok(ApiResponse.success(saved.toResponse()))
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID): ResponseEntity<ApiResponse<Nothing>> {
        catalogService.deleteAttributeDefinition(id)
        return ResponseEntity.ok(ApiResponse.messageWithoutData("Attribute deleted"))
    }
}

@RestController
@RequestMapping(AdminProductRoutes.ATTRIBUTE_OPTIONS)
class AttributeOptionController(
    private val catalogService: ProductCatalogService,
    private val attributeOptionRepository: ProductAttributeOptionRepository,
) {

    @PostMapping
    fun addOption(@PathVariable id: UUID, @RequestBody request: AddOptionRequest): ResponseEntity<ApiResponse<ProductAttributeOptionResponse>> {
        val option = request.toDomain()
        val saved = catalogService.addOptionToAttribute(id, option)
        return ResponseEntity.ok(ApiResponse.success(saved.toResponse()))
    }

    @DeleteMapping("/{optionId}")
    fun removeOption(@PathVariable id: UUID, @PathVariable optionId: UUID): ResponseEntity<ApiResponse<Nothing>> {
        catalogService.removeOptionFromAttribute(optionId)
        return ResponseEntity.ok(ApiResponse.messageWithoutData("Option removed"))
    }
}
