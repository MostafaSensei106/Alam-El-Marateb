package com.mostafasensei.alamelmarateb.modules.delivery.data.repository

import com.mostafasensei.alamelmarateb.modules.delivery.domain.entity.DeliveryTripJpaEntity
import com.mostafasensei.alamelmarateb.modules.delivery.domain.entity.DriverRatingJpaEntity
import com.mostafasensei.alamelmarateb.modules.delivery.domain.entity.TripLocationJpaEntity
import com.mostafasensei.alamelmarateb.modules.delivery.domain.entity.TripStopJpaEntity
import com.mostafasensei.alamelmarateb.modules.delivery.domain.entity.VehicleJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.Optional
import java.util.UUID

@Repository
interface VehicleRepository : JpaRepository<VehicleJpaEntity, UUID> {
    fun findByPlate(plate: String): Optional<VehicleJpaEntity>
    fun existsByPlate(plate: String): Boolean
}

@Repository
interface DeliveryTripRepository : JpaRepository<DeliveryTripJpaEntity, UUID> {
    fun findByDriverIdOrderByTripDateDesc(driverId: UUID): List<DeliveryTripJpaEntity>
}

@Repository
interface TripStopRepository : JpaRepository<TripStopJpaEntity, UUID> {
    fun findByTripIdOrderBySeqAsc(tripId: UUID): List<TripStopJpaEntity>
    fun findByOrderId(orderId: UUID): List<TripStopJpaEntity>
}

@Repository
interface TripLocationRepository : JpaRepository<TripLocationJpaEntity, UUID> {
    fun findFirstByTripIdOrderByRecordedAtDesc(tripId: UUID): Optional<TripLocationJpaEntity>
}

@Repository
interface DriverRatingRepository : JpaRepository<DriverRatingJpaEntity, UUID> {
    fun findByDriverId(driverId: UUID): List<DriverRatingJpaEntity>
}
