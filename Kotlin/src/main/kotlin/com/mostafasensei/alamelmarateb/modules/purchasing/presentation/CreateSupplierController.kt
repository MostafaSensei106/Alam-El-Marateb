package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.PurchasingRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PurchasingService
import com.mostafasensei.alamelmarateb.modules.purchasing.application.SupplierView
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.SupplierRequest
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import com.mostafasensei.alamelmarateb.core.security.ManagerApi
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController

@Tag(name = "Purchasing (suppliers)", description = "Suppliers, supplier payments — BRANCH_MANAGER")
@RestController
@ManagerApi
class CreateSupplierController(
    private val purchasingService: PurchasingService,
) : BaseController() {

    @Operation(summary = "Create supplier")
    @PostMapping(PurchasingRoutes.SUPPLIERS)
    fun create(
        @Valid @RequestBody request: SupplierRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<SupplierView>> =
        created(
            purchasingService.createSupplier(
                request.name, request.phone, request.address, request.taxId, principal.fullName,
            ),
        )
}
