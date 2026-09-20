package com.mostafasensei.alamelmarateb.modules.delivery.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogService
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.delivery.data.repository.DeliveryTripRepository
import com.mostafasensei.alamelmarateb.modules.delivery.data.repository.TripStopRepository
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
)

@Service
class DeliveryService(
    private val vehicleRepository: VehicleRepository,
    private val tripRepository: DeliveryTripRepository,
    private val stopRepository: TripStopRepository,
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
        e.proofPhoto, e.failReason, e.deliveredAt,
    )
}
