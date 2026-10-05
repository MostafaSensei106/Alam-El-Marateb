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
import com.mostafasensei.alamelmarateb.core.security.ManagerApi
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
@ManagerApi
class CreateCategoryController(
    private val catalogService: ProductCatalogService,
) : BaseController() {

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

}
