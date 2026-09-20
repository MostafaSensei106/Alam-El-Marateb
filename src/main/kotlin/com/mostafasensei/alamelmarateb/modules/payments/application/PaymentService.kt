package com.mostafasensei.alamelmarateb.modules.payments.application

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.core.exceptions.UnprocessableException
import com.mostafasensei.alamelmarateb.modules.payments.application.gateway.PaymentGateway
import com.mostafasensei.alamelmarateb.modules.payments.data.repository.PaymentIntentRepository
import com.mostafasensei.alamelmarateb.modules.payments.domain.entity.PaymentIntentJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.application.OrderService
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.PaymentStatus
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import tools.jackson.databind.ObjectMapper
import java.math.BigDecimal
import java.util.UUID

data class PaymentIntentView(
    val id: UUID?,
    val orderId: UUID?,
    val gateway: String,
    val amount: BigDecimal,
    val currency: String,
    val status: String,
    val providerRef: String?,
    val paymentUrl: String?,
)

@Service
class PaymentService(
    private val intentRepository: PaymentIntentRepository,
    private val orderService: OrderService,
    private val gateways: List<PaymentGateway>,
    private val objectMapper: ObjectMapper,
) {

    private fun gateway(name: String): PaymentGateway =
        gateways.firstOrNull { it.name == name.lowercase() }
            ?: throw NotFoundException("error.payment.unknown_gateway", listOf(name))

    @Transactional
    fun createIntent(orderId: UUID, gatewayName: String, customerId: UUID?, guestPhone: String?): PaymentIntentView {
        val order = orderService.trackById(orderId)
        if (customerId != null && order.customerId != customerId) {
            throw NotFoundException("error.delivery.order_not_found")
        }
        if (customerId == null && guestPhone != null && order.guestPhone != guestPhone) {
            throw NotFoundException("error.delivery.order_not_found")
        }
        if (order.paymentStatus != PaymentStatus.pending_confirmation && order.paymentStatus != PaymentStatus.unpaid && order.paymentStatus != PaymentStatus.partial) {
            throw ConflictException("error.payment.bad_status", listOf(order.paymentStatus.name))
        }
        val gw = gateway(gatewayName)
        val created = gw.createIntent(orderId, order.grandTotal, "EGP", order.guestPhone)
        val saved = intentRepository.save(
            PaymentIntentJpaEntity(
                orderId = orderId, gateway = gw.name, amount = order.grandTotal,
                status = "pending", providerRef = created.providerRef, payload = created.payload,
            ),
        )
        return toView(saved, created.paymentUrl)
    }

    /**
     * Provider callback: verify signature FIRST, then apply idempotently.
     * Unknown ref + valid signature -> 404 (never invent money).
     */
    @Transactional
    fun handleCallback(gatewayName: String, headers: Map<String, String>, body: String): PaymentIntentView {
        val gw = gateway(gatewayName)
        if (!gw.verifySignature(headers, body)) {
            throw UnprocessableException("error.payment.bad_signature")
        }
        val parsed = gw.parseCallback(headers, body)
            ?: throw BadRequestException("error.payment.intent_not_found")
        val intent = intentRepository.findByProviderRef(parsed.providerRef)
            .orElseThrow { NotFoundException("error.payment.intent_not_found") }
        if (intent.status == "captured") return toView(intent, null)
        if (intent.status != "pending" && intent.status != "authorized") {
            throw ConflictException("error.payment.bad_status", listOf(intent.status))
        }
        if (!parsed.success) {
            intent.status = "failed"
            return toView(intentRepository.save(intent), null)
        }
        if (parsed.amount != null && parsed.amount.compareTo(intent.amount) != 0) {
            intent.status = "failed"
            intentRepository.save(intent)
            throw UnprocessableException("error.payment.amount_mismatch")
        }
        intent.status = "captured"
        intent.payload = body
        val saved = intentRepository.save(intent)
        orderService.confirmPayment(intent.orderId!!, "gateway:${gw.name}")
        return toView(saved, null)
    }

    @Transactional(readOnly = true)
    fun intentsForOrder(orderId: UUID): List<PaymentIntentView> =
        intentRepository.findByOrderIdOrderByCreatedAtDesc(orderId).map { toView(it, null) }

    private fun toView(e: PaymentIntentJpaEntity, paymentUrl: String?) = PaymentIntentView(
        e.id, e.orderId, e.gateway, e.amount, e.currency, e.status, e.providerRef, paymentUrl,
    )
}
