package com.mostafasensei.alamelmarateb.modules.notifications.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.router.AnalyticsRoutes
import com.mostafasensei.alamelmarateb.modules.notifications.application.NotificationService
import com.mostafasensei.alamelmarateb.modules.notifications.application.NotificationView
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

/**
 * Notification outbox reads — BRANCH_MANAGER (follow-up opportunities).
 * Writes happen via scheduler jobs; providers plug in via NotificationSender.
 */
@Tag(name = "Notifications", description = "Outbox reads — BRANCH_MANAGER")
@RestController
@RequestMapping(AnalyticsRoutes.BASE)
@PreAuthorize("hasAnyRole('BRANCH_MANAGER', 'SUPER_ADMIN')")
class NotificationController(
    private val notifications: NotificationService,
) : BaseController() {

    @Operation(summary = "Pending notifications (follow-up queue)")
    @GetMapping("/notifications")
    fun pending(@RequestParam(defaultValue = "100") limit: Int): ResponseEntity<ApiResponse<List<NotificationView>>> =
        ok(notifications.pending(limit.coerceIn(1, 500)))
}
