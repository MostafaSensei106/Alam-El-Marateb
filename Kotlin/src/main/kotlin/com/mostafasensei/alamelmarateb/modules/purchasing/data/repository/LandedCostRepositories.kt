package com.mostafasensei.alamelmarateb.modules.purchasing.data.repository

import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.ShipmentLandedCostAllocationJpaEntity
import com.mostafasensei.alamelmarateb.modules.purchasing.domain.entity.ShipmentLandedCostJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface ShipmentLandedCostRepository : JpaRepository<ShipmentLandedCostJpaEntity, UUID> {
    fun findByShipmentId(shipmentId: UUID): List<ShipmentLandedCostJpaEntity>
}

@Repository
interface ShipmentLandedCostAllocationRepository : JpaRepository<ShipmentLandedCostAllocationJpaEntity, UUID> {
    fun findByLandedCostId(landedCostId: UUID): List<ShipmentLandedCostAllocationJpaEntity>
    fun findByBatchId(batchId: UUID): List<ShipmentLandedCostAllocationJpaEntity>
}
