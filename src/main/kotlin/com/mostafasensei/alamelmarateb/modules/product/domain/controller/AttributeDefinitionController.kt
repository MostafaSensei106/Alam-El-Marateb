package com.mostafasensei.alamelmarateb.modules.product.domain.controller

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.product.data.model.AttributeType
import com.mostafasensei.alamelmarateb.modules.product.domain.extension.toDomain
import com.mostafasensei.alamelmarateb.modules.product.domain.extension.toResponse
import com.mostafasensei.alamelmarateb.modules.product.domain.model.AddOptionRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.AttributeDefinitionCreateRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.AttributeDefinitionUpdateRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.ProductAttributeDefinitionResponse
import com.mostafasensei.alamelmarateb.modules.product.domain.model.ProductAttributeOptionResponse
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import com.mostafasensei.alamelmarateb.core.router.CatalogAdminRoutes
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@Tag(name = "Catalog (management)", description = "Attributes + options — BRANCH_MANAGER")
@RestController
@RequestMapping(CatalogAdminRoutes.ATTRIBUTES)
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class AttributeDefinitionController(
    private val catalogService: ProductCatalogService,
) : BaseController() {

    @GetMapping
    fun getAll(): ResponseEntity<ApiResponse<List<ProductAttributeDefinitionResponse>>> =
        ok(catalogService.getAllAttributeDefinitions().map { it.toResponse() })

    @GetMapping("/{id}")
    fun getById(@PathVariable id: UUID): ResponseEntity<ApiResponse<ProductAttributeDefinitionResponse>> =
        ok((catalogService.getAttributeDefinition(id) ?: throw NotFoundException("Attribute not found")).toResponse())

    @PostMapping
    fun create(@Valid @RequestBody request: AttributeDefinitionCreateRequest): ResponseEntity<ApiResponse<ProductAttributeDefinitionResponse>> {
        val saved = catalogService.createAttributeDefinition(request.toDomain())
        return created(saved.toResponse())
    }

    @PutMapping("/{id}")
    fun update(
        @PathVariable id: UUID,
        @Valid @RequestBody request: AttributeDefinitionUpdateRequest,
    ): ResponseEntity<ApiResponse<ProductAttributeDefinitionResponse>> {
        val existing = catalogService.getAttributeDefinition(id) ?: throw NotFoundException("Attribute not found")
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
        return ok(catalogService.updateAttributeDefinition(id, updated).toResponse())
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID): ResponseEntity<ApiResponse<Nothing>> {
        catalogService.getAttributeDefinition(id) ?: throw NotFoundException("Attribute not found")
        catalogService.deleteAttributeDefinition(id)
        return deleted("Attribute deleted")
    }
}

@RestController
@RequestMapping(CatalogAdminRoutes.ATTRIBUTE_OPTIONS)
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class AttributeOptionController(
    private val catalogService: ProductCatalogService,
) : BaseController() {

    @PostMapping
    fun addOption(
        @PathVariable id: UUID,
        @Valid @RequestBody request: AddOptionRequest,
    ): ResponseEntity<ApiResponse<ProductAttributeOptionResponse>> {
        catalogService.getAttributeDefinition(id) ?: throw NotFoundException("Attribute not found")
        return created(catalogService.addOptionToAttribute(id, request.toDomain()).toResponse())
    }

    @DeleteMapping("/{optionId}")
    fun removeOption(
        @PathVariable id: UUID,
        @PathVariable optionId: UUID,
    ): ResponseEntity<ApiResponse<Nothing>> {
        catalogService.removeOptionFromAttribute(optionId)
        return deleted("Option removed")
    }
}
