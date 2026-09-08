package com.mostafasensei.alamelmarateb.modules.product.domain.controller

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.router.admin.AdminProductRoutes
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductPresetRepository
import com.mostafasensei.alamelmarateb.modules.product.domain.extension.*
import com.mostafasensei.alamelmarateb.modules.product.domain.model.*
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping(AdminProductRoutes.PRESETS)
class ProductPresetController(
    private val catalogService: ProductCatalogService,
    private val presetRepository: ProductPresetRepository,
) {

    @GetMapping
    fun getAll(): ResponseEntity<ApiResponse<List<ProductPresetResponse>>> =
        ResponseEntity(ApiResponse(true, "Operation Successful", catalogService.getAllPresets().map { it.toResponse() }), org.springframework.http.HttpStatus.OK)

    @GetMapping("/{id}")
    fun getById(@PathVariable id: UUID): ResponseEntity<ApiResponse<ProductPresetResponse>> =
        catalogService.getPreset(id)
            ?.let { ResponseEntity(ApiResponse(true, "Operation Successful", it.toResponse()), org.springframework.http.HttpStatus.OK) }
            ?: ResponseEntity.status(404).body(ApiResponse.failure("Preset not found"))

    @PostMapping
    fun create(@RequestBody request: ProductPresetCreateRequest): ResponseEntity<ApiResponse<ProductPresetResponse>> {
        val preset = request.toDomain()
        val saved = catalogService.createPreset(preset)
        return ResponseEntity(ApiResponse(true, "Operation Successful", saved.toResponse()), org.springframework.http.HttpStatus.OK)
    }

    @PutMapping("/{id}")
    fun update(@PathVariable id: UUID, @RequestBody request: ProductPresetUpdateRequest): ResponseEntity<ApiResponse<ProductPresetResponse>> {
        val existing = catalogService.getPreset(id) ?: return ResponseEntity.status(404).body(ApiResponse.failure("Preset not found"))
        val updated = existing.copy(
            name = request.name ?: existing.name,
            brand = request.brand ?: existing.brand,
            description = request.description ?: existing.description,
            warrantyYears = request.warrantyYears ?: existing.warrantyYears,
            isActive = request.isActive ?: existing.isActive,
            attributes = request.attributes?.map { it.toDomain() } ?: existing.attributes,
            variants = request.variants?.map { it.toDomain() } ?: existing.variants,
        )
        val saved = catalogService.updatePreset(id, updated)
        return ResponseEntity(ApiResponse(true, "Operation Successful", saved.toResponse()), org.springframework.http.HttpStatus.OK)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID): ResponseEntity<ApiResponse<Nothing>> {
        catalogService.deletePreset(id)
        return ResponseEntity.ok(ApiResponse.messageWithoutData("Preset deleted"))
    }
}
