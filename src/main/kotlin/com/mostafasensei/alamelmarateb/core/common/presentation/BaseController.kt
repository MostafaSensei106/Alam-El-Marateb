package com.mostafasensei.alamelmarateb.core.common.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.api_response.PagedResponse
import org.springframework.data.domain.Page
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity

/**
 * Shared controller helpers — single place for ApiResponse wrapping,
 * status codes and pagination so feature controllers stay thin.
 *
 * Rules:
 * - POST create -> 201 via [created]
 * - DELETE -> 200 with message via [deleted] (or 204 via [noContent])
 * - GET one missing -> throw NotFoundException (handled globally), don't build 404 manually
 * - GET list -> [paged] with Pageable
 */
abstract class BaseController {

    protected fun <T> ok(data: T, message: String = "Operation Successful"): ResponseEntity<ApiResponse<T>> =
        ResponseEntity.ok(ApiResponse.success(data, message))

    protected fun <T> created(data: T, message: String = "Created Successfully"): ResponseEntity<ApiResponse<T>> =
        ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(data, message))

    protected fun deleted(message: String): ResponseEntity<ApiResponse<Nothing>> =
        ResponseEntity.ok(ApiResponse.messageWithoutData(message))

    protected fun noContent(): ResponseEntity<Void> =
        ResponseEntity.noContent().build()

    protected fun <T : Any> paged(
        page: Page<T>,
        message: String = "Operation Successful",
    ): ResponseEntity<ApiResponse<PagedResponse<T>>> =
        ResponseEntity.ok(
            ApiResponse.success(
                PagedResponse.of(page.content, page.number, page.size, page.totalElements),
                message,
            ),
        )

    protected fun <T : Any> paged(
        items: List<T>,
        page: Int,
        size: Int,
        totalElements: Long,
        message: String = "Operation Successful",
    ): ResponseEntity<ApiResponse<PagedResponse<T>>> =
        ResponseEntity.ok(ApiResponse.success(PagedResponse.of(items, page, size, totalElements), message))
}
