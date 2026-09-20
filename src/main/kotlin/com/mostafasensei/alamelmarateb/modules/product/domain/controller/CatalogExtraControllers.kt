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
import com.mostafasensei.alamelmarateb.modules.product.domain.model.QaAnswerRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.QaAskRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.QuickCreateRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.QuizAnswerRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.QuizRecommendRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.ReviewCreateRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.ReviewModerateRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.model.VariantAttributeDto
import com.mostafasensei.alamelmarateb.modules.product.domain.model.VariantAttributeRequest
import com.mostafasensei.alamelmarateb.modules.product.domain.service.BrandService
import com.mostafasensei.alamelmarateb.modules.product.domain.service.BrandView
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
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.util.UUID

/**
 * Public discovery — open read (GET permitAll) + anonymous quiz (POST permitAll).
 */
@Tag(name = "Catalog discovery", description = "Search, featured, compare, variants, brands, quiz — public")
@RestController
class CatalogDiscoveryController(
    private val catalogService: ProductCatalogService,
    private val brandService: BrandService,
    private val reviewService: ReviewService,
    private val quizService: QuizService,
    private val qaService: QaService,
) : BaseController() {

    @Operation(summary = "Search products (name/slug/category/brand/price)")
    @GetMapping(CatalogStoreRoutes.PRODUCT_SEARCH)
    fun search(
        @RequestParam(required = false) q: String?,
        @RequestParam(required = false) categoryId: UUID?,
        @RequestParam(required = false) brand: String?,
        @RequestParam(required = false) minPrice: java.math.BigDecimal?,
        @RequestParam(required = false) maxPrice: java.math.BigDecimal?,
    ): ResponseEntity<ApiResponse<List<Product>>> =
        ok(catalogService.search(q, categoryId, brand, minPrice, maxPrice))

    @Operation(summary = "Featured products")
    @GetMapping(CatalogStoreRoutes.PRODUCT_FEATURED)
    fun featured(): ResponseEntity<ApiResponse<List<Product>>> =
        ok(catalogService.featured())

    @Operation(summary = "Compare up to 4 products side-by-side")
    @GetMapping(CatalogStoreRoutes.PRODUCT_COMPARE)
    fun compare(@RequestParam ids: List<UUID>): ResponseEntity<ApiResponse<List<Product>>> =
        ok(catalogService.compare(ids))

    @Operation(summary = "Variants of a product")
    @GetMapping(CatalogStoreRoutes.PRODUCT_VARIANTS)
    fun variants(@PathVariable id: UUID): ResponseEntity<ApiResponse<List<ProductVariant>>> =
        ok(catalogService.getProduct(id)?.variants ?: emptyList())

    @Operation(summary = "Public categories")
    @GetMapping(CatalogStoreRoutes.CATEGORIES)
    fun categories(): ResponseEntity<ApiResponse<List<ProductCategory>>> =
        ok(catalogService.getAllCategories().filter { it.isActive })

    @Operation(summary = "Active brands")
    @GetMapping(CatalogStoreRoutes.BRANDS)
    fun brands(): ResponseEntity<ApiResponse<List<BrandView>>> =
        ok(brandService.listActive())

    @Operation(summary = "Approved reviews + summary for a product")
    @GetMapping(CatalogStoreRoutes.PRODUCT_REVIEWS)
    fun reviews(@PathVariable slug: String): ResponseEntity<ApiResponse<Map<String, Any>>> {
        val product = catalogService.getProductBySlug(slug)
            ?: throw com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException("error.catalog.product_not_found")
        val (items, summary) = reviewService.publicReviews(product.id!!)
        return ok(mapOf("reviews" to items, "summary" to ReviewSummaryDto(summary.average, summary.count)))
    }

    @Operation(summary = "Quiz questions (seedable, active only)")
    @GetMapping(CatalogStoreRoutes.QUIZ)
    fun quiz(): ResponseEntity<ApiResponse<List<QuizQuestionView>>> =
        ok(quizService.questions())

    @Operation(summary = "Quiz recommendation (anonymous allowed)")
    @PostMapping(CatalogStoreRoutes.QUIZ_RECOMMEND)
    fun recommend(
        @Valid @RequestBody request: QuizRecommendRequest,
        @AuthenticationPrincipal principal: UserPrincipal?,
    ): ResponseEntity<ApiResponse<List<Recommendation>>> =
        ok(
            quizService.recommend(
                principal?.id,
                request.answers.map { QuizAnswer(it.questionId, it.optionId) },
                request.categoryId, request.maxPrice, request.limit,
            ),
        )

    @Operation(summary = "Bought-together (from order history)")
    @GetMapping(CatalogStoreRoutes.PRODUCT_BY_SLUG + "/bought-together")
    fun boughtTogether(@PathVariable slug: String): ResponseEntity<ApiResponse<List<Product>>> {
        val product = catalogService.getProductBySlug(slug)
            ?: throw com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException("error.catalog.product_not_found")
        return ok(catalogService.boughtTogether(product.id!!))
    }

    @Operation(summary = "Answered Q&A for a product")
    @GetMapping(CatalogStoreRoutes.PRODUCT_BY_SLUG + "/qa")
    fun qa(@PathVariable slug: String): ResponseEntity<ApiResponse<List<QuestionView>>> {
        val product = catalogService.getProductBySlug(slug)
            ?: throw com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException("error.catalog.product_not_found")
        return ok(qaService.answered(product.id!!))
    }
}

data class ReviewSummaryDto(val average: Double, val count: Int)

/**
 * Catalog management extras — BRANCH_MANAGER.
 */
@Tag(name = "Catalog extras (management)", description = "Quick-create, brands, variant attributes — BRANCH_MANAGER")
@RestController
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class CatalogAdminExtraController(
    private val catalogService: ProductCatalogService,
    private val brandService: BrandService,
    private val reviewService: ReviewService,
) : BaseController() {
    @Operation(summary = "Quick-create product from preset + one size")
    @PostMapping(CatalogAdminRoutes.QUICK_CREATE)
    fun quickCreate(@Valid @RequestBody request: QuickCreateRequest): ResponseEntity<ApiResponse<Product>> =
        created(
            catalogService.quickCreate(
                request.presetId, request.slug, request.name, request.widthCm, request.lengthCm,
                request.heightCm, request.sku, request.costPrice, request.sellingPrice, request.brandId,
            ),
        )

    @Operation(summary = "List brands")
    @GetMapping(CatalogAdminRoutes.BRANDS)
    fun brands(): ResponseEntity<ApiResponse<List<BrandView>>> =
        ok(brandService.listAll())

    @Operation(summary = "Create brand")
    @PostMapping(CatalogAdminRoutes.BRANDS)
    fun createBrand(@Valid @RequestBody request: BrandCreateRequest): ResponseEntity<ApiResponse<BrandView>> =
        created(brandService.create(request.name, request.slug, request.logoUrl, request.description, request.sortOrder, request.translations))

    @Operation(summary = "Update brand")
    @PutMapping(CatalogAdminRoutes.BRAND_BY_ID)
    fun updateBrand(
        @PathVariable id: UUID,
        @Valid @RequestBody request: BrandUpdateRequest,
    ): ResponseEntity<ApiResponse<BrandView>> =
        ok(brandService.update(id, request.name, request.slug, request.logoUrl, request.description, request.sortOrder, request.isActive, request.translations))

    @Operation(summary = "Delete brand")
    @DeleteMapping(CatalogAdminRoutes.BRAND_BY_ID)
    fun deleteBrand(@PathVariable id: UUID): ResponseEntity<ApiResponse<Nothing>> {
        brandService.delete(id)
        return deleted(com.mostafasensei.alamelmarateb.core.i18n.MessageService.t("success.deleted"))
    }

    @Operation(summary = "Variant attributes (EAV on variant)")
    @GetMapping(CatalogAdminRoutes.VARIANT_ATTRIBUTES)
    fun variantAttrs(@PathVariable variantId: UUID): ResponseEntity<ApiResponse<List<VariantAttributeDto>>> =
        ok(catalogService.variantAttributes(variantId))

    @Operation(summary = "Attach variant attribute")
    @PostMapping(CatalogAdminRoutes.VARIANT_ATTRIBUTES)
    fun attachVariantAttr(
        @PathVariable variantId: UUID,
        @Valid @RequestBody request: VariantAttributeRequest,
    ): ResponseEntity<ApiResponse<VariantAttributeDto>> =
        created(catalogService.attachVariantAttribute(variantId, request.attributeId, request.value))
    @Operation(summary = "Moderate review (approve/reject)")
    @PostMapping(CrmAdminRoutes.REVIEW_MODERATE)
    fun moderate(
        @PathVariable id: UUID,
        @Valid @RequestBody request: ReviewModerateRequest,
    ): ResponseEntity<ApiResponse<ReviewView>> =
        ok(reviewService.moderate(id, request.approve))
}

/**
 * Product images — upload (BRANCH_MANAGER) + public list.
 */
@Tag(name = "Catalog images", description = "Product photos — upload is management only")
@RestController
class ProductImageController(
    private val imageService: ProductImageService,
    private val catalogService: ProductCatalogService,
) : BaseController() {

    @Operation(summary = "Upload product image")
    @PostMapping(CatalogAdminRoutes.PRODUCT_IMAGES, consumes = ["multipart/form-data"])
    @PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
    fun upload(
        @PathVariable id: UUID,
        @RequestParam file: org.springframework.web.multipart.MultipartFile,
    ): ResponseEntity<ApiResponse<ProductImageView>> =
        created(imageService.upload(id, file))

    @Operation(summary = "Delete product image")
    @DeleteMapping(CatalogAdminRoutes.IMAGE_BY_ID)
    @PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
    fun delete(@PathVariable imageId: UUID): ResponseEntity<ApiResponse<Nothing>> {
        imageService.delete(imageId)
        return deleted(com.mostafasensei.alamelmarateb.core.i18n.MessageService.t("success.deleted"))
    }

    @Operation(summary = "Public product images")
    @GetMapping(CatalogStoreRoutes.PRODUCT_IMAGES)
    fun list(@PathVariable slug: String): ResponseEntity<ApiResponse<List<ProductImageView>>> {
        val product = catalogService.getProductBySlug(slug)
            ?: throw com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException("error.catalog.product_not_found")
        return ok(imageService.list(product.id!!))
    }
}

/**
 * Customer reviews — CUSTOMER.
 */
@Tag(name = "Reviews (customer)", description = "Submit + my reviews — CUSTOMER")
@RestController
@RequestMapping(PortalRoutes.REVIEWS)
@PreAuthorize("hasAnyRole('CUSTOMER', 'SUPER_ADMIN')")
class PortalReviewController(
    private val reviewService: ReviewService,
    private val qaService: QaService,
) : BaseController() {

    @Operation(summary = "Submit review (verified buyers only)")
    @PostMapping
    fun submit(
        @AuthenticationPrincipal principal: UserPrincipal,
        @Valid @RequestBody request: ReviewCreateRequest,
    ): ResponseEntity<ApiResponse<ReviewView>> =
        created(reviewService.submit(principal.id, request.productId, request.rating, request.title, request.body, request.photos))

    @Operation(summary = "My reviews")
    @GetMapping
    fun mine(@AuthenticationPrincipal principal: UserPrincipal): ResponseEntity<ApiResponse<List<ReviewView>>> =
        ok(reviewService.myReviews(principal.id))

    @Operation(summary = "Mark review helpful")
    @PostMapping("/{id}/helpful")
    fun helpful(@PathVariable id: UUID): ResponseEntity<ApiResponse<ReviewView>> =
        ok(reviewService.helpful(id))

    @Operation(summary = "Ask a product question")
    @PostMapping("/qa")
    fun ask(
        @AuthenticationPrincipal principal: UserPrincipal,
        @Valid @RequestBody request: QaAskRequest,
    ): ResponseEntity<ApiResponse<QuestionView>> =
        created(qaService.ask(principal.id, request.productId, request.question))
}

/**
 * Q&A answers — BRANCH_MANAGER.
 */
@Tag(name = "Q&A (management)", description = "Answer product questions — BRANCH_MANAGER")
@RestController
@RequestMapping(CatalogAdminRoutes.PRODUCTS + "/qa")
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class QaAdminController(
    private val qaService: QaService,
) : BaseController() {

    @Operation(summary = "Answer a question")
    @PostMapping("/{id}/answer")
    fun answer(
        @PathVariable id: UUID,
        @Valid @RequestBody request: QaAnswerRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<QuestionView>> =
        ok(qaService.answer(id, request.answer, principal.fullName))
}
