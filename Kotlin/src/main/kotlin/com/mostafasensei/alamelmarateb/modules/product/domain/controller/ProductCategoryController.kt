package com.mostafasensei.alamelmarateb.modules.product.domain.controller

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.domain.extension.toResponse
import com.mostafasensei.alamelmarateb.modules.product.domain.model.CategoryAttributeLinkRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.CategoryCreateRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.CategoryUpdateRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.ProductCategoryResponse
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
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@Tag(name = "Catalog (management)", description = "Categories + attribute links — BRANCH_MANAGER")
@RestController
@RequestMapping(CatalogAdminRoutes.CATEGORIES)
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class ProductCategoryController(
    private val catalogService: ProductCatalogService,
) : BaseController() {

    @GetMapping
    fun getAll(): ResponseEntity<ApiResponse<List<ProductCategoryResponse>>> =
        ok(catalogService.getAllCategories().map { it.toResponse() })

    @GetMapping("/{id}")
    fun getById(@PathVariable id: UUID): ResponseEntity<ApiResponse<ProductCategoryResponse>> =
        ok((catalogService.getCategory(id) ?: throw NotFoundException("error.catalog.category_not_found")).toResponse())

    @PostMapping
    fun create(@Valid @RequestBody request: CategoryCreateRequest): ResponseEntity<ApiResponse<ProductCategoryResponse>> {
        val category = catalogService.createCategory(
            ProductCategory(
                name = request.name,
                slug = request.slug,
                description = request.description,
                translations = request.translations ?: emptyMap(),
            ),
        )
        return created(category.toResponse())
    }

    @PutMapping("/{id}")
    fun update(
        @PathVariable id: UUID,
        @Valid @RequestBody request: CategoryUpdateRequest,
    ): ResponseEntity<ApiResponse<ProductCategoryResponse>> {
        val existing = catalogService.getCategory(id) ?: throw NotFoundException("error.catalog.category_not_found")
        val updated = existing.copy(
            name = request.name ?: existing.name,
            description = request.description ?: existing.description,
            isActive = request.isActive ?: existing.isActive,
            translations = request.translations ?: existing.translations,
        )
        return ok(catalogService.updateCategory(id, updated).toResponse())
    }

    @PatchMapping("/{id}")
    fun patchUpdate(
        @PathVariable id: UUID,
        @Valid @RequestBody request: CategoryUpdateRequest,
    ): ResponseEntity<ApiResponse<ProductCategoryResponse>> =
        update(id, request)

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID): ResponseEntity<ApiResponse<Nothing>> {
        catalogService.getCategory(id) ?: throw NotFoundException("error.catalog.category_not_found")
        catalogService.deleteCategory(id)
        return deleted(MessageService.t("success.deleted"))
    }
}

@RestController
@RequestMapping(CatalogAdminRoutes.CATEGORY_ATTRIBUTES)
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class CategoryAttributeController(
    private val catalogService: ProductCatalogService,
) : BaseController() {

    @PutMapping
    fun linkAttributes(
        @PathVariable id: UUID,
        @Valid @RequestBody requests: List<CategoryAttributeLinkRequest>,
    ): ResponseEntity<ApiResponse<Nothing>> {
        catalogService.getCategory(id) ?: throw NotFoundException("error.catalog.category_not_found")
        return deleted(MessageService.t("success.updated"))
    }
}
