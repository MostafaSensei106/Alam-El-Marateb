package com.mostafasensei.alamelmarateb.modules.product.domain.controller

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.router.admin.AdminProductRoutes
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.domain.extension.*
import com.mostafasensei.alamelmarateb.modules.product.domain.model.*
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping(AdminProductRoutes.CATEGORIES)
class ProductCategoryController(
    private val catalogService: ProductCatalogService,
) {

    @GetMapping
    fun getAll(): ResponseEntity<ApiResponse<List<ProductCategoryResponse>>> =
        ResponseEntity(ApiResponse(true, "Operation Successful", catalogService.getAllCategories().map { it.toResponse() }), org.springframework.http.HttpStatus.OK)

    @GetMapping("/{id}")
    fun getById(@PathVariable id: UUID): ResponseEntity<ApiResponse<ProductCategoryResponse>> =
        catalogService.getCategory(id)
            ?.let { ResponseEntity(ApiResponse(true, "Operation Successful", it.toResponse()), org.springframework.http.HttpStatus.OK) }
            ?: ResponseEntity.status(404).body(ApiResponse.failure("Category not found"))

    @PostMapping
    fun create(@RequestBody request: CategoryCreateRequest): ResponseEntity<ApiResponse<ProductCategoryResponse>> {
        val category = catalogService.createCategory(
            ProductCategory(
                name = request.name,
                slug = request.slug,
                description = request.description,
            )
        )
        return ResponseEntity(ApiResponse(true, "Operation Successful", category.toResponse()), org.springframework.http.HttpStatus.OK)
    }

    @PutMapping("/{id}")
    fun update(@PathVariable id: UUID, @RequestBody request: CategoryUpdateRequest): ResponseEntity<ApiResponse<ProductCategoryResponse>> {
        val existing = catalogService.getCategory(id) ?: return ResponseEntity.status(404).body(ApiResponse.failure("Category not found"))
        val updated = existing.copy(
            name = request.name ?: existing.name,
            description = request.description ?: existing.description,
            isActive = request.isActive ?: existing.isActive,
        )
        val saved = catalogService.updateCategory(id, updated)
        return ResponseEntity(ApiResponse(true, "Operation Successful", saved.toResponse()), org.springframework.http.HttpStatus.OK)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID): ResponseEntity<ApiResponse<Nothing>> {
        catalogService.deleteCategory(id)
        return ResponseEntity.ok(ApiResponse.messageWithoutData("Category deleted"))
    }
}

@RestController
@RequestMapping(AdminProductRoutes.CATEGORY_ATTRIBUTES)
class CategoryAttributeController(
    private val catalogService: ProductCatalogService,
) {

    @PutMapping("/{id}")
    fun linkAttributes(@PathVariable id: UUID, @RequestBody requests: List<CategoryAttributeLinkRequest>): ResponseEntity<ApiResponse<Nothing>> {
        return ResponseEntity.ok(ApiResponse.messageWithoutData("Category attributes updated"))
    }
}
