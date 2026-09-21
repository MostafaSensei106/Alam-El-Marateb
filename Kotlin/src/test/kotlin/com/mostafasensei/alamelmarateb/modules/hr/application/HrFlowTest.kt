package com.mostafasensei.alamelmarateb.modules.hr.application

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
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
import org.springframework.transaction.PlatformTransactionManager
import org.springframework.transaction.TransactionDefinition
import org.springframework.transaction.annotation.Transactional
import org.springframework.transaction.support.TransactionTemplate
import java.math.BigDecimal
import java.time.LocalDate
import java.util.UUID
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith

@SpringBootTest
@Transactional
class HrFlowTest {

    @Autowired
    private lateinit var hrService: HrService

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

    @Test
    fun `employee, leave, advance, payroll calculate and approve`() {
        val userId = UUID.randomUUID()
        committed(
            "INSERT INTO users (id, full_name, phone_number, password_hash) VALUES (?, ?, ?, ?)",
            userId, "HR Employee", "010" + UUID.randomUUID().toString().replace("-", "").take(8), "hash",
        )
        val branchId = UUID.randomUUID()
        committed(
            "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
            branchId, "HR Branch", "HRB-${System.nanoTime()}", "Cairo", "St",
        )

        // Commission rule: 10% of base.
        val rule = hrService.createRule("Sales 10%", HrService.KIND_PERCENT, BigDecimal("10"), null)

        // Employee with base 10000 -> commission 1000.
        val employee = hrService.createEmployee(
            userId, branchId, "Sales Rep", LocalDate.parse("2026-01-15"), BigDecimal("10000"), rule.id,
        )

        // Leave: request then approve.
        val leave = hrService.requestLeave(
            employee.id!!, "annual", LocalDate.parse("2026-10-01"), LocalDate.parse("2026-10-03"), "Backup",
        )
        assertEquals("pending", leave.status)
        assertEquals("approved", hrService.leaveAction(leave.id!!, "approve").status)

        // Advance 3000 + deduction 500.
        hrService.createAdvance(employee.id!!, BigDecimal("3000"))
        hrService.createDeduction(employee.id!!, BigDecimal("500"), "late")

        // Payroll: net = 10000 + 1000 - 3000 - 500 = 7500.
        val run = hrService.calculate(branchId, "2026-09")
        assertEquals("draft", run.status)
        assertEquals(1, run.lines.size)
        val line = run.lines.single()
        assertEquals(BigDecimal("10000.00"), line.baseAmount.setScale(2))
        assertEquals(BigDecimal("1000.00"), line.commissionAmount.setScale(2))
        assertEquals(BigDecimal("3000.00"), line.advanceDeduction.setScale(2))
        assertEquals(BigDecimal("500.00"), line.otherDeductions.setScale(2))
        assertEquals(BigDecimal("7500.00"), line.netAmount.setScale(2))

        // Advance fully consumed and closed; deduction linked to the run.
        assertEquals("closed", hrService.listAdvances(employee.id).single().status)
        assertEquals(run.id, hrService.listDeductions(employee.id).single().payrollId)

        // Approve + export.
        assertEquals("approved", hrService.approveRun(run.id!!).status)
        val csv = hrService.exportCsv(run.id!!)
        assert(csv.lines().size == 3) { "expected header + 1 row, got: $csv" }

        // Self-service reads for the same user.
        assertEquals(1, hrService.myPayslips(userId).size)
        assertEquals(BigDecimal("1000.00"), hrService.myCommissions(userId).single().commissionAmount.setScale(2))
    }

    @Test
    fun `sales commission follows the invoice issuer`() {
        val userId = UUID.randomUUID()
        committed(
            "INSERT INTO users (id, full_name, phone_number, password_hash) VALUES (?, ?, ?, ?)",
            userId, "HR Seller", "010" + UUID.randomUUID().toString().replace("-", "").take(8), "hash",
        )
        val branchId = UUID.randomUUID()
        committed(
            "INSERT INTO branches (id, name, code, city, address) VALUES (?, ?, ?, ?, ?)",
            branchId, "HR Sales Branch", "HRS-${System.nanoTime()}", "Cairo", "St",
        )

        // 5% of own sales.
        val rule = hrService.createRule("Sales 5%", HrService.KIND_SALES, BigDecimal("5"), null)
        hrService.createEmployee(
            userId, branchId, "Sales Rep", LocalDate.parse("2026-01-15"), BigDecimal("10000"), rule.id,
        )

        // Another seller's orders must not leak into this commission.
        val otherId = UUID.randomUUID()
        committed(
            "INSERT INTO users (id, full_name, phone_number, password_hash) VALUES (?, ?, ?, ?)",
            otherId, "HR Other", "010" + UUID.randomUUID().toString().replace("-", "").take(8), "hash",
        )
        val warehouse = warehouseService.create(branchId, "HR Sales WH", "HSW-${System.nanoTime()}")
        val category = catalogService.createCategory(
            ProductCategory(name = "HR Sales Cat", slug = "hrs-cat-${System.nanoTime()}"),
        )
        val product = catalogService.createProduct(
            Product(
                categoryId = category.id!!, name = "HR Mattress",
                slug = "hrs-mattress-${System.nanoTime()}", brand = "B",
            ),
        )
        val variantId = catalogService.createVariant(
            ProductVariant(
                productId = product.id, sku = "HRS-${System.nanoTime()}", barcode = null,
                widthCm = 120, lengthCm = 195, heightCm = 25,
                costPrice = BigDecimal("4000"), sellingPrice = BigDecimal("8000"),
            ),
        ).id!!
        stockService.adjust(warehouse.id!!, variantId, 10, "Opening", by = "test")

        // Two 8000 orders by our rep + one by someone else, all confirmed this month.
        repeat(2) {
            orderService.place(
                PlaceOrderInput(
                    branchId = branchId, guestPhone = "010000000$it", channel = "pos",
                    items = listOf(OrderItemInput(variantId, 1)), paymentMethod = PaymentMethod.COD,
                    salesRepId = userId, idempotencyKey = "hrs-$it-${System.nanoTime()}", by = "test",
                ),
            )
        }
        orderService.place(
            PlaceOrderInput(
                branchId = branchId, guestPhone = "0100000099", channel = "pos",
                items = listOf(OrderItemInput(variantId, 1)), paymentMethod = PaymentMethod.COD,
                salesRepId = otherId, idempotencyKey = "hrs-other-${System.nanoTime()}", by = "test",
            ),
        )

        // Commission = 5% of 16000 = 800; net = 10000 + 800.
        val run = hrService.calculate(branchId, "2026-09")
        val line = run.lines.single()
        assertEquals(BigDecimal("800.00"), line.commissionAmount.setScale(2))
        assertEquals(BigDecimal("10800.00"), line.netAmount.setScale(2))

        // Bad month format rejected.
        assertFailsWith<BadRequestException> { hrService.calculate(branchId, "september") }
    }
}
