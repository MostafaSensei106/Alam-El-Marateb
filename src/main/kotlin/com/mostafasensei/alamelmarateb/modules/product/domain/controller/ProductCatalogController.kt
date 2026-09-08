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
        ResponseEntity(ApiResponse(true, "Operation Successful", catalogService.getAllProducts()), org.springframework.http.HttpStatus.OK)

    @GetMapping("/{id}")
    fun getById(@PathVariable id: UUID): ResponseEntity<ApiResponse<Product>> =
        catalogService.getProduct(id)
            ?.let { ResponseEntity(ApiResponse(true, "Operation Successful", it), org.springframework.http.HttpStatus.OK) }
            ?: ResponseEntity.status(404).body(ApiResponse.failure("Product not found"))

    @PostMapping
    fun create(@RequestBody request: ProductCreateRequest): ResponseEntity<ApiResponse<Product>> {
        val product: com.mostafasensei.alamelmarateb.modules.product.data.model.Product = request.toDomain()
        val errors = catalogService.validateProductAttributes(product)
        if (errors.isNotEmpty()) {
            return ResponseEntity.badRequest().body(ApiResponse.failure("Validation failed", errors))
        }
        val saved = catalogService.createProduct(product)
        return ResponseEntity(ApiResponse(true, "Operation Successful", saved), org.springframework.http.HttpStatus.OK)
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
        return ResponseEntity(ApiResponse(true, "Operation Successful", saved), org.springframework.http.HttpStatus.OK)
    }

    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID): ResponseEntity<ApiResponse<Nothing>> {
        catalogService.deleteProduct(id)
        return ResponseEntity.ok(ApiResponse.messageWithoutData("Product deleted"))
    }

    @PostMapping("/from-preset/{presetId}")
    fun createFromPreset(@PathVariable presetId: UUID, @RequestBody request: CreateProductFromPresetRequest): ResponseEntity<ApiResponse<Product>> {
        val product = catalogService.createProductFromPreset(presetId, request.slug)
        return ResponseEntity(ApiResponse(true, "Operation Successful", product), org.springframework.http.HttpStatus.OK)
    }
}

@RestController
@RequestMapping(EcommerceCatalogRoutes.BASE)
class EcommerceProductController(
    private val catalogService: ProductCatalogService,
) {

    @GetMapping
    fun getAllActive(): ResponseEntity<ApiResponse<List<Product>>> =
        ResponseEntity(ApiResponse(true, "Operation Successful", catalogService.getAllProducts()), org.springframework.http.HttpStatus.OK)

    @GetMapping("/{slug}")
    fun getBySlug(@PathVariable slug: String): ResponseEntity<ApiResponse<Product>> =
        catalogService.getProductBySlug(slug)
            ?.let { ResponseEntity(ApiResponse(true, "Operation Successful", it), org.springframework.http.HttpStatus.OK) }
            ?: ResponseEntity.status(404).body(ApiResponse.failure("Product not found"))
}
