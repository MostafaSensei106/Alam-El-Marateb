package com.mostafasensei.alamelmarateb.modules.sales.data.repository

import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.CarryUpFeeJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.CartItemJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.CartJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.CashDropJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.CashShiftJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.DeliveryZoneJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.InstallmentPlanJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.InvoiceJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.OrderItemJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.OrderJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.PromotionBundleItemJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.PromotionJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.ReservationJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.ReturnJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional
import java.util.UUID

@Repository
interface PromotionRepository : JpaRepository<PromotionJpaEntity, UUID> {
    fun findByIsActiveTrue(): List<PromotionJpaEntity>
    fun existsByCode(code: String): Boolean
}

@Repository
interface PromotionBundleItemRepository : JpaRepository<PromotionBundleItemJpaEntity, UUID> {
    fun findByPromotionIdIn(promotionIds: List<UUID>): List<PromotionBundleItemJpaEntity>
}

@Repository
interface OrderRepository : JpaRepository<OrderJpaEntity, UUID> {
    fun findByIdempotencyKey(key: String): Optional<OrderJpaEntity>
    fun findByTrackingNumber(tracking: String): Optional<OrderJpaEntity>
    fun findByCustomerIdOrderByCreatedAtDesc(customerId: UUID): List<OrderJpaEntity>
    fun findByBranchIdAndStatusIn(branchId: UUID, statuses: List<String>): List<OrderJpaEntity>
}

@Repository
interface OrderItemRepository : JpaRepository<OrderItemJpaEntity, UUID>

@Repository
interface InvoiceRepository : JpaRepository<InvoiceJpaEntity, UUID> {
    fun countBySerialStartingWith(prefix: String): Long
}

@Repository
interface ReturnRepository : JpaRepository<ReturnJpaEntity, UUID>

@Repository
interface ReservationRepository : JpaRepository<ReservationJpaEntity, UUID>

@Repository
interface InstallmentPlanRepository : JpaRepository<InstallmentPlanJpaEntity, UUID>

@Repository
interface CashShiftRepository : JpaRepository<CashShiftJpaEntity, UUID> {
    fun findByCashierIdAndStatus(cashierId: UUID, status: String): Optional<CashShiftJpaEntity>
}

@Repository
interface CashDropRepository : JpaRepository<CashDropJpaEntity, UUID> {
    fun findByShiftId(shiftId: UUID): List<CashDropJpaEntity>
}

@Repository
interface CartRepository : JpaRepository<CartJpaEntity, UUID> {
    fun findByCustomerId(customerId: UUID): Optional<CartJpaEntity>
    fun findByGuestKey(guestKey: String): Optional<CartJpaEntity>
}

@Repository
interface CartItemRepository : JpaRepository<CartItemJpaEntity, UUID>

@Repository
interface DeliveryZoneRepository : JpaRepository<DeliveryZoneJpaEntity, UUID> {
    fun findByGovernorateAndAreaAndIsActiveTrue(governorate: String, area: String): Optional<DeliveryZoneJpaEntity>
}

@Repository
interface CarryUpFeeRepository : JpaRepository<CarryUpFeeJpaEntity, UUID>
