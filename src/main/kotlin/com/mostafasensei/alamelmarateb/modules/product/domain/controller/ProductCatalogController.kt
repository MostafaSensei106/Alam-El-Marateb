package com.mostafasensei.alamelmarateb.modules.product.domain.controller

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.router.admin.AdminProductRoutes
import com.mostafasensei.alamelmarateb.core.router.ecommerce.EcommerceCatalogRoutes
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductVariantRepository
import com.mostafasensei.alamelmarateb.modules.product.domain.extension.*
import com.mostafasensei.alamelmarateb.modules.product.domain.model.*
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import java.util.UUID

@RestController
@RequestMapping(AdminProductRoutes.PRODUCTS)
class ProductAdminController(
    private val catalogService: ProductCatalogService,
    private val productRepository: ProductRepository,
    private val variantRepository: ProductVariantRepository,
) {

    @GetMapping
    fun getAll(): ResponseEntity<ApiResponse<List<Product>>> =
        ResponseEntity.ok(ApiResponse.success(catalogService.getAllProducts()))

    @GetMapping("/{id}")
    fun getById(@PathVariable id: UUID): ResponseEntity<ApiResponse<Product>> =
        catalogService.getProduct(id)
            ?.let { ResponseEntity.ok(ApiResponse.success(it)) }
            ?: ResponseEntity.status(404).body(ApiResponse.failure("Product not found"))

    @PostMapping
    fun create(@RequestBody request: ProductCreateRequest): ResponseEntity<ApiResponse<Product>> {
        val product = request.toDomain()
        val errors = catalogService.validateProductAttributes(product)
        if (errors.isNotEmpty()) {
            return ResponseEntity.badRequest().body(ApiResponse.failure("Validation failed", errors))
        }
        val saved = catalogService.createProduct(product)
        return ResponseEntity.ok(ApiResponse.success(saved))
    }

    @PutMapping("/{id}")
    fun update(@PathVariable id: UUID, @RequestBody request: ProductUpdateRequest): ResponseEntity<ApiResponse<Product>> {
        val existing = catalogService.getProduct(id) ?: return ResponseEntity.status(404).body(ApiResponse.failure("Product not found"))
        val updated = existing.copy(
            name = request.name ?: existing.name,
            slug = request.slug ?: existing.slug,
            brand = request.brand ?: existing.brand,
            description = request.description ?: existing.description,
            warrantyYears = request.warrantyYears ?: existing.warrantyYears,
            attributes = request.attributes?.map { it.toDomain() } ?: existing.attributes,
            isActive = request.isActive ?: existing.isActive,
        )
        val saved = catalogService.updateProduct(id, updated)
        return ResponseEntity.ok(ApiResponse.success(saved))
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID): ResponseEntity<ApiResponse<Nothing>> {
        catalogService.deleteProduct(id)
        return ResponseEntity.ok(ApiResponse.messageWithoutData("Product deleted"))
    }

    @PostMapping("/from-preset/{presetId}")
    fun createFromPreset(@PathVariable presetId: UUID): ResponseEntity<ApiResponse<Product>> {
        val product = catalogService.createProductFromPreset(presetId)
        return ResponseEntity.ok(ApiResponse.success(product))
    }
}

@RestController
@RequestMapping(EcommerceCatalogRoutes.BASE)
class EcommerceProductController(
    private val catalogService: ProductCatalogService,
) {

    @GetMapping
    fun getAllActive(): ResponseEntity<ApiResponse<List<Product>>> =
        ResponseEntity.ok(ApiResponse.success(catalogService.getAllProducts()))

    @GetMapping("/{slug}")
    fun getBySlug(@PathVariable slug: String): ResponseEntity<ApiResponse<Product>> =
        catalogService.getProductBySlug(slug)
            ?.let { ResponseEntity.ok(ApiResponse.success(it)) }
            ?: ResponseEntity.status(404).body(ApiResponse.failure("Product not found"))
}
