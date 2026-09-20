package com.mostafasensei.alamelmarateb.modules.sales.application

import com.mostafasensei.alamelmarateb.core.cache.RedisCache
import com.mostafasensei.alamelmarateb.core.exceptions.UnprocessableException
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.CarryUpFeeRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.DeliveryZoneRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.time.Duration
import java.util.UUID

/**
 * Cached reference reads for checkout math (docs/modules/analytics.md 4 —
 * Redis caches product prices and static reference data).
 *
 * Zones/fees change only via DB seeds (no admin mutation endpoints yet),
 * so a long TTL is safe; mutations must evict when endpoints arrive.
 */
@Service
class ShippingRates(
    private val zoneRepository: DeliveryZoneRepository,
    private val carryFeeRepository: CarryUpFeeRepository,
    private val cache: RedisCache,
) {

    companion object {
        private val REF_TTL: Duration = Duration.ofHours(1)
    }

    @Transactional(readOnly = true)
    fun zoneId(governorate: String, area: String): UUID =
        cache.getOrLoad("ship:zone:$governorate:$area", REF_TTL, UUID::class.java) {
            zoneRepository.findByGovernorateAndAreaAndIsActiveTrue(governorate, area)
                .orElseThrow { UnprocessableException("error.order.delivery_unavailable", listOf(governorate, area)) }.id
        }!!

    @Transactional(readOnly = true)
    fun zoneFee(zoneId: UUID): BigDecimal =
        cache.getOrLoad("ship:zonefee:$zoneId", REF_TTL, BigDecimal::class.java) {
            zoneRepository.findById(zoneId).map { it.fee }.orElse(BigDecimal.ZERO)
        }!!

    @Transactional(readOnly = true)
    fun carryFee(floor: Int?): BigDecimal {
        if (floor == null || floor <= 0) return BigDecimal.ZERO
        return cache.getOrLoad("ship:carry:$floor", REF_TTL, BigDecimal::class.java) {
            carryFeeRepository.findAll()
                .firstOrNull { floor in it.floorFrom..it.floorTo }?.fee ?: BigDecimal.ZERO
        }!!
    }
}
