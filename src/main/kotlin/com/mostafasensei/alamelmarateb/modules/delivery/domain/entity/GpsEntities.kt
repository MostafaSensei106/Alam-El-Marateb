package com.mostafasensei.alamelmarateb.modules.delivery.domain.entity

import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.GeneratedValue
import jakarta.persistence.GenerationType
import jakarta.persistence.Id
import jakarta.persistence.Table
import jakarta.persistence.UniqueConstraint
import java.time.Instant
import java.util.UUID

@Entity
@Table(name = "trip_locations")
class TripLocationJpaEntity(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UUID")
    var id: UUID? = null,

    @Column(name = "trip_id", nullable = false, columnDefinition = "UUID")
    var tripId: UUID? = null,

    @Column(name = "lat", nullable = false)
    var lat: Double = 0.0,

    @Column(name = "lng", nullable = false)
    var lng: Double = 0.0,

    @Column(name = "recorded_at", nullable = false, updatable = false, insertable = false)
    var recordedAt: Instant? = null,
)

@Entity
@Table(
    name = "driver_ratings",
    uniqueConstraints = [UniqueConstraint(columnNames = ["order_id"])],
)
class DriverRatingJpaEntity(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", updatable = false, nullable = false, columnDefinition = "UUID")
    var id: UUID? = null,

    @Column(name = "order_id", nullable = false, columnDefinition = "UUID")
    var orderId: UUID? = null,

    @Column(name = "driver_id", nullable = false, columnDefinition = "UUID")
    var driverId: UUID? = null,

    @Column(name = "rating", nullable = false)
    var rating: Int = 5,

    @Column(name = "note", columnDefinition = "TEXT")
    var note: String? = null,

    @Column(name = "created_at", nullable = false, updatable = false, insertable = false)
    var createdAt: Instant? = null,
)
