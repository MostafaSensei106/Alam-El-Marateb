package com.mostafasensei.alamelmarateb.modules.accounting.application

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.time.LocalDate
import kotlin.test.assertEquals
import kotlin.test.assertFailsWith
import kotlin.test.assertTrue

@SpringBootTest
@Transactional
class AccountingFlowTest {

    @Autowired
    private lateinit var accountingService: AccountingService

    @Test
    fun `balanced journal posts, unbalanced rejected, transfer moves funds, check lifecycle`() {
        val today = LocalDate.now()

        // Balanced journal (seeded chart: 1010 Cash, 4010 Sales).
        val journal = accountingService.postJournal(
            branchId = null,
            entryDate = today,
            source = "MANUAL",
            ref = "TEST-1",
            memo = "test sale",
            lines = listOf(
                JournalLineInput("1010", BigDecimal("1000.00"), BigDecimal.ZERO),
                JournalLineInput("4010", BigDecimal.ZERO, BigDecimal("1000.00")),
            ),
            by = "test",
        )
        assertEquals(0, journal.totalDebit.compareTo(BigDecimal("1000.00")))
        assertEquals(0, journal.totalCredit.compareTo(BigDecimal("1000.00")))
        assertEquals(2, journal.lines.size)

        // Ledger shows the cash leg ordered by date.
        val ledger = accountingService.generalLedger("1010", today, today)
        assertTrue(ledger.any { it.entryId == journal.id && it.debit.compareTo(BigDecimal("1000.00")) == 0 })

        // Unbalanced journal rejected.
        assertFailsWith<BadRequestException> {
            accountingService.postJournal(
                branchId = null,
                entryDate = today,
                source = "MANUAL",
                ref = "TEST-BAD",
                memo = null,
                lines = listOf(
                    JournalLineInput("1010", BigDecimal("1000.00"), BigDecimal.ZERO),
                    JournalLineInput("4010", BigDecimal.ZERO, BigDecimal("900.00")),
                ),
                by = "test",
            )
        }

        // Debit/credit on the same line rejected.
        assertFailsWith<BadRequestException> {
            accountingService.postJournal(
                branchId = null,
                entryDate = today,
                source = "MANUAL",
                ref = "TEST-BAD2",
                memo = null,
                lines = listOf(
                    JournalLineInput("1010", BigDecimal("100.00"), BigDecimal("100.00")),
                ),
                by = "test",
            )
        }

        // Treasury transfer updates both balances atomically.
        val from = accountingService.createTreasury(null, "Main", BigDecimal("5000.00"))
        val to = accountingService.createTreasury(null, "Branch", BigDecimal("1000.00"))
        accountingService.transfer(from.id!!, to.id!!, BigDecimal("1500.00"), "test")
        assertEquals(0, accountingService.treasury(from.id!!).balance.compareTo(BigDecimal("3500.00")))
        assertEquals(0, accountingService.treasury(to.id!!).balance.compareTo(BigDecimal("2500.00")))

        // Overdraft rejected.
        assertFailsWith<ConflictException> {
            accountingService.transfer(from.id!!, to.id!!, BigDecimal("99999.00"), "test")
        }

        // Check lifecycle: held -> cashed, then terminal.
        val check = accountingService.createCheck("out", BigDecimal("2000.00"), today.plusDays(7), "Supplier X")
        assertEquals("held", check.status)
        val cashed = accountingService.checkStatus(check.id!!, "cashed")
        assertEquals("cashed", cashed.status)
        assertFailsWith<ConflictException> {
            accountingService.checkStatus(check.id!!, "returned")
        }

        // Reports read from journals.
        val pnl = accountingService.profitLoss(today, today)
        assertTrue(pnl.revenue.compareTo(BigDecimal.ZERO) >= 0)
        assertEquals(0, pnl.netProfit.compareTo(pnl.revenue.subtract(pnl.cogs).subtract(pnl.expenses)))
        val tax = accountingService.taxReport(today, today)
        assertEquals(0, tax.revenueInclusive.compareTo(pnl.revenue))
        val sheet = accountingService.balanceSheet(today)
        assertTrue(sheet.assets.compareTo(BigDecimal.ZERO) >= 0)
    }
}
