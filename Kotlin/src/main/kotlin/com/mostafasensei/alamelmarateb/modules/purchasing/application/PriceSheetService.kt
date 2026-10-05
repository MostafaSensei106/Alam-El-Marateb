package com.mostafasensei.alamelmarateb.modules.purchasing.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogService
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.product.data.repository.PriceSheetLineRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductVariantRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.SellingPriceRepository
import com.mostafasensei.alamelmarateb.modules.product.data.repository.SupplierPriceSheetRepository
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.PriceSheetLineJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.SellingPriceJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.SupplierPriceSheetJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.service.SalesChannels
import com.mostafasensei.alamelmarateb.modules.purchasing.data.repository.SupplierRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.math.RoundingMode
import java.time.LocalDate
import java.time.ZoneOffset
import java.util.UUID

data class SheetLineInput(val variantId: UUID, val listCost: BigDecimal, val suggestedSelling: BigDecimal)

data class PriceSheetView(
    val id: UUID?,
    val supplierId: UUID?,
    val sheetNo: String,
    val validFrom: LocalDate?,
    val validUntil: LocalDate?,
    val lines: List<SheetLineView> = emptyList(),
)

data class SheetLineView(val variantId: UUID?, val listCost: BigDecimal, val suggestedSelling: BigDecimal)

/**
 * Supplier price sheets: official cost/suggested-price per period.
 * Applying a sheet writes new [selling_prices] rows (history kept);
 * old inventory batches keep their own cost untouched.
 */
@Service
class PriceSheetService(
    private val sheetRepository: SupplierPriceSheetRepository,
    private val lineRepository: PriceSheetLineRepository,
    private val sellingPriceRepository: SellingPriceRepository,
    private val supplierRepository: SupplierRepository,
    private val variantRepository: ProductVariantRepository,
    private val auditLog: AuditLogService,
) {
    @Transactional
    fun createSheet(
        supplierId: UUID,
        sheetNo: String,
        validFrom: LocalDate,
        validUntil: LocalDate?,
        lines: List<SheetLineInput>,
        by: String? = null,
    ): PriceSheetView {
        supplierRepository.findById(supplierId)
            .orElseThrow { NotFoundException("error.purchasing.supplier_not_found", listOf(supplierId)) }
        if (sheetNo.isBlank()) throw BadRequestException("error.pricing.sheet_no_required")
        if (validUntil != null && validUntil.isBefore(validFrom)) {
            throw BadRequestException("error.pricing.sheet_dates")
        }
        if (lines.isEmpty()) throw BadRequestException("error.purchasing.po_empty_items")
        if (sheetRepository.findBySupplierIdOrderByValidFromDesc(supplierId).any { it.sheetNo == sheetNo }) {
            throw ConflictException("error.pricing.sheet_exists", listOf(sheetNo))
        }
        lines.forEach {
            variantRepository.findById(it.variantId)
                ?: throw NotFoundException("error.purchasing.unknown_variant", listOf(it.variantId))
            if (it.listCost.compareTo(BigDecimal.ZERO) < 0 || it.suggestedSelling.compareTo(BigDecimal.ZERO) < 0) {
                throw BadRequestException("error.pricing.price_negative")
            }
        }
        // Auto-close the previously open sheet so periods never overlap.
        sheetRepository.findBySupplierIdOrderByValidFromDesc(supplierId)
            .firstOrNull { it.validUntil == null && it.validFrom!!.isBefore(validFrom) }
            ?.let {
                it.validUntil = validFrom.minusDays(1)
                sheetRepository.save(it)
            }
        val sheet = sheetRepository.save(
            SupplierPriceSheetJpaEntity(
                supplierId = supplierId,
                sheetNo = sheetNo.trim(),
                validFrom = validFrom,
                validUntil = validUntil,
            ),
        )
        lines.forEach {
            lineRepository.save(
                PriceSheetLineJpaEntity(
                    sheetId = sheet.id,
                    variantId = it.variantId,
                    listCost = it.listCost.money(),
                    suggestedSelling = it.suggestedSelling.money(),
                ),
            )
        }
        auditLog.record("SHEET_CREATE", "price_sheet", sheet.id, null, by, "supplier=$supplierId no=$sheetNo")
        return getSheet(sheet.id!!)
    }

    @Transactional(readOnly = true)
    fun listSheets(supplierId: UUID): List<PriceSheetView> =
        sheetRepository.findBySupplierIdOrderByValidFromDesc(supplierId).map { toView(it, emptyList()) }

    @Transactional(readOnly = true)
    fun getSheet(id: UUID): PriceSheetView {
        val sheet = sheetRepository.findById(id)
            .orElseThrow { NotFoundException("error.pricing.sheet_not_found", listOf(id)) }
        val lines = lineRepository.findBySheetId(id).map { SheetLineView(it.variantId, it.listCost, it.suggestedSelling) }
        return toView(sheet, lines)
    }

    /**
     * Apply sheet -> new channel prices effective from sheet.validFrom.
     * Future sheets take effect automatically when their date arrives.
     */
    @Transactional
    fun applySheet(id: UUID, channels: List<String>, by: String? = null): Int {
        val sheet = sheetRepository.findById(id)
            .orElseThrow { NotFoundException("error.pricing.sheet_not_found", listOf(id)) }
        val targets = channels.ifEmpty { listOf(SalesChannels.PLATFORM, SalesChannels.STAFF, SalesChannels.DEALER) }
        targets.forEach {
            if (it != SalesChannels.PLATFORM && it != SalesChannels.STAFF && it != SalesChannels.DEALER) {
                throw BadRequestException("error.pricing.unknown_channel", listOf(it))
            }
        }
        val effective = sheet.validFrom!!.atStartOfDay().toInstant(ZoneOffset.UTC)
        var count = 0
        lineRepository.findBySheetId(id).forEach { line ->
            targets.forEach { channel ->
                sellingPriceRepository.save(
                    SellingPriceJpaEntity(
                        variantId = line.variantId,
                        channel = channel,
                        price = line.suggestedSelling,
                        effectiveFrom = effective,
                    ),
                )
                count++
            }
        }
        auditLog.record("SHEET_APPLY", "price_sheet", id, null, by, "channels=$targets rows=$count")
        return count
    }

    private fun toView(e: SupplierPriceSheetJpaEntity, lines: List<SheetLineView>) = PriceSheetView(
        id = e.id,
        supplierId = e.supplierId,
        sheetNo = e.sheetNo,
        validFrom = e.validFrom,
        validUntil = e.validUntil,
        lines = lines,
    )

    private fun BigDecimal.money(): BigDecimal = setScale(2, RoundingMode.HALF_EVEN)
}
