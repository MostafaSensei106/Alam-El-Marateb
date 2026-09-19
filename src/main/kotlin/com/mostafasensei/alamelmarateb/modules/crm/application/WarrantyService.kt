package com.mostafasensei.alamelmarateb.modules.crm.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogService
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.crm.data.repository.WarrantyClaimRepository
import com.mostafasensei.alamelmarateb.modules.crm.data.repository.WarrantyRepository
import com.mostafasensei.alamelmarateb.modules.crm.domain.entity.WarrantyClaimJpaEntity
import com.mostafasensei.alamelmarateb.modules.crm.domain.entity.WarrantyJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductVariantRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.InvoiceRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.OrderRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.Instant
import java.time.LocalDate
import java.util.UUID

data class WarrantyView(
    val id: UUID?,
    val invoiceId: UUID?,
    val coversUntil: LocalDate?,
    val status: String,
    val valid: Boolean,
)

data class ClaimView(
    val id: UUID?,
    val warrantyId: UUID?,
    val status: String,
    val description: String,
    val inspectionAt: Instant?,
    val resolution: String?,
)

@Service
class WarrantyService(
    private val warrantyRepository: WarrantyRepository,
    private val claimRepository: WarrantyClaimRepository,
    private val invoiceRepository: InvoiceRepository,
    private val orderRepository: OrderRepository,
    private val variantRepository: ProductVariantRepository,
    private val productRepository: ProductRepository,
    private val auditLog: AuditLogService,
) {

    /** One certificate per invoice; coverage = max warranty years of its products. */
    @Transactional
    fun register(invoiceId: UUID, by: String?): WarrantyView {
        warrantyRepository.findByInvoiceId(invoiceId).ifPresent {
            throw ConflictException("Warranty already registered for this invoice")
        }
        val invoice = invoiceRepository.findById(invoiceId)
            .orElseThrow { NotFoundException("Invoice not found") }
        val order = orderRepository.findById(invoice.orderId!!)
            .orElseThrow { NotFoundException("Order not found") }
        val years = order.lines.mapNotNull { line ->
            val variant = variantRepository.findById(line.variantId!!) ?: return@mapNotNull null
            variant.productId?.let { productRepository.findById(it)?.warrantyYears }
        }.maxOrNull() ?: throw BadRequestException("Invoice has no warrantied items")
        val saved = warrantyRepository.save(
            WarrantyJpaEntity(
                invoiceId = invoiceId,
                coversUntil = LocalDate.now().plusYears(years.toLong()),
                status = "active",
            ),
        )
        auditLog.record("WARRANTY_REGISTER", "warranty", saved.id, order.branchId, by, "coversUntil=${saved.coversUntil}")
        return toView(saved)
    }

    @Transactional(readOnly = true)
    fun verify(warrantyId: UUID): WarrantyView {
        val warranty = warrantyRepository.findById(warrantyId)
            .orElseThrow { NotFoundException("Warranty not found") }
        return toView(refresh(warranty))
    }

    @Transactional(readOnly = true)
    fun myWarranties(customerId: UUID): List<WarrantyView> {
        val invoiceIds = invoiceRepository.findAll()
            .filter { inv ->
                orderRepository.findById(inv.orderId!!).map { it.customerId == customerId }.orElse(false)
            }.map { it.id!! }
        return warrantyRepository.findAll()
            .filter { it.invoiceId in invoiceIds }
            .map { toView(refresh(it)) }
    }

    @Transactional
    fun fileClaim(warrantyId: UUID, description: String, photos: String?, by: String?): ClaimView {
        if (description.isBlank()) throw BadRequestException("Claim description is required")
        val warranty = refresh(
            warrantyRepository.findById(warrantyId).orElseThrow { NotFoundException("Warranty not found") },
        )
        if (!isValid(warranty)) throw ConflictException("Warranty is expired or closed")
        val saved = claimRepository.save(
            WarrantyClaimJpaEntity(warrantyId = warrantyId, status = "reported", description = description, photos = photos),
        )
        auditLog.record("CLAIM_FILE", "claim", saved.id, null, by, null)
        return toClaim(saved)
    }

    @Transactional(readOnly = true)
    fun myClaims(customerId: UUID): List<ClaimView> {
        val mine = myWarranties(customerId).mapNotNull { it.id }.toSet()
        return claimRepository.findAll().filter { it.warrantyId in mine }.map { toClaim(it) }
    }

    @Transactional
    fun scheduleInspection(claimId: UUID, at: Instant, by: String?): ClaimView {
        val claim = loadClaim(claimId)
        if (claim.status != "reported") throw ConflictException("Only reported claims can be scheduled")
        claim.status = "inspecting"
        claim.inspectionAt = at
        auditLog.record("CLAIM_INSPECT", "claim", claimId, null, by, "at=$at")
        return toClaim(claimRepository.save(claim))
    }

    @Transactional
    fun resolve(claimId: UUID, resolution: String, by: String?): ClaimView {
        if (resolution != "repair" && resolution != "replace") throw BadRequestException("Resolution must be repair or replace")
        val claim = loadClaim(claimId)
        if (claim.status != "inspecting" && claim.status != "reported") {
            throw ConflictException("Claim cannot be resolved in status ${claim.status}")
        }
        claim.status = if (resolution == "replace") "replaced" else "repairing"
        claim.resolution = resolution
        auditLog.record("CLAIM_RESOLVE", "claim", claimId, null, by, resolution)
        return toClaim(claimRepository.save(claim))
    }

    @Transactional
    fun close(claimId: UUID, by: String?): ClaimView {
        val claim = loadClaim(claimId)
        claim.status = "closed"
        auditLog.record("CLAIM_CLOSE", "claim", claimId, null, by, null)
        return toClaim(claimRepository.save(claim))
    }

    @Transactional(readOnly = true)
    fun claims(warrantyId: UUID): List<ClaimView> =
        claimRepository.findByWarrantyId(warrantyId).map { toClaim(it) }

    private fun loadClaim(claimId: UUID): WarrantyClaimJpaEntity =
        claimRepository.findById(claimId).orElseThrow { NotFoundException("Claim not found") }

    private fun refresh(w: WarrantyJpaEntity): WarrantyJpaEntity {
        if (w.status == "active" && w.coversUntil!!.isBefore(LocalDate.now())) {
            w.status = "expired"
            return warrantyRepository.save(w)
        }
        return w
    }

    private fun isValid(w: WarrantyJpaEntity): Boolean =
        w.status == "active" && !w.coversUntil!!.isBefore(LocalDate.now())

    private fun toView(w: WarrantyJpaEntity) = WarrantyView(w.id, w.invoiceId, w.coversUntil, w.status, isValid(w))

    private fun toClaim(c: WarrantyClaimJpaEntity) =
        ClaimView(c.id, c.warrantyId, c.status, c.description, c.inspectionAt, c.resolution)
}
