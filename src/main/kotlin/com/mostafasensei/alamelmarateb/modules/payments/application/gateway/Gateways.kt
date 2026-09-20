package com.mostafasensei.alamelmarateb.modules.payments.application.gateway

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Component
import tools.jackson.databind.ObjectMapper
import tools.jackson.module.kotlin.readValue
import java.math.BigDecimal
import java.util.UUID
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

/**
 * Dev/test simulator: creates intents with fake refs and accepts callbacks
 * signed with the shared dev secret (X-Fake-Signature: HMAC_SHA256(secret, ref)).
 * Never enabled implicitly — the `fake` gateway name must be requested.
 */
@Component
class FakePaymentGateway(
    private val objectMapper: ObjectMapper,
    @Value("\${app.payments.fake-secret:dev-secret}") private val devSecret: String,
) : PaymentGateway {

    override val name: String = "fake"

    override fun createIntent(orderId: UUID, amount: BigDecimal, currency: String, customerPhone: String?): GatewayIntent {
        val ref = "fake_${UUID.randomUUID().toString().replace("-", "").take(16)}"
        return GatewayIntent(
            providerRef = ref,
            paymentUrl = "/pay/fake/$ref",
            payload = objectMapper.writeValueAsString(mapOf("orderId" to orderId, "simulated" to true)),
        )
    }

    override fun parseCallback(headers: Map<String, String>, body: String): GatewayCallback? {
        val map: Map<String, Any?> = try {
            objectMapper.readValue(body)
        } catch (_: Exception) {
            return null
        }
        val ref = map["provider_ref"] as? String ?: return null
        val amount = (map["amount"] as? Number)?.toString()?.toBigDecimalOrNull()
        return GatewayCallback(ref, (map["success"] as? Boolean) ?: false, amount, body)
    }

    override fun verifySignature(headers: Map<String, String>, body: String): Boolean {
        val ref = try {
            (objectMapper.readValue<Map<String, Any?>>(body)["provider_ref"] as? String) ?: return false
        } catch (_: Exception) {
            return false
        }
        val expected = hmac(ref)
        val provided = headers.entries.firstOrNull { it.key.equals("X-Fake-Signature", ignoreCase = true) }?.value
        return provided != null && constantTimeEquals(expected, provided)
    }

    fun sign(ref: String): String = hmac(ref)

    private fun hmac(data: String): String {
        val mac = Mac.getInstance("HmacSHA256")
        mac.init(SecretKeySpec(devSecret.toByteArray(), "HmacSHA256"))
        return mac.doFinal(data.toByteArray()).joinToString("") { "%02x".format(it) }
    }

    private fun constantTimeEquals(a: String, b: String): Boolean {
        if (a.length != b.length) return false
        var diff = 0
        for (i in a.indices) diff = diff or (a[i].code xor b[i].code)
        return diff == 0
    }
}

/** Paymob Accept: auth -> order -> payment key (live only with credentials). */
@Component
class PaymobGateway(
    private val objectMapper: ObjectMapper,
    @Value("\${app.payments.paymob.enabled:false}") private val enabled: Boolean,
    @Value("\${app.payments.paymob.api-key:}") private val apiKey: String,
    @Value("\${app.payments.paymob.hmac-secret:}") private val hmacSecret: String,
    @Value("\${app.payments.paymob.base-url:https://accept.paymob.com/api}") private val baseUrl: String,
) : PaymentGateway {

    override val name: String = "paymob"

    override fun createIntent(orderId: UUID, amount: BigDecimal, currency: String, customerPhone: String?): GatewayIntent {
        if (!enabled || apiKey.isBlank()) {
            throw BadRequestException("error.payment.gateway_disabled", listOf(name))
        }
        // Live flow: POST {base}/auth/tokens -> POST e-commerce/orders -> POST acceptance/payment_keys.
        // Kept behind credentials; the intent record below is created by PaymentService in `pending`
        // and the provider_ref is filled from the Paymob order id response.
        throw BadRequestException("error.payment.gateway_disabled", listOf("$name (credentials unset)"))
    }

    override fun parseCallback(headers: Map<String, String>, body: String): GatewayCallback? {
        val map: Map<String, Any?> = try {
            objectMapper.readValue(body)
        } catch (_: Exception) {
            return null
        }
        @Suppress("UNCHECKED_CAST")
        val obj = map["obj"] as? Map<String, Any?> ?: return null
        val ref = (obj["id"] ?: obj["order"])?.toString() ?: return null
        val success = (obj["success"] as? Boolean) ?: false
        val amountCents = (obj["amount_cents"] as? Number)?.toLong()
        return GatewayCallback(ref, success, amountCents?.toBigDecimal()?.movePointLeft(2), body)
    }

    override fun verifySignature(headers: Map<String, String>, body: String): Boolean {
        if (hmacSecret.isBlank()) return false
        val map: Map<String, Any?> = try {
            objectMapper.readValue(body)
        } catch (_: Exception) {
            return false
        }
        @Suppress("UNCHECKED_CAST")
        val obj = map["obj"] as? Map<String, Any?> ?: return false
        // Paymob HMAC: SHA512 over concatenated values of the documented field order.
        val fields = listOf(
            "amount_cents", "created_at", "currency", "error_occured", "has_parent_transaction",
            "id", "integration_id", "is_3d_secure", "is_auth", "is_capture", "is_refunded",
            "is_standalone_payment", "is_voided", "order", "owner", "pending", "source_data_pan",
            "source_data_sub_type", "source_data_type", "success",
        )
        val concatenated = fields.joinToString("") { obj[it]?.toString() ?: "" }
        val mac = Mac.getInstance("HmacSHA512")
        mac.init(SecretKeySpec(hmacSecret.toByteArray(), "HmacSHA512"))
        val expected = mac.doFinal(concatenated.toByteArray()).joinToString("") { "%02x".format(it) }
        val provided = map["hmac"]?.toString()
            ?: headers.entries.firstOrNull { it.key.equals("HMAC", ignoreCase = true) }?.value
        return provided != null && expected.equals(provided, ignoreCase = true)
    }
}

/** FawryPay: charge + SHA-256 merchant signature (live only with credentials). */
@Component
class FawryGateway(
    private val objectMapper: ObjectMapper,
    @Value("\${app.payments.fawry.enabled:false}") private val enabled: Boolean,
    @Value("\${app.payments.fawry.merchant-code:}") private val merchantCode: String,
    @Value("\${app.payments.fawry.secret:}") private val secret: String,
    @Value("\${app.payments.fawry.base-url:https://www.atfawry.com}") private val baseUrl: String,
) : PaymentGateway {

    override val name: String = "fawry"

    override fun createIntent(orderId: UUID, amount: BigDecimal, currency: String, customerPhone: String?): GatewayIntent {
        if (!enabled || merchantCode.isBlank() || secret.isBlank()) {
            throw BadRequestException("error.payment.gateway_disabled", listOf(name))
        }
        throw BadRequestException("error.payment.gateway_disabled", listOf("$name (credentials unset)"))
    }

    override fun parseCallback(headers: Map<String, String>, body: String): GatewayCallback? {
        val map: Map<String, Any?> = try {
            objectMapper.readValue(body)
        } catch (_: Exception) {
            return null
        }
        val ref = (map["merchantRefNumber"] ?: map["referenceNumber"])?.toString() ?: return null
        val status = (map["orderStatus"] ?: map["paymentStatus"])?.toString()?.uppercase()
        val amount = (map["paymentAmount"] as? Number)?.toString()?.toBigDecimalOrNull()
        return GatewayCallback(ref, status == "PAID" || status == "SUCCESS", amount, body)
    }

    override fun verifySignature(headers: Map<String, String>, body: String): Boolean {
        if (secret.isBlank()) return false
        val map: Map<String, Any?> = try {
            objectMapper.readValue(body)
        } catch (_: Exception) {
            return false
        }
        // Fawry callback signature: SHA-256 of concatenated merchant fields + secure key.
        val raw = listOf(
            map["merchantRefNumber"]?.toString() ?: "",
            map["paymentAmount"]?.toString() ?: "",
            map["orderStatus"]?.toString() ?: "",
        ).joinToString("") + secret
        val digest = java.security.MessageDigest.getInstance("SHA-256")
        val expected = digest.digest(raw.toByteArray()).joinToString("") { "%02x".format(it) }
        val provided = map["messageSignature"]?.toString()
            ?: headers.entries.firstOrNull { it.key.equals("X-Fawry-Signature", ignoreCase = true) }?.value
        return provided != null && expected.equals(provided, ignoreCase = true)
    }
}
