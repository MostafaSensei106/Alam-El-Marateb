package com.mostafasensei.alamelmarateb.modules.accounting.application

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.time.LocalDate
import java.util.UUID
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

    @Test
    fun `transfers are listed, filtered by treasury and fetched by id`() {
        val from = accountingService.createTreasury(null, "T-From", BigDecimal("100.00"))
        val to = accountingService.createTreasury(null, "T-To", BigDecimal("0.00"))
        val transfer = accountingService.transfer(from.id!!, to.id!!, BigDecimal("25.00"), "test")

        assertTrue(accountingService.transfers(null).any { it.id == transfer.id })
        assertTrue(accountingService.transfers(from.id).any { it.id == transfer.id })
        assertTrue(accountingService.transfers(to.id).any { it.id == transfer.id })

        val fetched = accountingService.transferById(transfer.id!!)
        assertEquals(transfer.id, fetched.id)
        assertEquals(0, fetched.amount.compareTo(BigDecimal("25.00")))

        val missing = assertFailsWith<NotFoundException> {
            accountingService.transferById(UUID.randomUUID())
        }
        assertEquals("error.accounting.transfer_not_found", missing.errorKey)
    }

    @Test
    fun `general ledger exposes account name and carries opening balance into range`() {
        val code = "TST" + System.nanoTime().toString().takeLast(10)
        accountingService.createAccount(code, "حساب اختبار", "Test account", "ASSET", null, null)

        val firstDay = LocalDate.of(2001, 1, 1)
        val secondDay = LocalDate.of(2001, 1, 2)
        accountingService.postJournal(
            branchId = null, entryDate = firstDay, source = "MANUAL", ref = "LEDGER-1", memo = null,
            lines = listOf(
                JournalLineInput(code, BigDecimal("500.00"), BigDecimal.ZERO),
                JournalLineInput("4010", BigDecimal.ZERO, BigDecimal("500.00")),
            ),
            by = "test",
        )
        accountingService.postJournal(
            branchId = null, entryDate = secondDay, source = "MANUAL", ref = "LEDGER-2", memo = null,
            lines = listOf(
                JournalLineInput(code, BigDecimal("250.00"), BigDecimal.ZERO),
                JournalLineInput("4010", BigDecimal.ZERO, BigDecimal("250.00")),
            ),
            by = "test",
        )

        val both = accountingService.generalLedger(code, firstDay, secondDay)
        assertEquals(2, both.size)
        assertEquals("حساب اختبار", both.first().accountName)
        assertEquals(0, both[0].runningBalance.compareTo(BigDecimal("500.00")))
        assertEquals(0, both[1].runningBalance.compareTo(BigDecimal("750.00")))

        // Opening balance (500) is carried, but only the second-day row is emitted.
        val secondDayOnly = accountingService.generalLedger(code, secondDay, secondDay)
        assertEquals(1, secondDayOnly.size)
        assertEquals(0, secondDayOnly.single().runningBalance.compareTo(BigDecimal("750.00")))
    }

    @Test
    fun `account balance follows debit and credit normal sides`() {
        val cashBefore = accountingService.account("1010").balance
        val salesBefore = accountingService.account("4010").balance

        accountingService.postJournal(
            branchId = null, entryDate = LocalDate.of(2001, 1, 5), source = "MANUAL", ref = "BAL-1", memo = null,
            lines = listOf(
                JournalLineInput("1010", BigDecimal("300.00"), BigDecimal.ZERO),
                JournalLineInput("4010", BigDecimal.ZERO, BigDecimal("300.00")),
            ),
            by = "test",
        )

        val cashAfter = accountingService.account("1010").balance
        val salesAfter = accountingService.account("4010").balance
        assertEquals(0, cashAfter.subtract(cashBefore).compareTo(BigDecimal("300.00")))
        assertEquals(0, salesAfter.subtract(salesBefore).compareTo(BigDecimal("300.00")))

        // The list endpoint uses the same balance computation.
        val listedCash = accountingService.accounts().single { it.code == "1010" }
        assertEquals(0, listedCash.balance.compareTo(cashAfter))
    }

    @Test
    fun `journals filter by date and source and can be fetched by id`() {
        val source = "TEST-" + UUID.randomUUID().toString().take(8)
        val firstDay = LocalDate.of(2001, 2, 1)
        val secondDay = LocalDate.of(2001, 2, 2)
        val first = accountingService.postJournal(
            branchId = null, entryDate = firstDay, source = source, ref = "J-1", memo = null,
            lines = listOf(
                JournalLineInput("1010", BigDecimal("10.00"), BigDecimal.ZERO),
                JournalLineInput("4010", BigDecimal.ZERO, BigDecimal("10.00")),
            ),
            by = "test",
        )
        val second = accountingService.postJournal(
            branchId = null, entryDate = secondDay, source = source, ref = "J-2", memo = null,
            lines = listOf(
                JournalLineInput("1010", BigDecimal("20.00"), BigDecimal.ZERO),
                JournalLineInput("4010", BigDecimal.ZERO, BigDecimal("20.00")),
            ),
            by = "test",
        )

        val firstDayOnly = accountingService.journals(null, firstDay, firstDay, null)
        assertTrue(firstDayOnly.any { it.id == first.id })
        assertTrue(firstDayOnly.none { it.id == second.id })

        val bySource = accountingService.journals(null, null, null, source)
        assertEquals(2, bySource.size)
        assertTrue(bySource.all { it.source == source })
        // Ordered by entry date.
        assertEquals(listOf(first.id, second.id), bySource.map { it.id })

        val fetched = accountingService.journal(first.id!!)
        assertEquals(source, fetched.source)
        assertEquals("النقدية", fetched.lines.first { it.accountCode == "1010" }.accountName)

        assertFailsWith<NotFoundException> { accountingService.journal(UUID.randomUUID()) }
    }

    @Test
    fun `tax report derives input VAT from purchases and nets payable`() {
        val day = LocalDate.of(2001, 3, 1)
        accountingService.postJournal(
            branchId = null, entryDate = day, source = "MANUAL", ref = "TAX-SALE", memo = null,
            lines = listOf(
                JournalLineInput("1010", BigDecimal("800.00"), BigDecimal.ZERO),
                JournalLineInput("4010", BigDecimal.ZERO, BigDecimal("800.00")),
            ),
            by = "test",
        )
        accountingService.postJournal(
            branchId = null, entryDate = day, source = "MANUAL", ref = "TAX-BUY", memo = null,
            lines = listOf(
                JournalLineInput("5010", BigDecimal("1140.00"), BigDecimal.ZERO),
                JournalLineInput("1010", BigDecimal.ZERO, BigDecimal("1140.00")),
            ),
            by = "test",
        )

        val tax = accountingService.taxReport(day, day)
        assertEquals(0, tax.revenueInclusive.compareTo(BigDecimal("800.00")))
        assertEquals(0, tax.vatPortion.compareTo(BigDecimal("98.25")))
        assertEquals(0, tax.purchasesInclusive.compareTo(BigDecimal("1140.00")))
        assertEquals(0, tax.inputVat.compareTo(BigDecimal("140.00")))
        assertEquals(0, tax.netVatPayable.compareTo(BigDecimal("-41.75")))
    }

    @Test
    fun `check direction and status are normalized and timestamps are exposed`() {
        val check = accountingService.createCheck(" OUTGOING ", BigDecimal("75.00"), null, "Supplier")
        assertEquals("out", check.direction)
        assertTrue(check.createdAt.epochSeconds > 0)

        assertTrue(accountingService.checks(" HELD ").any { it.id == check.id })
        assertTrue(accountingService.checks("bogus").isEmpty())

        assertFailsWith<BadRequestException> {
            accountingService.createCheck("sideways", BigDecimal("10.00"), null, null)
        }

        val cashed = accountingService.checkStatus(check.id!!, "CASHED")
        assertEquals("cashed", cashed.status)

        val expense = accountingService.createExpense(null, "rent", BigDecimal("50.00"), null, "test")
        assertTrue(expense.createdAt.epochSeconds > 0)
    }
}
