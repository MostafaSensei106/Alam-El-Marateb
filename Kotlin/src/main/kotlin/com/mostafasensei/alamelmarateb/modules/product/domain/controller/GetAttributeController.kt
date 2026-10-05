package com.mostafasensei.alamelmarateb.modules.product.domain.controller

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
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

@Tag(name = "Catalog (management)", description = "Attributes + options — BRANCH_MANAGER")
@RestController
@RequestMapping(CatalogAdminRoutes.ATTRIBUTES)
@ManagerApi
class GetAttributeController(
    private val catalogService: ProductCatalogService,
) : BaseController() {

    @GetMapping("/{id}")
    fun getById(@PathVariable id: UUID): ResponseEntity<ApiResponse<ProductAttributeDefinitionResponse>> =
        ok((catalogService.getAttributeDefinition(id) ?: throw NotFoundException("error.catalog.attribute_not_found")).toResponse())

}
