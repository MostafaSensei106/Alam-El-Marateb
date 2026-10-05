package com.mostafasensei.alamelmarateb.modules.product.data.repository

import com.mostafasensei.alamelmarateb.modules.product.domain.entity.PriceSheetLineJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.SellingPriceJpaEntity
import com.mostafasensei.alamelmarateb.modules.product.domain.entity.SupplierPriceSheetJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface SupplierPriceSheetRepository : JpaRepository<SupplierPriceSheetJpaEntity, UUID> {
    fun findBySupplierIdOrderByValidFromDesc(supplierId: UUID): List<SupplierPriceSheetJpaEntity>
}

@Repository
interface PriceSheetLineRepository : JpaRepository<PriceSheetLineJpaEntity, UUID> {
    fun findBySheetId(sheetId: UUID): List<PriceSheetLineJpaEntity>
}

@Repository
interface SellingPriceRepository : JpaRepository<SellingPriceJpaEntity, UUID> {
    fun findByVariantIdOrderByEffectiveFromDesc(variantId: UUID): List<SellingPriceJpaEntity>
    fun findByVariantIdAndChannelOrderByEffectiveFromDesc(variantId: UUID, channel: String): List<SellingPriceJpaEntity>
}
