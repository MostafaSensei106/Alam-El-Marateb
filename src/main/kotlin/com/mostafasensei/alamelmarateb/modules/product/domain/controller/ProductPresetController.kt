package com.mostafasensei.alamelmarateb.modules.product.domain.controller

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.product.domain.extension.toDomain
import com.mostafasensei.alamelmarateb.modules.product.domain.extension.toResponse
import com.mostafasensei.alamelmarateb.modules.product.domain.model.ProductPresetCreateRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.ProductPresetResponse
import com.mostafasensei.alamelmarateb.modules.product.domain.model.ProductPresetUpdateRequest
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

@Tag(name = "Catalog (management)", description = "Product templates — BRANCH_MANAGER")
@RestController
@RequestMapping(CatalogAdminRoutes.PRESETS)
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class ProductPresetController(
    private val catalogService: ProductCatalogService,
) : BaseController() {

    @GetMapping
    fun getAll(): ResponseEntity<ApiResponse<List<ProductPresetResponse>>> =
        ok(catalogService.getAllPresets().map { it.toResponse() })

    @GetMapping("/{id}")
    fun getById(@PathVariable id: UUID): ResponseEntity<ApiResponse<ProductPresetResponse>> =
        ok((catalogService.getPreset(id) ?: throw NotFoundException("error.catalog.preset_not_found")).toResponse())

    @PostMapping
    fun create(@Valid @RequestBody request: ProductPresetCreateRequest): ResponseEntity<ApiResponse<ProductPresetResponse>> {
        val saved = catalogService.createPreset(request.toDomain())
        return created(saved.toResponse())
    }

    @PutMapping("/{id}")
    fun update(
        @PathVariable id: UUID,
        @Valid @RequestBody request: ProductPresetUpdateRequest,
    ): ResponseEntity<ApiResponse<ProductPresetResponse>> {
        val existing = catalogService.getPreset(id) ?: throw NotFoundException("error.catalog.preset_not_found")
        val updated = existing.copy(
            name = request.name ?: existing.name,
            brand = request.brand ?: existing.brand,
            description = request.description ?: existing.description,
            warrantyYears = request.warrantyYears ?: existing.warrantyYears,
            isActive = request.isActive ?: existing.isActive,
            attributes = request.attributes?.map { it.toDomain() } ?: existing.attributes,
            variants = request.variants?.map { it.toDomain() } ?: existing.variants,
        )
        return ok(catalogService.updatePreset(id, updated).toResponse())
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID): ResponseEntity<ApiResponse<Nothing>> {
        catalogService.getPreset(id) ?: throw NotFoundException("error.catalog.preset_not_found")
        catalogService.deletePreset(id)
        return deleted(MessageService.t("success.deleted"))
    }
}
