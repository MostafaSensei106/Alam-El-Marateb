package com.mostafasensei.alamelmarateb.core.cache

import java.time.Duration
import java.util.UUID

/**
 * Central keyspace + TTLs for [RedisCache] (Phase 1 hardening).
 *
 * One place owns every key shape, so eviction on mutation can never drift
 * from the read path. Prefixes group keys for future `evictByPrefix`
 * (SCAN-based) without touching callers.
 */
object CacheKeys {
    private const val SEP = ":"

    // Reference data (rarely changes, long TTL).
    fun branches() = "ref${SEP}branches"
    fun roles() = "ref${SEP}roles"

    // Catalog (highest-traffic read; evict on product/variant mutation).
    fun variant(id: UUID) = "cat${SEP}var$SEP$id"
    fun variantByBarcode(barcode: String) = "cat${SEP}var${SEP}bc$SEP$barcode"
    fun preset(id: UUID) = "cat${SEP}preset$SEP$id"
    const val CATALOG_PREFIX = "cat:"

    // Promotions preview (short TTL, recomputed often).
    fun validPromotions() = "promo${SEP}valid"

    // Shipping rates (reference-like, long TTL).
    fun shipZone(governorate: String, area: String) = "ship${SEP}zone$SEP$governorate$SEP$area"
    fun shipZoneFee(zoneId: UUID) = "ship${SEP}zonefee$SEP$zoneId"
    fun shipCarry(floor: Int?) = "ship${SEP}carry$SEP$floor"

    // Dashboard aggregates (short TTL, Phase 2 moves heavy parts to ClickHouse).
    fun dashboard(branchId: UUID?, day: String) =
        "dash${SEP}${branchId ?: "all"}$SEP$day"

    val REF_TTL: Duration = Duration.ofHours(6)
    val CATALOG_TTL: Duration = Duration.ofMinutes(10)
    val PREVIEW_TTL: Duration = Duration.ofMinutes(1)
    val DASHBOARD_TTL: Duration = Duration.ofMinutes(5)
}
