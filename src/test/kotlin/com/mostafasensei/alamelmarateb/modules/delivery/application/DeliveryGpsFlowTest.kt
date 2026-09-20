package com.mostafasensei.alamelmarateb.modules.delivery.application

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
import com.mostafasensei.alamelmarateb.modules.sales.domain.model.PaymentMethod
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.jdbc.core.JdbcTemplate
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.transaction.PlatformTransactionManager
import org.springframework.transaction.TransactionDefinition
import org.springframework.transaction.annotation.Transactional
import org.springframework.transaction.support.TransactionTemplate
import java.math.BigDecimal
import java.time.LocalDate
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertTrue

@SpringBootTest
@Transactional
class DeliveryGpsFlowTest {

    @Autowired private lateinit var deliveryService: DeliveryService
    @Autowired private lateinit var orderService: OrderService
    @Autowired private lateinit var warehouseService: WarehouseService
    @Autowired private lateinit var stockService: StockService
    @Autowired private lateinit var catalogService: ProductCatalogService
    @Autowired private lateinit var jdbc: JdbcTemplate
    @Autowired private lateinit var txManager: PlatformTransactionManager

    private fun committed(sql: String, vararg args: Any?) {
        val template = TransactionTemplate(txManager)
        template.propagationBehavior = TransactionDefinition.PROPAGATION_REQUIRES_NEW
        template.execute { jdbc.update(sql, *args) }
    }

    private fun driver(id: UUID) = UserPrincipal(
        id = id, branchId = null, fullName = "Driver",
        phoneNumber = "01${System.nanoTime().toString().takeLast(9)}", passwordHash = "hash", active = true,
        authorities = listOf(SimpleGrantedAuthority("ROLE_DELIVERY_DRIVER")),
    )

    @Test
    fun `pin, optimize, push location, rate driver`() {
        val suffix = System.nanoTime()
        val branchId = UUID.randomUUID()
        committed(
            "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
            branchId, "GPS Branch", "GB-$suffix", "Cairo", "St",
        )
        val customerId = UUID.randomUUID()
        committed(
            "INSERT INTO users (id, full_name, phone_number, password_hash) VALUES (?, ?, ?, ?)",
            customerId, "Customer", "010" + UUID.randomUUID().toString().replace("-", "").take(8), "hash",
        )
        val driverId = UUID.randomUUID()
        committed(
            "INSERT INTO users (id, full_name, phone_number, password_hash) VALUES (?, ?, ?, ?)",
            driverId, "Driver", "010" + UUID.randomUUID().toString().replace("-", "").take(8), "hash",
        )
        val warehouse = warehouseService.create(branchId, "GPS WH", "GWH-$suffix")
        val category = catalogService.createCategory(ProductCategory(name = "GPS Cat", slug = "gps-cat-$suffix"))
        val product = catalogService.createProduct(
            Product(categoryId = category.id!!, name = "GPS Mattress", slug = "gps-mattress-$suffix", brand = "B"),
        )
        val variantId = catalogService.createVariant(
            ProductVariant(productId = product.id, sku = "GPS-$suffix", barcode = null,
                widthCm = 120, lengthCm = 195, heightCm = 25,
                costPrice = BigDecimal("4000"), sellingPrice = BigDecimal("8000")),
        ).id!!
        stockService.adjust(warehouse.id!!, variantId, 5, "Opening", by = "test")

        val orderIds = (1..3).map {
            orderService.place(
                PlaceOrderInput(
                    branchId = branchId, customerId = customerId, channel = "shop",
                    items = listOf(OrderItemInput(variantId, 1)), paymentMethod = PaymentMethod.COD, by = "test",
                ),
            ).order.id!!
        }
        val vehicle = deliveryService.createVehicle(branchId, "GPS-${suffix.toString().takeLast(6)}", "van", 1000, null, "test")
        val trip = deliveryService.createTrip(driverId, vehicle.id!!, branchId, LocalDate.now(), orderIds, by = "test")

        // Pin far-apart coords, optimize re-sequences by proximity.
        val stops = deliveryService.tripStops(trip.id!!)
        assertEquals(listOf(1, 2, 3), stops.map { it.seq })
        deliveryService.pinStop(stops[0].id!!, 30.0, 31.0, "test")
        deliveryService.pinStop(stops[1].id!!, 30.5, 31.5, "test")
        deliveryService.pinStop(stops[2].id!!, 30.01, 31.01, "test")
        val optimized = deliveryService.optimize(trip.id!!, "test")
        val byOrder = optimized.associate { it.orderId to it.seq }
        // stop3 (near stop1) comes right after stop1.
        assertTrue(byOrder[orderIds[2]] == byOrder[orderIds[0]]!! + 1)

        // GPS push + latest.
        deliveryService.dispatch(trip.id!!, "test")
        val pushed = deliveryService.pushLocation(trip.id!!, 30.05, 31.05, driver(driverId))
        assertEquals(30.05, pushed.lat)
        val latest = deliveryService.latestLocation(trip.id!!)
        assertEquals(31.05, latest.lng)
        assertEquals(31.05, deliveryService.latestLocationForOrder(orderIds[0]).lng)

        // Deliver one stop, then rate the driver as the customer.
        deliveryService.confirmDeliver(orderIds[0], "photo-1", driver(driverId))
        val rated = deliveryService.rateDriver(orderIds[0], customerId, 5, "سريع ومحترم")
        assertEquals(5, rated.rating)
        assertEquals(5.0, rated.average)
        assertEquals(5.0, deliveryService.driverAverage(driverId))
    }
}
