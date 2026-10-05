package com.mostafasensei.alamelmarateb.modules.product.domain.controller

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.CatalogAdminRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.product.domain.service.SellingPriceService
import com.mostafasensei.alamelmarateb.modules.product.domain.service.SellingPriceView
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import jakarta.validation.constraints.NotNull
import org.springframework.http.ResponseEntity
import com.mostafasensei.alamelmarateb.core.security.ManagerApi
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.math.BigDecimal
import java.util.UUID

@Tag(name = "Catalog (selling prices)", description = "Channel prices + history — BRANCH_MANAGER")
@RestController
@ManagerApi
class SetSellingPriceController(
    private val sellingPriceService: SellingPriceService,
) : BaseController() {

    @Operation(summary = "Set channel price (PLATFORM/STAFF/DEALER)")
    @PostMapping(CatalogAdminRoutes.SELLING_PRICES)
    fun setPrice(
        @Valid @RequestBody request: SellingPriceRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<SellingPriceView>> =
        created(
            sellingPriceService.setPrice(
                request.variantId,
                request.channel ?: "STAFF",
                request.price,
                by = principal.fullName,
            ),
        )

}

data class SellingPriceRequest(
    @field:NotNull val variantId: UUID,
    val channel: String? = null,
    @field:NotNull val price: BigDecimal,
)
