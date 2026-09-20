package com.mostafasensei.alamelmarateb.modules.delivery.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.Table
import java.time.LocalDate
import java.util.UUID

@Entity
@Table(name = "vehicles")
class VehicleJpaEntity(
    @Column(name = "branch_id", columnDefinition = "UUID")
    var branchId: UUID? = null,

    @Column(name = "plate", nullable = false, unique = true, length = 20)
    var plate: String = "",

    @Column(name = "kind", length = 30)
    var kind: String? = null,

    @Column(name = "capacity_kg")
    var capacityKg: Int? = null,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "active",
) : EntityBase<UUID>()

@Entity
@Table(name = "delivery_trips")
class DeliveryTripJpaEntity(
    @Column(name = "branch_id", columnDefinition = "UUID")
    var branchId: UUID? = null,

    @Column(name = "driver_id", nullable = false, columnDefinition = "UUID")
    var driverId: UUID? = null,

    @Column(name = "vehicle_id", nullable = false, columnDefinition = "UUID")
    var vehicleId: UUID? = null,

    @Column(name = "trip_date", nullable = false)
    var tripDate: LocalDate? = null,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "draft",
) : EntityBase<UUID>()

@Entity
@Table(name = "trip_stops")
class TripStopJpaEntity(
    @Column(name = "trip_id", nullable = false, columnDefinition = "UUID")
    var tripId: UUID? = null,

    @Column(name = "order_id", nullable = false, columnDefinition = "UUID")
    var orderId: UUID? = null,

    @Column(name = "seq", nullable = false)
    var seq: Int = 0,

    // "window" is a reserved word in Postgres — quoted in V12 and here.
    @Column(name = "\"window\"", length = 50)
    var window: String? = null,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "pending",

    @Column(name = "proof_photo", columnDefinition = "TEXT")
    var proofPhoto: String? = null,

    @Column(name = "fail_reason", columnDefinition = "TEXT")
    var failReason: String? = null,

    @Column(name = "delivered_at")
    var deliveredAt: java.time.Instant? = null,
) : EntityBase<UUID>()
