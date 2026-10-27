package com.mostafasensei.alamelmarateb.modules.accounting.application

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.accounting.data.repository.ChartOfAccountRepository
import com.mostafasensei.alamelmarateb.modules.accounting.data.repository.CheckRepository
import com.mostafasensei.alamelmarateb.modules.accounting.data.repository.ExpenseRepository
import com.mostafasensei.alamelmarateb.modules.accounting.data.repository.JournalEntryRepository
import com.mostafasensei.alamelmarateb.modules.accounting.data.repository.JournalLineRepository
import com.mostafasensei.alamelmarateb.modules.accounting.data.repository.TreasuryRepository
import com.mostafasensei.alamelmarateb.modules.accounting.data.repository.TreasuryTransferRepository
import com.mostafasensei.alamelmarateb.modules.accounting.domain.entity.ChartOfAccountJpaEntity
import com.mostafasensei.alamelmarateb.modules.accounting.domain.entity.CheckJpaEntity
import com.mostafasensei.alamelmarateb.modules.accounting.domain.entity.ExpenseJpaEntity
import com.mostafasensei.alamelmarateb.modules.accounting.domain.entity.JournalEntryJpaEntity
import com.mostafasensei.alamelmarateb.modules.accounting.domain.entity.JournalLineJpaEntity
import com.mostafasensei.alamelmarateb.modules.accounting.domain.entity.TreasuryJpaEntity
import com.mostafasensei.alamelmarateb.modules.accounting.domain.entity.TreasuryTransferJpaEntity
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.math.RoundingMode
import java.time.Instant
import java.time.LocalDate
import java.util.UUID

data class AccountView(
    val code: String,
    val name: String,
    val type: String,
    val parentCode: String?,
    val branchId: UUID?,
    val balance: BigDecimal,
)

data class JournalLineInput(
    val accountCode: String,
    val debit: BigDecimal,
    val credit: BigDecimal,
)

data class JournalLineView(
    val id: UUID?,
    val accountCode: String,
    val accountName: String,
    val debit: BigDecimal,
    val credit: BigDecimal,
)

data class JournalView(
    val id: UUID?,
    val branchId: UUID?,
    val entryDate: LocalDate?,
    val source: String,
    val ref: String?,
    val memo: String?,
    val lines: List<JournalLineView>,
    val totalDebit: BigDecimal,
    val totalCredit: BigDecimal,
)

data class LedgerLineView(
    val entryId: UUID?,
    val entryDate: LocalDate?,
    val source: String,
    val ref: String?,
    val accountCode: String,
    val accountName: String,
    val debit: BigDecimal,
    val credit: BigDecimal,
    val runningBalance: BigDecimal,
)

data class TreasuryView(
    val id: UUID?,
    val branchId: UUID?,
    val name: String,
    val balance: BigDecimal,
)

data class TransferView(
    val id: UUID?,
    val fromId: UUID?,
    val toId: UUID?,
    val amount: BigDecimal,
    val at: Instant?,
    val by: String?,
)

data class ExpenseView(
    val id: UUID?,
    val branchId: UUID?,
    val category: String,
    val amount: BigDecimal,
    val receiptPhoto: String?,
    val approvedBy: String?,
    val createdAt: kotlin.time.Instant,
)

data class CheckView(
    val id: UUID?,
    val direction: String,
    val amount: BigDecimal,
    val dueDate: LocalDate?,
    val status: String,
    val party: String?,
    val createdAt: kotlin.time.Instant,
)

data class ProfitLossView(
    val from: LocalDate,
    val to: LocalDate,
    val revenue: BigDecimal,
    val cogs: BigDecimal,
    val expenses: BigDecimal,
    val netProfit: BigDecimal,
    val vatPortion: BigDecimal,
)

data class BalanceSheetView(
    val asOf: LocalDate,
    val assets: BigDecimal,
    val liabilities: BigDecimal,
    val equity: BigDecimal,
)

data class TaxReportView(
    val from: LocalDate,
    val to: LocalDate,
    val revenueInclusive: BigDecimal,
    val vatPortion: BigDecimal,
    val purchasesInclusive: BigDecimal,
    val inputVat: BigDecimal,
    val netVatPayable: BigDecimal,
)

@Service
class AccountingService(
    private val accountRepository: ChartOfAccountRepository,
    private val entryRepository: JournalEntryRepository,
    private val lineRepository: JournalLineRepository,
    private val treasuryRepository: TreasuryRepository,
    private val transferRepository: TreasuryTransferRepository,
    private val expenseRepository: ExpenseRepository,
    private val checkRepository: CheckRepository,
) {

    companion object {
        const val COGS_CODE = "5010"
        private val VAT_RATE = BigDecimal("14")
        private val VAT_DIVISOR = BigDecimal("114")
        private val CREDIT_NORMAL_TYPES = setOf("LIABILITY", "EQUITY", "REVENUE")
        private val CHECK_STATUSES = setOf("held", "cashed", "bounced", "returned")
    }

    private fun BigDecimal.money(): BigDecimal = setScale(2, RoundingMode.HALF_EVEN)

    private fun signedAmount(type: String?, debit: BigDecimal, credit: BigDecimal): BigDecimal =
        if (type in CREDIT_NORMAL_TYPES) credit.subtract(debit) else debit.subtract(credit)

    private fun normalizeDirection(raw: String): String = when (raw.trim().lowercase()) {
        "in", "incoming" -> "in"
        "out", "outgoing" -> "out"
        else -> throw BadRequestException("error.accounting.check_direction")
    }

    private fun normalizeStatus(raw: String): String = raw.trim().lowercase()

    private fun inRange(date: LocalDate?, from: LocalDate?, to: LocalDate?): Boolean {
        if (date == null) return from == null && to == null
        if (from != null && date.isBefore(from)) return false
        if (to != null && date.isAfter(to)) return false
        return true
    }

    // ---- Chart of accounts ----

    @Transactional(readOnly = true)
    fun accounts(): List<AccountView> {
        val accounts = accountRepository.findAll()
        val linesByAccount = lineRepository.findAll().groupBy { it.accountCode }
        return accounts.map { it.toView(balanceOf(it, linesByAccount[it.code] ?: emptyList())) }
    }

    @Transactional(readOnly = true)
    fun account(code: String): AccountView {
        val entity = getAccount(code)
        return entity.toView(balanceOf(entity, lineRepository.findByAccountCode(code)))
    }

    private fun balanceOf(account: ChartOfAccountJpaEntity, lines: List<JournalLineJpaEntity>): BigDecimal =
        lines.fold(BigDecimal.ZERO) { acc, line -> acc.add(signedAmount(account.type, line.debit, line.credit)) }
            .money()

    @Transactional
    fun createAccount(
        code: String, nameAr: String, nameEn: String?, type: String,
        parentCode: String?, branchId: UUID?,
    ): AccountView {
        if (accountRepository.existsById(code)) {
            throw ConflictException("error.accounting.account_code_exists", listOf(code))
        }
        if (parentCode != null) getAccount(parentCode)
        val saved = accountRepository.save(
            ChartOfAccountJpaEntity(
                code = code, nameAr = nameAr, nameEn = nameEn, type = type,
                parentCode = parentCode, branchId = branchId,
            ),
        )
        return saved.toView(BigDecimal.ZERO.setScale(2))
    }

    @Transactional
    fun updateAccount(code: String, nameAr: String?, nameEn: String?, type: String?, parentCode: String?): AccountView {
        val entity = getAccount(code)
        if (parentCode != null) {
            if (parentCode == code) throw BadRequestException("error.accounting.journal_line_invalid", listOf(code))
            getAccount(parentCode)
            entity.parentCode = parentCode
        }
        if (nameAr != null) entity.nameAr = nameAr
        if (nameEn != null) entity.nameEn = nameEn
        if (type != null) entity.type = type
        return accountRepository.save(entity)
            .toView(balanceOf(entity, lineRepository.findByAccountCode(code)))
    }

    @Transactional
    fun deleteAccount(code: String) {
        getAccount(code)
        if (accountRepository.existsByParentCode(code) || lineRepository.existsByAccountCode(code)) {
            throw ConflictException("error.accounting.account_code_exists", listOf(code))
        }
        accountRepository.deleteById(code)
    }

    private fun getAccount(code: String): ChartOfAccountJpaEntity =
        accountRepository.findById(code)
            .orElseThrow { NotFoundException("error.accounting.account_not_found", listOf(code)) }

    // ---- Journals ----

    @Transactional
    fun postJournal(
        branchId: UUID?, entryDate: LocalDate, source: String,
        ref: String?, memo: String?, lines: List<JournalLineInput>, by: String?,
    ): JournalView {
        if (lines.isEmpty()) throw BadRequestException("error.accounting.journal_empty")
        val names = mutableMapOf<String, String>()
        val normalized = lines.map { line ->
            val debit = line.debit.money()
            val credit = line.credit.money()
            val debitPositive = debit.compareTo(BigDecimal.ZERO) > 0
            val creditPositive = credit.compareTo(BigDecimal.ZERO) > 0
            if (debitPositive == creditPositive) {
                throw BadRequestException("error.accounting.journal_line_invalid", listOf(line.accountCode))
            }
            names[line.accountCode] = getAccount(line.accountCode).nameAr
            Triple(line.accountCode, debit, credit)
        }
        val totalDebit = normalized.fold(BigDecimal.ZERO) { acc, l -> acc.add(l.second) }.money()
        val totalCredit = normalized.fold(BigDecimal.ZERO) { acc, l -> acc.add(l.third) }.money()
        if (totalDebit.compareTo(totalCredit) != 0) {
            throw BadRequestException("error.accounting.journal_unbalanced", listOf(totalDebit, totalCredit))
        }
        val entry = entryRepository.save(
            JournalEntryJpaEntity(
                branchId = branchId, entryDate = entryDate,
                source = source, ref = ref, memo = memo,
            ),
        )
        val savedLines = normalized.map { (code, debit, credit) ->
            lineRepository.save(
                JournalLineJpaEntity(entryId = entry.id, accountCode = code, debit = debit, credit = credit),
            )
        }
        return entry.toView(savedLines.map { it.toView(names[it.accountCode] ?: it.accountCode) })
    }

    @Transactional(readOnly = true)
    fun journals(branchId: UUID?, from: LocalDate?, to: LocalDate?, source: String?): List<JournalView> {
        val entries = (if (branchId != null) entryRepository.findByBranchId(branchId) else entryRepository.findAll())
            .filter { inRange(it.entryDate, from, to) }
            .filter { source == null || it.source == source }
            .sortedWith(compareBy({ it.entryDate }, { it.createdAt }))
        if (entries.isEmpty()) return emptyList()
        val ids = entries.mapNotNull { it.id }
        val byEntry = lineRepository.findByEntryIdIn(ids).groupBy { it.entryId }
        val names = accountNames()
        return entries.map { entry ->
            entry.toView(
                (byEntry[entry.id] ?: emptyList()).map { line ->
                    line.toView(names[line.accountCode] ?: line.accountCode)
                },
            )
        }
    }

    @Transactional(readOnly = true)
    fun journal(id: UUID): JournalView {
        val entry = entryRepository.findById(id)
            .orElseThrow { NotFoundException("error.accounting.journal_not_found", listOf(id)) }
        val names = accountNames()
        return entry.toView(
            lineRepository.findByEntryId(id).map { line ->
                line.toView(names[line.accountCode] ?: line.accountCode)
            },
        )
    }

    @Transactional(readOnly = true)
    fun generalLedger(accountCode: String, from: LocalDate?, to: LocalDate?): List<LedgerLineView> {
        val account = getAccount(accountCode)
        val entries = (if (to != null) entryRepository.findByEntryDateLessThanEqual(to) else entryRepository.findAll())
            .sortedWith(compareBy({ it.entryDate }, { it.createdAt }))
        if (entries.isEmpty()) return emptyList()
        val byEntry = lineRepository.findByEntryIdIn(entries.mapNotNull { it.id }).groupBy { it.entryId }
        var running = BigDecimal.ZERO
        val rows = mutableListOf<LedgerLineView>()
        for (entry in entries) {
            val lines = (byEntry[entry.id] ?: emptyList()).filter { it.accountCode == accountCode }
            for (line in lines) {
                running = running.add(signedAmount(account.type, line.debit, line.credit))
                if (!inRange(entry.entryDate, from, to)) continue
                rows += LedgerLineView(
                    entryId = entry.id, entryDate = entry.entryDate, source = entry.source,
                    ref = entry.ref, accountCode = line.accountCode, accountName = account.nameAr,
                    debit = line.debit, credit = line.credit, runningBalance = running.money(),
                )
            }
        }
        return rows
    }

    // ---- Treasuries ----

    @Transactional(readOnly = true)
    fun treasuries(branchId: UUID?): List<TreasuryView> {
        val list = if (branchId != null) treasuryRepository.findByBranchId(branchId) else treasuryRepository.findAll()
        return list.map { it.toView() }
    }

    @Transactional(readOnly = true)
    fun treasury(id: UUID): TreasuryView = getTreasury(id).toView()

    @Transactional
    fun createTreasury(branchId: UUID?, name: String, openingBalance: BigDecimal?): TreasuryView {
        val saved = treasuryRepository.save(
            TreasuryJpaEntity(
                branchId = branchId, name = name,
                balance = (openingBalance ?: BigDecimal.ZERO).money(),
            ),
        )
        return saved.toView()
    }

    @Transactional
    fun updateTreasury(id: UUID, name: String?): TreasuryView {
        val entity = getTreasury(id)
        if (name != null) entity.name = name
        return treasuryRepository.save(entity).toView()
    }

    @Transactional
    fun deleteTreasury(id: UUID) {
        val entity = getTreasury(id)
        if (transferRepository.existsByFromIdOrToId(id, id)) {
            throw ConflictException("error.accounting.treasury_funds", listOf(entity.balance))
        }
        treasuryRepository.delete(entity)
    }

    @Transactional
    fun transfer(fromId: UUID, toId: UUID, amount: BigDecimal, by: String?): TransferView {
        val from = getTreasury(fromId)
        val to = getTreasury(toId)
        val value = amount.money()
        if (value.compareTo(BigDecimal.ZERO) <= 0 || fromId == toId) {
            throw BadRequestException("error.accounting.treasury_funds", listOf(from.balance))
        }
        if (from.balance.compareTo(value) < 0) {
            throw ConflictException("error.accounting.treasury_funds", listOf(from.balance))
        }
        from.balance = from.balance.subtract(value).money()
        to.balance = to.balance.add(value).money()
        treasuryRepository.save(from)
        treasuryRepository.save(to)
        val saved = transferRepository.save(
            TreasuryTransferJpaEntity(fromId = fromId, toId = toId, amount = value, by = by),
        )
        return saved.toView()
    }

    @Transactional(readOnly = true)
    fun transfers(treasuryId: UUID?): List<TransferView> {
        val list = if (treasuryId != null) {
            transferRepository.findByFromIdOrToId(treasuryId, treasuryId)
        } else {
            transferRepository.findAll()
        }
        return list.sortedWith(compareBy({ it.at }, { it.id })).map { it.toView() }
    }

    @Transactional(readOnly = true)
    fun transferById(id: UUID): TransferView =
        transferRepository.findById(id)
            .orElseThrow { NotFoundException("error.accounting.transfer_not_found", listOf(id)) }
            .toView()

    private fun getTreasury(id: UUID): TreasuryJpaEntity =
        treasuryRepository.findById(id)
            .orElseThrow { NotFoundException("error.accounting.treasury_not_found", listOf(id)) }

    // ---- Expenses ----

    @Transactional(readOnly = true)
    fun expenses(branchId: UUID?): List<ExpenseView> {
        val list = if (branchId != null) expenseRepository.findByBranchId(branchId) else expenseRepository.findAll()
        return list.map { it.toView() }
    }

    @Transactional(readOnly = true)
    fun expense(id: UUID): ExpenseView = getExpense(id).toView()

    @Transactional
    fun createExpense(
        branchId: UUID?, category: String, amount: BigDecimal,
        receiptPhoto: String?, approvedBy: String?,
    ): ExpenseView {
        val saved = expenseRepository.save(
            ExpenseJpaEntity(
                branchId = branchId, category = category, amount = amount.money(),
                receiptPhoto = receiptPhoto, approvedBy = approvedBy,
            ),
        )
        return saved.toView()
    }

    @Transactional
    fun updateExpense(
        id: UUID, category: String?, amount: BigDecimal?,
        receiptPhoto: String?, approvedBy: String?,
    ): ExpenseView {
        val entity = getExpense(id)
        if (category != null) entity.category = category
        if (amount != null) entity.amount = amount.money()
        if (receiptPhoto != null) entity.receiptPhoto = receiptPhoto
        if (approvedBy != null) entity.approvedBy = approvedBy
        return expenseRepository.save(entity).toView()
    }

    @Transactional
    fun deleteExpense(id: UUID) {
        expenseRepository.delete(getExpense(id))
    }

    private fun getExpense(id: UUID): ExpenseJpaEntity =
        expenseRepository.findById(id)
            .orElseThrow { NotFoundException("error.accounting.expense_not_found", listOf(id)) }

    // ---- Checks ----

    @Transactional(readOnly = true)
    fun checks(status: String?): List<CheckView> {
        if (status == null) return checkRepository.findAll().map { it.toView() }
        val normalized = normalizeStatus(status)
        if (normalized !in CHECK_STATUSES) return emptyList()
        return checkRepository.findByStatus(normalized).map { it.toView() }
    }

    @Transactional(readOnly = true)
    fun check(id: UUID): CheckView = getCheck(id).toView()

    @Transactional
    fun createCheck(direction: String, amount: BigDecimal, dueDate: LocalDate?, party: String?): CheckView {
        val saved = checkRepository.save(
            CheckJpaEntity(
                direction = normalizeDirection(direction), amount = amount.money(),
                dueDate = dueDate, party = party, status = "held",
            ),
        )
        return saved.toView()
    }

    @Transactional
    fun updateCheck(id: UUID, dueDate: LocalDate?, party: String?): CheckView {
        val entity = getCheck(id)
        if (dueDate != null) entity.dueDate = dueDate
        if (party != null) entity.party = party
        return checkRepository.save(entity).toView()
    }

    @Transactional
    fun deleteCheck(id: UUID) {
        checkRepository.delete(getCheck(id))
    }

    @Transactional
    fun checkStatus(id: UUID, status: String): CheckView {
        val entity = getCheck(id)
        if (entity.status == "cashed" || entity.status == "bounced") {
            throw ConflictException("error.accounting.check_status", listOf(entity.status))
        }
        val normalized = normalizeStatus(status)
        if (normalized != "cashed" && normalized != "bounced" && normalized != "returned") {
            throw BadRequestException("error.accounting.check_status", listOf(normalized))
        }
        entity.status = normalized
        return checkRepository.save(entity).toView()
    }

    private fun getCheck(id: UUID): CheckJpaEntity =
        checkRepository.findById(id)
            .orElseThrow { NotFoundException("error.accounting.check_not_found", listOf(id)) }

    // ---- Reports (read-only, computed from journals + chart) ----

    private fun reportRange(from: LocalDate?, to: LocalDate?): Pair<LocalDate, LocalDate> {
        if (from == null || to == null || from.isAfter(to)) {
            throw BadRequestException("error.accounting.report_dates", listOf(from ?: "", to ?: ""))
        }
        return from to to
    }

    private fun linesInRange(from: LocalDate, to: LocalDate): List<JournalLineJpaEntity> {
        val entries = entryRepository.findByEntryDateBetween(from, to)
        if (entries.isEmpty()) return emptyList()
        return lineRepository.findByEntryIdIn(entries.mapNotNull { it.id })
    }

    private fun accountTypes(): Map<String, String> =
        accountRepository.findAll().associate { it.code to it.type }

    private fun accountNames(): Map<String, String> =
        accountRepository.findAll().associate { it.code to it.nameAr }

    private fun vatPortion(inclusiveTotal: BigDecimal): BigDecimal {
        if (inclusiveTotal.compareTo(BigDecimal.ZERO) == 0) return BigDecimal.ZERO.setScale(2)
        return inclusiveTotal.multiply(VAT_RATE).divide(VAT_DIVISOR, 2, RoundingMode.HALF_EVEN)
    }

    @Transactional(readOnly = true)
    fun profitLoss(from: LocalDate?, to: LocalDate?): ProfitLossView {
        val (f, t) = reportRange(from, to)
        val types = accountTypes()
        var revenue = BigDecimal.ZERO
        var cogs = BigDecimal.ZERO
        var expenses = BigDecimal.ZERO
        for (line in linesInRange(f, t)) {
            when (types[line.accountCode]) {
                "REVENUE" -> revenue = revenue.add(line.credit.subtract(line.debit))
                "EXPENSE" -> {
                    val net = line.debit.subtract(line.credit)
                    if (line.accountCode == COGS_CODE) cogs = cogs.add(net) else expenses = expenses.add(net)
                }
            }
        }
        revenue = revenue.money()
        cogs = cogs.money()
        expenses = expenses.money()
        val net = revenue.subtract(cogs).subtract(expenses).money()
        return ProfitLossView(f, t, revenue, cogs, expenses, net, vatPortion(revenue))
    }

    @Transactional(readOnly = true)
    fun balanceSheet(to: LocalDate?): BalanceSheetView {
        if (to == null) throw BadRequestException("error.accounting.report_dates", listOf("", ""))
        val types = accountTypes()
        val entries = entryRepository.findByEntryDateLessThanEqual(to)
        val lines = if (entries.isEmpty()) emptyList()
        else lineRepository.findByEntryIdIn(entries.mapNotNull { it.id })
        var assets = BigDecimal.ZERO
        var liabilities = BigDecimal.ZERO
        var equity = BigDecimal.ZERO
        for (line in lines) {
            when (types[line.accountCode]) {
                "ASSET" -> assets = assets.add(line.debit.subtract(line.credit))
                "LIABILITY" -> liabilities = liabilities.add(line.credit.subtract(line.debit))
                "EQUITY" -> equity = equity.add(line.credit.subtract(line.debit))
            }
        }
        return BalanceSheetView(to, assets.money(), liabilities.money(), equity.money())
    }

    @Transactional(readOnly = true)
    fun taxReport(from: LocalDate?, to: LocalDate?): TaxReportView {
        val (f, t) = reportRange(from, to)
        val types = accountTypes()
        var revenue = BigDecimal.ZERO
        var purchases = BigDecimal.ZERO
        for (line in linesInRange(f, t)) {
            when (types[line.accountCode]) {
                "REVENUE" -> revenue = revenue.add(line.credit.subtract(line.debit))
                "EXPENSE" -> purchases = purchases.add(line.debit.subtract(line.credit))
            }
        }
        revenue = revenue.money()
        purchases = purchases.money()
        val outputVat = vatPortion(revenue)
        val inputVat = vatPortion(purchases)
        return TaxReportView(
            from = f, to = t,
            revenueInclusive = revenue,
            vatPortion = outputVat,
            purchasesInclusive = purchases,
            inputVat = inputVat,
            netVatPayable = outputVat.subtract(inputVat).money(),
        )
    }

    // ---- Mappers ----

    private fun ChartOfAccountJpaEntity.toView(balance: BigDecimal) = AccountView(
        code, nameAr, type, parentCode, branchId, balance,
    )

    private fun JournalLineJpaEntity.toView(accountName: String) =
        JournalLineView(id, accountCode, accountName, debit, credit)

    private fun JournalEntryJpaEntity.toView(lines: List<JournalLineView>) = JournalView(
        id = id, branchId = branchId, entryDate = entryDate, source = source,
        ref = ref, memo = memo, lines = lines,
        totalDebit = lines.fold(BigDecimal.ZERO) { acc, l -> acc.add(l.debit) }.money(),
        totalCredit = lines.fold(BigDecimal.ZERO) { acc, l -> acc.add(l.credit) }.money(),
    )

    private fun TreasuryJpaEntity.toView() = TreasuryView(id, branchId, name, balance)

    private fun TreasuryTransferJpaEntity.toView() = TransferView(id, fromId, toId, amount, at, by)

    private fun ExpenseJpaEntity.toView() =
        ExpenseView(id, branchId, category, amount, receiptPhoto, approvedBy, createdAt)

    private fun CheckJpaEntity.toView() =
        CheckView(id, direction, amount, dueDate, status, party, createdAt)
}
