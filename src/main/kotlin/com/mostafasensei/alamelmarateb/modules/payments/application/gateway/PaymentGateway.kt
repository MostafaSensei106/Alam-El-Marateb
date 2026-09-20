package com.mostafasensei.alamelmarateb.modules.payments.application.gateway

import java.math.BigDecimal
import java.util.UUID

data class GatewayIntent(
    val providerRef: String,
    /** Where the customer completes payment (checkout page / mobile SDK hint). */
    val paymentUrl: String?,
    val payload: String,
)

data class GatewayCallback(
    val providerRef: String,
    val success: Boolean,
    val amount: BigDecimal?,
    val raw: String,
)

/**
 * Payment provider port. Live gateways are config-gated and throw
 * gateway_disabled until credentials are set; `fake` simulates the full
 * loop for dev/tests with a shared dev secret.
 */
interface PaymentGateway {
    val name: String
    fun createIntent(orderId: UUID, amount: BigDecimal, currency: String, customerPhone: String?): GatewayIntent

    /** Returns null when the callback carries no recognizable reference. */
    fun parseCallback(headers: Map<String, String>, body: String): GatewayCallback?

    /** HMAC/signature verification — MUST pass before any state change. */
    fun verifySignature(headers: Map<String, String>, body: String): Boolean
}
