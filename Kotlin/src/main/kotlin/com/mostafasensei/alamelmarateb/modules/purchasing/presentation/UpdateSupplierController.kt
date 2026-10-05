package com.mostafasensei.alamelmarateb.modules.purchasing.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.PurchasingRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.purchasing.application.PurchasingService
import com.mostafasensei.alamelmarateb.modules.purchasing.application.SupplierView
import com.mostafasensei.alamelmarateb.modules.purchasing.presentation.dto.SupplierUpdateRequest
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import com.mostafasensei.alamelmarateb.core.security.ManagerApi
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@Tag(name = "Purchasing (suppliers)", description = "Suppliers, supplier payments — BRANCH_MANAGER")
@RestController
@ManagerApi
class UpdateSupplierController(
    private val purchasingService: PurchasingService,
) : BaseController() {

    @Operation(summary = "Update supplier (partial)")
    @PatchMapping(PurchasingRoutes.SUPPLIER_BY_ID)
    fun patchUpdate(
        @PathVariable id: UUID,
        @Valid @RequestBody request: SupplierUpdateRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<SupplierView>> =
        update(id, request, principal)

    @Operation(summary = "Update supplier (full)")
    @PutMapping(PurchasingRoutes.SUPPLIER_BY_ID)
    fun update(
        @PathVariable id: UUID,
        @Valid @RequestBody request: SupplierUpdateRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<SupplierView>> =
        ok(
            purchasingService.updateSupplier(
                id, request.name, request.phone, request.address,
                request.taxId, request.isActive, principal.fullName,
            ),
        )
}
