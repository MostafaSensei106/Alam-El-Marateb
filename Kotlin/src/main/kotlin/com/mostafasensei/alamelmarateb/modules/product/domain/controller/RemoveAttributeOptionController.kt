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

@RestController
@RequestMapping(CatalogAdminRoutes.ATTRIBUTE_OPTIONS)
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class RemoveAttributeOptionController(
    private val catalogService: ProductCatalogService,
) : BaseController() {

    @DeleteMapping("/{optionId}")
    fun removeOption(
        @PathVariable id: UUID,
        @PathVariable optionId: UUID,
    ): ResponseEntity<ApiResponse<Nothing>> {
        catalogService.removeOptionFromAttribute(optionId)
        return deleted(MessageService.t("success.deleted"))
    }

}
