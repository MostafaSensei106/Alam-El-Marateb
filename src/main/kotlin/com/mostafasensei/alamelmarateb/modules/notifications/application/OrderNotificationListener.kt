package com.mostafasensei.alamelmarateb.modules.notifications.application

import com.mostafasensei.alamelmarateb.core.events.OrderDeliveredEvent
import com.mostafasensei.alamelmarateb.core.events.OrderInvoicedEvent
import org.springframework.stereotype.Component
import org.springframework.transaction.event.TransactionPhase
import org.springframework.transaction.event.TransactionalEventListener

/**
 * Turns order events into queued notifications (Phase 2: async by design).
 *
 * The checkout/delivery transaction never waits for a provider: this
 * listener only inserts a `notifications` row (same outbox philosophy —
 * durable first, delivered later by the 5-minute dispatcher). The `ref`
 * key (`order-delivered:{id}`, `order-receipt:{id}`) makes redelivered
 * events a no-op via NotificationService.queue's pending-ref check.
 */
@Component
class OrderNotificationListener(
    private val notifications: NotificationService,
) {

    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT, fallbackExecution = true)
    fun onOrderInvoiced(event: OrderInvoicedEvent) {
        notifications.queue(
            channel = "log",
            recipient = "order:${event.orderId}",
            ref = "order-receipt:${event.orderId}",
            titles = mapOf(
                "ar" to "فاتورة جديدة",
                "en" to "New invoice",
            ),
            bodies = mapOf(
                "ar" to "تم إصدار فاتورة طلبك (${event.lines.sumOf { it.qty }} قطعة) — شكراً لتسوقك معنا",
                "en" to "Your order invoice is ready (${event.lines.sumOf { it.qty }} items) — thank you",
            ),
        )
    }

    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT, fallbackExecution = true)
    fun onOrderDelivered(event: OrderDeliveredEvent) {
        notifications.queue(
            channel = "log",
            recipient = event.customerId?.toString() ?: "order:${event.orderId}",
            ref = "order-delivered:${event.orderId}",
            titles = mapOf(
                "ar" to "تم التوصيل",
                "en" to "Delivered",
            ),
            bodies = mapOf(
                "ar" to "تم توصيل طلبك بإجمالي ${event.grandTotal} — قيّم تجربتك",
                "en" to "Your order (${event.grandTotal}) was delivered — please rate us",
            ),
        )
    }
}
