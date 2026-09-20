package com.mostafasensei.alamelmarateb.modules.delivery.application

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.inventory.application.StockService
import com.mostafasensei.alamelmarateb.modules.inventory.application.WarehouseService
import com.mostafasensei.alamelmarateb.modules.product.data.model.Product
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductCategory
import com.mostafasensei.alamelmarateb.modules.product.data.model.ProductVariant
import com.mostafasensei.alamelmarateb.modules.product.domain.service.ProductCatalogService
import com.mostafasensei.alamelmarateb.modules.sales.application.OrderItemInput
import com.mostafasensei.alamelmarateb.modules.sales.application.OrderService
import com.mostafasensei.alamelmarateb.modules.sales.application.PlaceOrderInput
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.OrderStatus
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.PaymentMethod
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.security.access.AccessDeniedException
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.transaction.PlatformTransactionManager
import org.springframework.transaction.TransactionDefinition
import org.springframework.transaction.annotation.Transactional
import org.springframework.transaction.support.TransactionTemplate
import java.math.BigDecimal
import java.time.LocalDate
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertTrue

@SpringBootTest
@Transactional
class DeliveryFlowTest {

    @Autowired
    private lateinit var deliveryService: DeliveryService

    @Autowired
    private lateinit var orderService: OrderService

    @Autowired
    private lateinit var warehouseService: WarehouseService

    @Autowired
    private lateinit var stockService: StockService

    @Autowired
    private lateinit var catalogService: ProductCatalogService

    @Autowired
    private lateinit var jdbc: JdbcTemplate

    @Autowired
    private lateinit var txManager: PlatformTransactionManager

    private fun committed(sql: String, vararg args: Any?) {
        val template = TransactionTemplate(txManager)
        template.propagationBehavior = TransactionDefinition.PROPAGATION_REQUIRES_NEW
        template.execute { jdbc.update(sql, *args) }
    }

    private fun newBranch(): UUID {
        val id = UUID.randomUUID()
        committed(
            "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
            id, "Delivery Branch", "DLV-${System.nanoTime()}", "Cairo", "St",
        )
        return id
    }

    private fun principal(id: UUID, vararg roles: String) = UserPrincipal(
        id = id, branchId = null, fullName = "Test Principal",
        phoneNumber = "01${System.nanoTime().toString().takeLast(9)}", passwordHash = "hash", active = true,
        authorities = roles.map { SimpleGrantedAuthority(it) },
    )

    private fun seedVariant(suffix: String): UUID {
        val category = catalogService.createCategory(
            ProductCategory(name = "Delivery Cat", slug = "dlv-cat-$suffix-${System.nanoTime()}"),
        )
        val product = catalogService.createProduct(
            Product(
                categoryId = category.id!!, name = "Delivery Mattress",
                slug = "dlv-mattress-$suffix-${System.nanoTime()}", brand = "TestBrand",
            ),
        )
        return catalogService.createVariant(
            ProductVariant(
                productId = product.id, sku = "DLV-$suffix-${System.nanoTime()}", barcode = null,
                widthCm = 120, lengthCm = 195, heightCm = 25,
                costPrice = BigDecimal("5000"), sellingPrice = BigDecimal("8000"),
            ),
        ).id!!
    }

    private fun placeOrder(branchId: UUID, variantId: UUID): UUID =
        orderService.place(
            PlaceOrderInput(
                branchId = branchId, guestPhone = "010${System.nanoTime().toString().takeLast(8)}",
                channel = "shop", items = listOf(OrderItemInput(variantId, 1)),
                paymentMethod = PaymentMethod.COD, idempotencyKey = "dlv-${System.nanoTime()}", by = "test",
            ),
        ).order.id!!

    @Test
    fun `vehicle crud uppercases plate and rejects duplicates`() {
        val branchId = newBranch()

        val created = deliveryService.createVehicle(branchId, "abc-123", "van", 1500, null, "test")
        assertEquals("ABC-123", created.plate)
        assertEquals("active", created.status)
        val vehicleId = created.id!!

        val dup = assertFailsWith<ConflictException> {
            deliveryService.createVehicle(branchId, "abc-123", "truck", 3000, null, "test")
        }
        assertEquals("error.delivery.vehicle_plate_exists", dup.errorKey)

        val updated = deliveryService.updateVehicle(vehicleId, null, null, "truck", 3000, "maintenance", "test")
        assertEquals("truck", updated.kind)
        assertEquals("maintenance", updated.status)

        assertEquals(1, deliveryService.vehicles().size)
        assertEquals("ABC-123", deliveryService.vehicle(vehicleId).plate)

        val missing = assertFailsWith<NotFoundException> { deliveryService.vehicle(UUID.randomUUID()) }
        assertEquals("error.delivery.vehicle_not_found", missing.errorKey)

        deliveryService.deleteVehicle(vehicleId, "test")
        assertTrue(deliveryService.vehicles().isEmpty())
    }

    @Test
    fun `trip lifecycle with real order confirmDeliver closes order and completes trip`() {
        val branchId = newBranch()
        val variantId = seedVariant("ok")
        val warehouse = warehouseService.create(branchId, "DLV WH", "DWH-${System.nanoTime()}")
        stockService.adjust(warehouse.id!!, variantId, 5, "Opening", by = "test")
        val orderId = placeOrder(branchId, variantId)

        val driverId = UUID.randomUUID()
        val driver = principal(driverId, "ROLE_DELIVERY_DRIVER")
        val vehicle = deliveryService.createVehicle(branchId, "trip-1", "van", 1000, null, "test")

        val trip = deliveryService.createTrip(
            driverId, vehicle.id!!, branchId, LocalDate.now(), listOf(orderId), listOf("9-12"), "test",
        )
        assertEquals("draft", trip.status)
        val tripId = trip.id!!

        val dispatched = deliveryService.dispatch(tripId, "test")
        assertEquals("in_transit", dispatched.status)
        assertFailsWith<ConflictException> { deliveryService.dispatch(tripId, "test") }
            .also { assertEquals("error.delivery.trip_status", it.errorKey) }

        assertEquals(1, deliveryService.myTrips(driverId).size)
        val stops = deliveryService.tripStops(tripId)
        assertEquals(1, stops.size)
        assertEquals("pending", stops.first().status)
        assertEquals(1, stops.first().seq)

        val delivered = deliveryService.confirmDeliver(orderId, "photo-key-1", driver)
        assertEquals("delivered", delivered.status)
        assertEquals("photo-key-1", delivered.proofPhoto)

        // Sales order closed + trip auto-completed (all stops terminal).
        val tracked = orderService.track(
            jdbc.queryForObject("SELECT tracking_number FROM orders WHERE id = ?", String::class.java, orderId),
        )
        assertEquals(OrderStatus.delivered, tracked.status)
        assertEquals("done", deliveryService.myTrips(driverId).first().status)

        // Second confirm on the same order conflicts (no pending stop left).
        assertFailsWith<ConflictException> { deliveryService.confirmDeliver(orderId, "photo-2", driver) }
            .also { assertEquals("error.delivery.stop_status", it.errorKey) }
    }

    @Test
    fun `failed path validations ownership and cancel`() {
        val branchId = newBranch()
        val variantId = seedVariant("fail")
        val warehouse = warehouseService.create(branchId, "DLV WH2", "DWH2-${System.nanoTime()}")
        stockService.adjust(warehouse.id!!, variantId, 5, "Opening", by = "test")
        val orderId = placeOrder(branchId, variantId)

        val driverId = UUID.randomUUID()
        val driver = principal(driverId, "ROLE_DELIVERY_DRIVER")
        val stranger = principal(UUID.randomUUID(), "ROLE_DELIVERY_DRIVER")
        val admin = principal(UUID.randomUUID(), "ROLE_SUPER_ADMIN")
        val vehicle = deliveryService.createVehicle(branchId, "fail-1", "van", 1000, null, "test")

        val trip = deliveryService.createTrip(driverId, vehicle.id!!, branchId, LocalDate.now(), listOf(orderId), by = "test")
        deliveryService.dispatch(trip.id!!, "test")
        val tripId = trip.id!!
        val stopId = deliveryService.tripStops(tripId).first().id!!

        // Ownership: stranger denied, super-admin bypasses.
        assertFailsWith<AccessDeniedException> {
            deliveryService.updateStop(stopId, "failed", null, "closed", stranger)
        }
        assertFailsWith<AccessDeniedException> {
            deliveryService.reportFailed(orderId, "closed", stranger)
        }

        // Validation keys.
        assertFailsWith<BadRequestException> {
            deliveryService.updateStop(stopId, "delivered", null, null, driver)
        }.also { assertEquals("error.delivery.proof_required", it.errorKey) }
        assertFailsWith<BadRequestException> {
            deliveryService.updateStop(stopId, "failed", null, null, driver)
        }.also { assertEquals("error.delivery.fail_reason_required", it.errorKey) }
        assertFailsWith<BadRequestException> {
            deliveryService.updateStop(stopId, "bogus", null, null, driver)
        }.also { assertEquals("error.delivery.stop_status", it.errorKey) }
        assertFailsWith<NotFoundException> {
            deliveryService.updateStop(UUID.randomUUID(), "failed", null, "x", driver)
        }.also { assertEquals("error.delivery.stop_not_found", it.errorKey) }
        assertFailsWith<NotFoundException> { deliveryService.tripStops(UUID.randomUUID()) }
            .also { assertEquals("error.delivery.trip_not_found", it.errorKey) }
        assertFailsWith<NotFoundException> { deliveryService.confirmDeliver(UUID.randomUUID(), "p", driver) }
            .also { assertEquals("error.delivery.order_not_found", it.errorKey) }
        assertFailsWith<NotFoundException> {
            deliveryService.createTrip(driverId, UUID.randomUUID(), branchId, LocalDate.now(), listOf(orderId), by = "test")
        }.also { assertEquals("error.delivery.vehicle_not_found", it.errorKey) }

        // Failed path via super-admin bypass still completes the trip.
        val failed = deliveryService.reportFailed(orderId, "closed", admin)
        assertEquals("failed", failed.status)
        assertEquals("done", deliveryService.myTrips(driverId).first().status)

        // Cancel draft trip; cancel of non-draft conflicts.
        val trip2 = deliveryService.createTrip(driverId, vehicle.id!!, branchId, LocalDate.now(), listOf(orderId), by = "test")
        assertEquals("cancelled", deliveryService.cancelTrip(trip2.id!!, "test").status)
        assertFailsWith<ConflictException> { deliveryService.cancelTrip(tripId, "test") }
            .also { assertEquals("error.delivery.trip_status", it.errorKey) }
    }

    @Test
    fun `confirmDeliver on non-deliverable order reports order_not_ready`() {
        val branchId = newBranch()
        val variantId = seedVariant("draft")
        val driverId = UUID.randomUUID()
        val driver = principal(driverId, "ROLE_DELIVERY_DRIVER")
        val vehicle = deliveryService.createVehicle(branchId, "nr-1", "van", 1000, null, "test")

        // Draft order (never confirmed) cannot be marked delivered by sales.
        val draft = orderService.saveDraft(
            PlaceOrderInput(
                branchId = branchId, guestPhone = "010${System.nanoTime().toString().takeLast(8)}",
                channel = "shop", items = listOf(OrderItemInput(variantId, 1)),
                paymentMethod = PaymentMethod.COD, by = "test",
            ),
        )
        val trip = deliveryService.createTrip(driverId, vehicle.id!!, branchId, LocalDate.now(), listOf(draft.id!!), by = "test")
        deliveryService.dispatch(trip.id!!, "test")
        val draftId = draft.id!!

        assertFailsWith<ConflictException> { deliveryService.confirmDeliver(draftId, "photo", driver) }
            .also { assertEquals("error.delivery.order_not_ready", it.errorKey) }
    }
}
