package com.mostafasensei.alamelmarateb.modules.delivery.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogService
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.delivery.data.repository.DeliveryTripRepository
import com.mostafasensei.alamelmarateb.modules.delivery.data.repository.DriverRatingRepository
import com.mostafasensei.alamelmarateb.modules.delivery.data.repository.TripLocationRepository
import com.mostafasensei.alamelmarateb.modules.delivery.data.repository.TripStopRepository
import com.mostafasensei.alamelmarateb.modules.delivery.domain.entity.DriverRatingJpaEntity
import com.mostafasensei.alamelmarateb.modules.delivery.domain.entity.TripLocationJpaEntity
import com.mostafasensei.alamelmarateb.modules.delivery.data.repository.VehicleRepository
import com.mostafasensei.alamelmarateb.modules.delivery.domain.entity.DeliveryTripJpaEntity
import com.mostafasensei.alamelmarateb.modules.delivery.domain.entity.TripStopJpaEntity
import com.mostafasensei.alamelmarateb.modules.delivery.domain.entity.VehicleJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.application.OrderService
import org.springframework.security.access.AccessDeniedException
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDate
import java.util.UUID

data class VehicleView(
    val id: UUID?,
    val branchId: UUID?,
    val plate: String,
    val kind: String?,
    val capacityKg: Int?,
    val status: String,
)

data class TripView(
    val id: UUID?,
    val branchId: UUID?,
    val driverId: UUID?,
    val vehicleId: UUID?,
    val tripDate: LocalDate?,
    val status: String,
)

data class StopView(
    val id: UUID?,
    val tripId: UUID?,
    val orderId: UUID?,
    val seq: Int,
    val window: String?,
    val status: String,
    val proofPhoto: String?,
    val failReason: String?,
    val deliveredAt: java.time.Instant?,
    val lat: Double? = null,
    val lng: Double? = null,
)

data class TripLocationView(
    val tripId: UUID?,
    val lat: Double,
    val lng: Double,
    val recordedAt: String?,
)

data class DriverRatingView(
    val orderId: UUID?,
    val driverId: UUID?,
    val rating: Int,
    val average: Double,
)

@Service
class DeliveryService(
    private val vehicleRepository: VehicleRepository,
    private val tripRepository: DeliveryTripRepository,
    private val stopRepository: TripStopRepository,
    private val locationRepository: TripLocationRepository,
    private val ratingRepository: DriverRatingRepository,
    private val orderService: OrderService,
    private val auditLog: AuditLogService,
) {

    // ---- vehicles ----

    @Transactional
    fun createVehicle(branchId: UUID?, plate: String, kind: String?, capacityKg: Int?, status: String?, by: String?): VehicleView {
        val normalized = plate.trim().uppercase()
        if (vehicleRepository.existsByPlate(normalized)) {
            throw ConflictException("error.delivery.vehicle_plate_exists", listOf(normalized))
        }
        val saved = vehicleRepository.save(
            VehicleJpaEntity(
                branchId = branchId, plate = normalized, kind = kind,
                capacityKg = capacityKg, status = status ?: "active",
            ),
        )
        auditLog.record("CREATE_VEHICLE", "vehicle", saved.id, branchId, by, normalized)
        return toVehicleView(saved)
    }

    @Transactional
    fun updateVehicle(
        id: UUID, branchId: UUID?, plate: String?, kind: String?,
        capacityKg: Int?, status: String?, by: String?,
    ): VehicleView {
        val entity = vehicleRepository.findById(id)
            .orElseThrow { NotFoundException("error.delivery.vehicle_not_found", listOf(id)) }
        if (plate != null) {
            val normalized = plate.trim().uppercase()
            if (normalized != entity.plate && vehicleRepository.existsByPlate(normalized)) {
                throw ConflictException("error.delivery.vehicle_plate_exists", listOf(normalized))
            }
            entity.plate = normalized
        }
        if (branchId != null) entity.branchId = branchId
        if (kind != null) entity.kind = kind
        if (capacityKg != null) entity.capacityKg = capacityKg
        if (status != null) entity.status = status
        val saved = vehicleRepository.save(entity)
        auditLog.record("UPDATE_VEHICLE", "vehicle", id, saved.branchId, by, saved.plate)
        return toVehicleView(saved)
    }

    @Transactional(readOnly = true)
    fun vehicles(): List<VehicleView> = vehicleRepository.findAll().map { toVehicleView(it) }

    @Transactional(readOnly = true)
    fun vehicle(id: UUID): VehicleView =
        toVehicleView(
            vehicleRepository.findById(id)
                .orElseThrow { NotFoundException("error.delivery.vehicle_not_found", listOf(id)) },
        )

    @Transactional
    fun deleteVehicle(id: UUID, by: String?) {
        val entity = vehicleRepository.findById(id)
            .orElseThrow { NotFoundException("error.delivery.vehicle_not_found", listOf(id)) }
        vehicleRepository.delete(entity)
        auditLog.record("DELETE_VEHICLE", "vehicle", id, entity.branchId, by, entity.plate)
    }

    // ---- trips (management) ----

    @Transactional
    fun createTrip(
        driverId: UUID, vehicleId: UUID, branchId: UUID?, tripDate: LocalDate,
        orderIds: List<UUID>, windows: List<String?> = emptyList(), by: String?,
    ): TripView {
        vehicleRepository.findById(vehicleId)
            .orElseThrow { NotFoundException("error.delivery.vehicle_not_found", listOf(vehicleId)) }
        val trip = tripRepository.save(
            DeliveryTripJpaEntity(
                branchId = branchId, driverId = driverId,
                vehicleId = vehicleId, tripDate = tripDate, status = "draft",
            ),
        )
        orderIds.forEachIndexed { index, orderId ->
            stopRepository.save(
                TripStopJpaEntity(
                    tripId = trip.id, orderId = orderId, seq = index + 1,
                    window = windows.getOrNull(index), status = "pending",
                ),
            )
        }
        auditLog.record("CREATE_TRIP", "trip", trip.id, branchId, by, "stops=${orderIds.size}")
        return toTripView(trip)
    }

    @Transactional
    fun dispatch(tripId: UUID, by: String?): TripView {
        val trip = loadTrip(tripId)
        if (trip.status != "draft") throw ConflictException("error.delivery.trip_status", listOf(trip.status))
        trip.status = "in_transit"
        val saved = tripRepository.save(trip)
        auditLog.record("DISPATCH_TRIP", "trip", tripId, trip.branchId, by, null)
        return toTripView(saved)
    }

    @Transactional
    fun cancelTrip(tripId: UUID, by: String?): TripView {
        val trip = loadTrip(tripId)
        if (trip.status != "draft") throw ConflictException("error.delivery.trip_status", listOf(trip.status))
        trip.status = "cancelled"
        val saved = tripRepository.save(trip)
        auditLog.record("CANCEL_TRIP", "trip", tripId, trip.branchId, by, null)
        return toTripView(saved)
    }

    @Transactional
    fun completeTrip(tripId: UUID, by: String?): TripView {
        val trip = loadTrip(tripId)
        if (trip.status != "in_transit") throw ConflictException("error.delivery.trip_status", listOf(trip.status))
        if (stopRepository.findByTripIdOrderBySeqAsc(tripId).any { it.status == "pending" }) {
            throw ConflictException("error.delivery.trip_status", listOf(trip.status))
        }
        trip.status = "done"
        val saved = tripRepository.save(trip)
        auditLog.record("COMPLETE_TRIP", "trip", tripId, trip.branchId, by, null)
        return toTripView(saved)
    }

    // ---- driver reads ----

    @Transactional(readOnly = true)
    fun myTrips(driverId: UUID): List<TripView> =
        tripRepository.findByDriverIdOrderByTripDateDesc(driverId).map { toTripView(it) }

    @Transactional(readOnly = true)
    fun tripStops(tripId: UUID): List<StopView> {
        loadTrip(tripId)
        return stopRepository.findByTripIdOrderBySeqAsc(tripId).map { toStopView(it) }
    }

    // ---- driver writes ----

    @Transactional
    fun updateStop(stopId: UUID, status: String, proof: String?, reason: String?, principal: UserPrincipal): StopView {
        val stop = stopRepository.findById(stopId)
            .orElseThrow { NotFoundException("error.delivery.stop_not_found", listOf(stopId)) }
        val trip = loadTrip(stop.tripId!!)
        verifyDriver(trip, principal)
        if (stop.status != "pending") throw ConflictException("error.delivery.stop_status", listOf(stop.status))
        when (status.lowercase()) {
            "delivered" -> {
                if (proof.isNullOrBlank()) throw BadRequestException("error.delivery.proof_required")
                stop.status = "delivered"
                stop.proofPhoto = proof
                stop.deliveredAt = java.time.Instant.now()
            }
            "failed" -> {
                if (reason.isNullOrBlank()) throw BadRequestException("error.delivery.fail_reason_required")
                stop.status = "failed"
                stop.failReason = reason
            }
            else -> throw BadRequestException("error.delivery.stop_status", listOf(status))
        }
        val saved = stopRepository.save(stop)
        auditLog.record("UPDATE_STOP", "stop", stopId, trip.branchId, principal.fullName, stop.status)
        maybeComplete(trip.id!!)
        return toStopView(saved)
    }

    @Transactional
    fun confirmDeliver(orderId: UUID, proof: String, principal: UserPrincipal): StopView {
        val stop = pendingStopFor(orderId)
        val trip = loadTrip(stop.tripId!!)
        verifyDriver(trip, principal)
        if (proof.isBlank()) throw BadRequestException("error.delivery.proof_required")
        try {
            orderService.markDelivered(orderId, principal.fullName)
        } catch (e: ConflictException) {
            throw ConflictException("error.delivery.order_not_ready", listOf(orderId))
        } catch (e: NotFoundException) {
            throw NotFoundException("error.delivery.order_not_found", listOf(orderId))
        }
        stop.status = "delivered"
        stop.proofPhoto = proof
        stop.deliveredAt = java.time.Instant.now()
        val saved = stopRepository.save(stop)
        auditLog.record("CONFIRM_DELIVER", "stop", stop.id, trip.branchId, principal.fullName, orderId.toString())
        maybeComplete(trip.id!!)
        return toStopView(saved)
    }

    @Transactional
    fun reportFailed(orderId: UUID, reason: String, principal: UserPrincipal): StopView {
        val stop = pendingStopFor(orderId)
        val trip = loadTrip(stop.tripId!!)
        verifyDriver(trip, principal)
        if (reason.isBlank()) throw BadRequestException("error.delivery.fail_reason_required")
        stop.status = "failed"
        stop.failReason = reason
        val saved = stopRepository.save(stop)
        auditLog.record("REPORT_FAILED", "stop", stop.id, trip.branchId, principal.fullName, orderId.toString())
        maybeComplete(trip.id!!)
        return toStopView(saved)
    }

    // ---- internals ----

    private fun pendingStopFor(orderId: UUID): TripStopJpaEntity {
        val stops = stopRepository.findByOrderId(orderId)
        if (stops.isEmpty()) throw NotFoundException("error.delivery.order_not_found", listOf(orderId))
        return stops.firstOrNull { it.status == "pending" }
            ?: throw ConflictException("error.delivery.stop_status", listOf(stops.first().status))
    }

    private fun verifyDriver(trip: DeliveryTripJpaEntity, principal: UserPrincipal) {
        val isSuper = principal.authorities.any { it.authority == "ROLE_SUPER_ADMIN" }
        if (!isSuper && trip.driverId != principal.id) {
            throw AccessDeniedException("Access denied: trip belongs to another driver")
        }
    }

    private fun maybeComplete(tripId: UUID) {
        val trip = loadTrip(tripId)
        if (trip.status != "in_transit") return
        val stops = stopRepository.findByTripIdOrderBySeqAsc(tripId)
        if (stops.isNotEmpty() && stops.all { it.status != "pending" }) {
            trip.status = "done"
            tripRepository.save(trip)
        }
    }

    private fun loadTrip(tripId: UUID): DeliveryTripJpaEntity =
        tripRepository.findById(tripId)
            .orElseThrow { NotFoundException("error.delivery.trip_not_found", listOf(tripId)) }

    private fun toVehicleView(e: VehicleJpaEntity) = VehicleView(
        e.id, e.branchId, e.plate, e.kind, e.capacityKg, e.status,
    )

    private fun toTripView(e: DeliveryTripJpaEntity) = TripView(
        e.id, e.branchId, e.driverId, e.vehicleId, e.tripDate, e.status,
    )

    private fun toStopView(e: TripStopJpaEntity) = StopView(
        e.id, e.tripId, e.orderId, e.seq, e.window, e.status,
        e.proofPhoto, e.failReason, e.deliveredAt, e.lat, e.lng,
    )

    // ---- live GPS ----

    @Transactional
    fun pushLocation(tripId: UUID, lat: Double, lng: Double, principal: UserPrincipal): TripLocationView {
        val trip = loadTrip(tripId)
        verifyDriver(trip, principal)
        if (trip.status != "in_transit") throw ConflictException("error.delivery.trip_not_started")
        requireValidCoords(lat, lng)
        val saved = locationRepository.save(TripLocationJpaEntity(tripId = tripId, lat = lat, lng = lng))
        return TripLocationView(tripId, lat, lng, saved.recordedAt?.toString())
    }

    @Transactional(readOnly = true)
    fun latestLocation(tripId: UUID): TripLocationView {
        loadTrip(tripId)
        val loc = locationRepository.findFirstByTripIdOrderByRecordedAtDesc(tripId)
            .orElseThrow { NotFoundException("error.delivery.trip_not_started") }
        return TripLocationView(tripId, loc.lat, loc.lng, loc.recordedAt?.toString())
    }

    /** Latest location for a customer's order (used by order tracking). */
    @Transactional(readOnly = true)
    fun latestLocationForOrder(orderId: UUID): TripLocationView {
        val stop = stopRepository.findByOrderId(orderId).firstOrNull()
            ?: throw NotFoundException("error.delivery.order_not_found")
        return latestLocation(stop.tripId!!)
    }

    // ---- stop pinning + route optimization (nearest-neighbor heuristic) ----

    @Transactional
    fun pinStop(stopId: UUID, lat: Double, lng: Double, by: String?): StopView {
        val stop = stopRepository.findById(stopId)
            .orElseThrow { NotFoundException("error.delivery.stop_not_found", listOf(stopId)) }
        requireValidCoords(lat, lng)
        stop.lat = lat
        stop.lng = lng
        auditLog.record("PIN_STOP", "trip_stop", stopId, null, by, "$lat,$lng")
        return toStopView(stopRepository.save(stop))
    }

    @Transactional
    fun optimize(tripId: UUID, by: String?): List<StopView> {
        val trip = loadTrip(tripId)
        if (trip.status != "draft") throw ConflictException("error.delivery.trip_status", listOf(trip.status))
        val stops = stopRepository.findByTripIdOrderBySeqAsc(tripId).toMutableList()
        val (pinned, free) = stops.partition { it.lat != null && it.lng != null }
        if (pinned.size < 2) return stops.map { toStopView(it) }
        // Nearest-neighbor from the depot-first pinned stop.
        val ordered = mutableListOf(pinned.first())
        val remaining = pinned.drop(1).toMutableList()
        while (remaining.isNotEmpty()) {
            val last = ordered.last()
            val next = remaining.minByOrNull { haversineKm(last.lat!!, last.lng!!, it.lat!!, it.lng!!) }!!
            remaining.remove(next)
            ordered.add(next)
        }
        val sequenced = (ordered + free).mapIndexed { index, stop ->
            stop.seq = -(index + 1)
            stopRepository.save(stop)
        }
        stopRepository.flush()
        sequenced.forEachIndexed { index, stop ->
            stop.seq = index + 1
            stopRepository.save(stop)
        }
        auditLog.record("OPTIMIZE_TRIP", "delivery_trip", tripId, trip.branchId, by, "stops=${sequenced.size}")
        return sequenced.map { toStopView(it) }
    }

    // ---- driver ratings ----

    @Transactional
    fun rateDriver(orderId: UUID, customerId: UUID?, rating: Int, note: String?): DriverRatingView {
        if (rating !in 1..5) throw BadRequestException("error.delivery.rating_range")
        val order = try {
            orderService.trackById(orderId)
        } catch (_: Exception) {
            throw NotFoundException("error.delivery.not_your_stop")
        }
        if (customerId != null && order.customerId != customerId) {
            throw NotFoundException("error.delivery.not_your_stop")
        }
        val stop = stopRepository.findByOrderId(orderId).firstOrNull()
            ?: throw NotFoundException("error.delivery.not_your_stop")
        if (stop.status != "delivered") throw ConflictException("error.delivery.stop_status", listOf(stop.status))
        val trip = loadTrip(stop.tripId!!)
        val driverId = trip.driverId!!
        val saved = ratingRepository.save(
            DriverRatingJpaEntity(orderId = orderId, driverId = driverId, rating = rating, note = note),
        )
        val ratings = ratingRepository.findByDriverId(driverId)
        return DriverRatingView(orderId, driverId, saved.rating, ratings.map { it.rating }.average())
    }

    @Transactional(readOnly = true)
    fun driverAverage(driverId: UUID): Double =
        ratingRepository.findByDriverId(driverId).map { it.rating }.average().let {
            if (it.isNaN()) 0.0 else it
        }

    private fun requireValidCoords(lat: Double, lng: Double) {
        if (lat !in -90.0..90.0 || lng !in -180.0..180.0) {
            throw BadRequestException("error.delivery.bad_coords", listOf("$lat,$lng"))
        }
    }

    private fun haversineKm(lat1: Double, lng1: Double, lat2: Double, lng2: Double): Double {
        val r = 6371.0
        val dLat = Math.toRadians(lat2 - lat1)
        val dLng = Math.toRadians(lng2 - lng1)
        val a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
            Math.sin(dLng / 2) * Math.sin(dLng / 2)
        return 2 * r * Math.asin(Math.sqrt(a))
    }
}
