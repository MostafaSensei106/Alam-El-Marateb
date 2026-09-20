package com.mostafasensei.alamelmarateb.modules.crm.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.core.router.CrmAdminRoutes
import com.mostafasensei.alamelmarateb.core.router.PortalRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.crm.application.AddressView
import com.mostafasensei.alamelmarateb.modules.crm.application.ClaimView
import com.mostafasensei.alamelmarateb.modules.crm.application.CrmService
import com.mostafasensei.alamelmarateb.modules.crm.application.ProfileView
import com.mostafasensei.alamelmarateb.modules.crm.application.WarrantyService
import com.mostafasensei.alamelmarateb.modules.crm.application.WarrantyView
import com.mostafasensei.alamelmarateb.modules.crm.presentation.dto.AddressRequest
import com.mostafasensei.alamelmarateb.modules.crm.presentation.dto.ClaimFileRequest
import com.mostafasensei.alamelmarateb.modules.crm.presentation.dto.FavoriteRequest
import com.mostafasensei.alamelmarateb.modules.crm.presentation.dto.InspectionRequest
import com.mostafasensei.alamelmarateb.modules.crm.presentation.dto.ProfileRequest
import com.mostafasensei.alamelmarateb.modules.crm.presentation.dto.ResolveRequest
import com.mostafasensei.alamelmarateb.modules.crm.presentation.dto.WarrantyRegisterRequest
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

/**
 * CRM MANAGEMENT — /api/v1/crm/... Managers only.
 */
@Tag(name = "CRM (management)", description = "Warranties, claims — BRANCH_MANAGER")
@RestController
@RequestMapping(CrmAdminRoutes.BASE)
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class CrmAdminController(
    private val warrantyService: WarrantyService,
) : BaseController() {

    @Operation(summary = "Register warranty certificate for an invoice")
    @PostMapping("/warranties/register")
    fun registerWarranty(
        @Valid @RequestBody request: WarrantyRegisterRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<WarrantyView>> =
        created(warrantyService.register(request.invoiceId, principal.fullName))

    @Operation(summary = "Verify warranty")
    @GetMapping("/warranties/{warrantyId}")
    fun verifyWarranty(@PathVariable warrantyId: UUID): ResponseEntity<ApiResponse<WarrantyView>> =
        ok(warrantyService.verify(warrantyId))

    @Operation(summary = "Warranty claims")
    @GetMapping("/warranties/{warrantyId}/claims")
    fun claims(@PathVariable warrantyId: UUID): ResponseEntity<ApiResponse<List<ClaimView>>> =
        ok(warrantyService.claims(warrantyId))

    @Operation(summary = "Schedule inspection")
    @PostMapping("/claims/{claimId}/inspection")
    fun scheduleInspection(
        @PathVariable claimId: UUID,
        @Valid @RequestBody request: InspectionRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<ClaimView>> =
        ok(warrantyService.scheduleInspection(claimId, request.inspectionAt, principal.fullName))

    @Operation(summary = "Resolve claim (repair/replace)")
    @PostMapping("/claims/{claimId}/resolve")
    fun resolve(
        @PathVariable claimId: UUID,
        @Valid @RequestBody request: ResolveRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<ClaimView>> =
        ok(warrantyService.resolve(claimId, request.resolution, principal.fullName))

    @Operation(summary = "Close claim")
    @PostMapping("/claims/{claimId}/close")
    fun close(
        @PathVariable claimId: UUID,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<ClaimView>> =
        ok(warrantyService.close(claimId, principal.fullName))
}

/**
 * Customer PORTAL — /api/v1/portal/... Own data only.
 */
@Tag(name = "Portal (customer)", description = "Profile, addresses, favorites, warranties, claims — CUSTOMER")
@RestController
@RequestMapping(PortalRoutes.BASE)
@PreAuthorize("hasAnyRole('CUSTOMER', 'SUPER_ADMIN')")
class PortalController(
    private val crmService: CrmService,
    private val warrantyService: WarrantyService,
) : BaseController() {

    @Operation(summary = "My profile (upsert)")
    @PostMapping("/profile")
    fun profile(
        @AuthenticationPrincipal principal: UserPrincipal,
        @Valid @RequestBody request: ProfileRequest,
    ): ResponseEntity<ApiResponse<ProfileView>> =
        ok(crmService.profile(principal.id, request.governorate, request.city, request.referralSource, request.birthDate))

    @Operation(summary = "My addresses")
    @GetMapping("/addresses")
    fun addresses(@AuthenticationPrincipal principal: UserPrincipal): ResponseEntity<ApiResponse<List<AddressView>>> =
        ok(crmService.addresses(principal.id))

    @Operation(summary = "Add address")
    @PostMapping("/addresses")
    fun addAddress(
        @AuthenticationPrincipal principal: UserPrincipal,
        @Valid @RequestBody request: AddressRequest,
    ): ResponseEntity<ApiResponse<AddressView>> =
        created(
            crmService.addAddress(
                principal.id, request.label, request.phone, request.governorate,
                request.addressText, request.isDefault, principal.fullName,
            ),
        )

    @Operation(summary = "Remove address")
    @DeleteMapping("/addresses/{addressId}")
    fun removeAddress(
        @AuthenticationPrincipal principal: UserPrincipal,
        @PathVariable addressId: UUID,
    ): ResponseEntity<ApiResponse<Nothing>> {
        crmService.removeAddress(principal.id, addressId)
        return deleted(MessageService.t("success.deleted"))
    }

    @Operation(summary = "My favorites")
    @GetMapping("/favorites")
    fun favorites(@AuthenticationPrincipal principal: UserPrincipal): ResponseEntity<ApiResponse<List<UUID>>> =
        ok(crmService.favorites(principal.id))

    @Operation(summary = "Add favorite")
    @PostMapping("/favorites")
    fun addFavorite(
        @AuthenticationPrincipal principal: UserPrincipal,
        @Valid @RequestBody request: FavoriteRequest,
    ): ResponseEntity<ApiResponse<Nothing>> {
        crmService.addFavorite(principal.id, request.productId)
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.messageWithoutData(MessageService.t("success.created")))
    }

    @Operation(summary = "Remove favorite")
    @DeleteMapping("/favorites/{productId}")
    fun removeFavorite(
        @AuthenticationPrincipal principal: UserPrincipal,
        @PathVariable productId: UUID,
    ): ResponseEntity<ApiResponse<Nothing>> {
        crmService.removeFavorite(principal.id, productId)
        return deleted(MessageService.t("success.deleted"))
    }

    @Operation(summary = "My warranties")
    @GetMapping("/warranties")
    fun myWarranties(@AuthenticationPrincipal principal: UserPrincipal): ResponseEntity<ApiResponse<List<WarrantyView>>> =
        ok(warrantyService.myWarranties(principal.id))

    @Operation(summary = "Register my warranty")
    @PostMapping("/warranties/register")
    fun registerWarranty(
        @AuthenticationPrincipal principal: UserPrincipal,
        @Valid @RequestBody request: WarrantyRegisterRequest,
    ): ResponseEntity<ApiResponse<WarrantyView>> =
        created(warrantyService.register(request.invoiceId, principal.fullName))

    @Operation(summary = "File warranty claim")
    @PostMapping("/warranties/claims")
    fun fileClaim(
        @AuthenticationPrincipal principal: UserPrincipal,
        @Valid @RequestBody request: ClaimFileRequest,
    ): ResponseEntity<ApiResponse<ClaimView>> {
        val mine = warrantyService.myWarranties(principal.id).mapNotNull { it.id }.toSet()
        if (request.warrantyId !in mine) throw NotFoundException("error.portal.warranty_not_found")
        return created(warrantyService.fileClaim(request.warrantyId, request.description, request.photos, principal.fullName))
    }

    @Operation(summary = "My claims")
    @GetMapping("/warranties/claims")
    fun myClaims(@AuthenticationPrincipal principal: UserPrincipal): ResponseEntity<ApiResponse<List<ClaimView>>> =
        ok(warrantyService.myClaims(principal.id))
}
