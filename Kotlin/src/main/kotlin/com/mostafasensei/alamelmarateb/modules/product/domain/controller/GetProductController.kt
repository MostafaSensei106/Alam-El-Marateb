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
import com.mostafasensei.alamelmarateb.modules.product.domain.model.ProductPublicResponse
import com.mostafasensei.alamelmarateb.modules.product.domain.model.ProductUpdateRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.toPublic
import com.mostafasensei.alamelmarateb.modules.product.domain.service.CatalogSearchIndexer
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import com.mostafasensei.alamelmarateb.core.router.CatalogAdminRoutes
import com.mostafasensei.alamelmarateb.core.router.CatalogStoreRoutes
import io.swagger.v3.oas.annotations.Operation
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

@Tag(name = "Catalog (management)", description = "Products CRUD + from-preset — BRANCH_MANAGER")
@RestController
@RequestMapping(CatalogAdminRoutes.PRODUCTS)
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class GetProductController(
    private val catalogService: ProductCatalogService,
    private val searchIndexer: CatalogSearchIndexer,
) : BaseController() {

    @GetMapping("/{id}")
    fun getById(@PathVariable id: UUID): ResponseEntity<ApiResponse<Product>> =
        ok(catalogService.getProduct(id) ?: throw NotFoundException("error.catalog.product_not_found"))

}
