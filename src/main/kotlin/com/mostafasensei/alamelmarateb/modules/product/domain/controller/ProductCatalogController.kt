package com.mostafasensei.alamelmarateb.modules.product.domain.controller

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.domain.extension.toDomain
import com.mostafasensei.alamelmarateb.modules.product.domain.model.CreateProductFromPresetRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.ProductCreateRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.ProductUpdateRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import com.mostafasensei.alamelmarateb.core.router.CatalogAdminRoutes
import com.mostafasensei.alamelmarateb.core.router.CatalogStoreRoutes
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

/**
 * Management controller — staff only. Role enforced here, not via URL prefix.
 * Canonical path: /api/v1/catalog/products
 */
@Tag(name = "Catalog (management)", description = "Products CRUD + from-preset — BRANCH_MANAGER")
@RestController
@RequestMapping(CatalogAdminRoutes.PRODUCTS)
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class ProductAdminController(
    private val catalogService: ProductCatalogService,
) : BaseController() {

    @GetMapping
    fun getAll(): ResponseEntity<ApiResponse<List<Product>>> =
        ok(catalogService.getAllProducts())

    @GetMapping("/{id}")
    fun getById(@PathVariable id: UUID): ResponseEntity<ApiResponse<Product>> =
        ok(catalogService.getProduct(id) ?: throw NotFoundException("error.catalog.product_not_found"))

    @PostMapping
    fun create(@Valid @RequestBody request: ProductCreateRequest): ResponseEntity<ApiResponse<Product>> {
        val product: Product = request.toDomain()
        val errors = catalogService.validateProductAttributes(product)
        if (errors.isNotEmpty()) throw BadRequestException("error.catalog.validation_failed", errorDetails = errors)
        return created(catalogService.createProduct(product))
    }

    @PutMapping("/{id}")
    fun update(
        @PathVariable id: UUID,
        @Valid @RequestBody request: ProductUpdateRequest,
    ): ResponseEntity<ApiResponse<Product>> {
        val existing = catalogService.getProduct(id) ?: throw NotFoundException("error.catalog.product_not_found")
        val updated = existing.copy(
            name = request.name ?: existing.name,
            slug = request.slug ?: existing.slug,
            brand = request.brand ?: existing.brand,
            description = request.description ?: existing.description,
            warrantyYears = request.warrantyYears ?: existing.warrantyYears,
            attributes = request.attributes?.map { it.toDomain() } ?: existing.attributes,
            isActive = request.isActive ?: existing.isActive,
        )
        return ok(catalogService.updateProduct(id, updated))
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID): ResponseEntity<ApiResponse<Nothing>> {
        catalogService.getProduct(id) ?: throw NotFoundException("error.catalog.product_not_found")
        catalogService.deleteProduct(id)
        return deleted(MessageService.t("success.deleted"))
    }

    @PostMapping("/from-preset/{presetId}")
    fun createFromPreset(
        @PathVariable presetId: UUID,
        @Valid @RequestBody request: CreateProductFromPresetRequest,
    ): ResponseEntity<ApiResponse<Product>> =
        created(catalogService.createProductFromPreset(presetId, request.slug))
}

/**
 * Public storefront controller — open read.
 * Canonical path: /api/v1/catalog/public/products
 */
@RestController
@RequestMapping(CatalogStoreRoutes.PRODUCTS)
class EcommerceProductController(
    private val catalogService: ProductCatalogService,
) : BaseController() {

    @GetMapping
    fun getAllActive(): ResponseEntity<ApiResponse<List<Product>>> =
        ok(catalogService.getAllProducts())

    @GetMapping("/{slug}")
    fun getBySlug(@PathVariable slug: String): ResponseEntity<ApiResponse<Product>> =
        ok(catalogService.getProductBySlug(slug) ?: throw NotFoundException("error.catalog.product_not_found"))
}
