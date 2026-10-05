package com.mostafasensei.alamelmarateb.modules.product.domain.controller

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.CatalogAdminRoutes
import com.mostafasensei.alamelmarateb.core.router.CatalogStoreRoutes
import com.mostafasensei.alamelmarateb.core.router.CrmAdminRoutes
import com.mostafasensei.alamelmarateb.core.router.PortalRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductVariant
import com.mostafasensei.alamelmarateb.modules.product.domain.model.BrandCreateRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.BrandUpdateRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.BracketRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.BracketUpdateRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.CustomQuoteRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.MeterPriceRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.ProductPublicResponse
import com.mostafasensei.alamelmarateb.modules.product.domain.model.ProductVariantPublicResponse
import com.mostafasensei.alamelmarateb.modules.product.domain.model.toPublic
import com.mostafasensei.alamelmarateb.modules.product.domain.model.QaAnswerRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.QaAskRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.QuickCreateRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.QuizAnswerRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.QuizRecommendRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.ReviewCreateRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.ReviewModerateRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.VariantAttributeDto
import com.mostafasensei.alamelmarateb.modules.product.domain.model.VariantAttributeRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.pricing.CustomQuote
import com.mostafasensei.alamelmarateb.modules.product.domain.service.BracketView
import com.mostafasensei.alamelmarateb.modules.product.domain.service.BrandService
import com.mostafasensei.alamelmarateb.modules.product.domain.service.BrandView
import com.mostafasensei.alamelmarateb.modules.product.domain.service.CustomSizeService
import com.mostafasensei.alamelmarateb.modules.product.domain.service.MeterPriceView
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductImageService
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductImageView
import com.mostafasensei.alamelmarateb.modules.product.domain.service.QaService
import com.mostafasensei.alamelmarateb.modules.product.domain.service.QuestionView
import com.mostafasensei.alamelmarateb.modules.product.domain.service.QuizAnswer
import com.mostafasensei.alamelmarateb.modules.product.domain.service.QuizQuestionView
import com.mostafasensei.alamelmarateb.modules.product.domain.service.QuizService
import com.mostafasensei.alamelmarateb.modules.product.domain.service.Recommendation
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ReviewService
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ReviewSummary
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ReviewView
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.http.ResponseEntity
import org.springframework.security.authentication.BadCredentialsException
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

@Tag(name = "Catalog extras (management)", description = "Quick-create, brands, variant attributes — BRANCH_MANAGER")
@RestController
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class ListVariantAttributesController(
    private val catalogService: ProductCatalogService,
    private val brandService: BrandService,
    private val reviewService: ReviewService,
) : BaseController() {

    @Operation(summary = "Variant attributes (EAV on variant)")
    @GetMapping(CatalogAdminRoutes.VARIANT_ATTRIBUTES)
    fun variantAttrs(@PathVariable variantId: UUID): ResponseEntity<ApiResponse<List<VariantAttributeDto>>> =
        ok(catalogService.variantAttributes(variantId))

}
