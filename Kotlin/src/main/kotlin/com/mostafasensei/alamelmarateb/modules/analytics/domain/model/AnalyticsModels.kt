package com.mostafasensei.alamelmarateb.modules.analytics.domain.model

import java.math.BigDecimal
import java.util.UUID

data class DashboardSummary(
    val warehouses: Int,
    val activeProducts: Int,
    val lowStockCount: Int,
    val pendingTransfers: Int,
    val openAudits: Int,
    val stockValueByWarehouse: List<WarehouseStockValue>,
    val totalStockValue: BigDecimal,
)

data class WarehouseStockValue(
    val warehouseId: UUID,
    val warehouseName: String,
    val totalQty: Int,
    val value: BigDecimal,
)

data class ProductVelocity(
    val variantId: UUID,
    val sold30d: Int,
    val currentQty: Int,
    val dailyAverage: BigDecimal,
    val daysOfCover: Int?,
)

data class AuditEntry(
    val actor: String?,
    val action: String,
    val entity: String,
    val entityId: UUID?,
    val details: String?,
    val at: String,
)
