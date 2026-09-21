package com.mostafasensei.alamelmarateb.modules.accounting.presentation

import com.mostafasensei.alamelmarateb.core.common.api_response.ApiResponse
import com.mostafasensei.alamelmarateb.core.common.presentation.BaseController
import com.mostafasensei.alamelmarateb.core.i18n.MessageService
import com.mostafasensei.alamelmarateb.core.router.AccountingRoutes
import com.mostafasensei.alamelmarateb.core.security.UserPrincipal
import com.mostafasensei.alamelmarateb.modules.accounting.application.AccountView
import com.mostafasensei.alamelmarateb.modules.accounting.application.AccountingService
import com.mostafasensei.alamelmarateb.modules.accounting.application.BalanceSheetView
import com.mostafasensei.alamelmarateb.modules.accounting.application.CheckView
import com.mostafasensei.alamelmarateb.modules.accounting.application.ExpenseView
import com.mostafasensei.alamelmarateb.modules.accounting.application.JournalLineInput
import com.mostafasensei.alamelmarateb.modules.accounting.application.JournalView
import com.mostafasensei.alamelmarateb.modules.accounting.application.LedgerLineView
import com.mostafasensei.alamelmarateb.modules.accounting.application.ProfitLossView
import com.mostafasensei.alamelmarateb.modules.accounting.application.TaxReportView
import com.mostafasensei.alamelmarateb.modules.accounting.application.TransferView
import com.mostafasensei.alamelmarateb.modules.accounting.application.TreasuryView
import com.mostafasensei.alamelmarateb.modules.accounting.presentation.dto.CheckRequest
import com.mostafasensei.alamelmarateb.modules.accounting.presentation.dto.CheckStatusRequest
import com.mostafasensei.alamelmarateb.modules.accounting.presentation.dto.CreateAccountRequest
import com.mostafasensei.alamelmarateb.modules.accounting.presentation.dto.CreateTreasuryRequest
import com.mostafasensei.alamelmarateb.modules.accounting.presentation.dto.ExpenseRequest
import com.mostafasensei.alamelmarateb.modules.accounting.presentation.dto.PostJournalRequest
import com.mostafasensei.alamelmarateb.modules.accounting.presentation.dto.TransferRequest
import com.mostafasensei.alamelmarateb.modules.accounting.presentation.dto.UpdateAccountRequest
import com.mostafasensei.alamelmarateb.modules.accounting.presentation.dto.UpdateCheckRequest
import com.mostafasensei.alamelmarateb.modules.accounting.presentation.dto.UpdateExpenseRequest
import com.mostafasensei.alamelmarateb.modules.accounting.presentation.dto.UpdateTreasuryRequest
import io.swagger.v3.oas.annotations.Operation
import io.swagger.v3.oas.annotations.tags.Tag
import jakarta.validation.Valid
import org.springframework.format.annotation.DateTimeFormat
import org.springframework.http.ResponseEntity
import org.springframework.security.access.prepost.PreAuthorize
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.DeleteMapping
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.PutMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import java.time.LocalDate
import java.util.UUID

private const val ACCOUNTANT_ACCESS = "hasAnyRole('ACCOUNTANT','SUPER_ADMIN')"

@Tag(name = "Accounting — chart", description = "Chart of accounts — ACCOUNTANT")
@RestController
@RequestMapping(AccountingRoutes.CHART_OF_ACCOUNTS)
@PreAuthorize(ACCOUNTANT_ACCESS)
class ChartOfAccountsController(
    private val accountingService: AccountingService,
) : BaseController() {

    @Operation(summary = "List accounts")
    @GetMapping
    fun list(): ResponseEntity<ApiResponse<List<AccountView>>> =
        ok(accountingService.accounts())

    @Operation(summary = "Create account")
    @PostMapping
    fun create(
        @Valid @RequestBody request: CreateAccountRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<AccountView>> =
        created(
            accountingService.createAccount(
                request.code, request.nameAr, request.nameEn,
                request.type, request.parentCode, request.branchId,
            ),
        )

    @Operation(summary = "Get account by code")
    @GetMapping("/{code}")
    fun get(@PathVariable code: String): ResponseEntity<ApiResponse<AccountView>> =
        ok(accountingService.account(code))

    @Operation(summary = "Update account")
    @PatchMapping("/{code}")
    fun patchUpdate(
        @PathVariable code: String,
        @Valid @RequestBody request: UpdateAccountRequest,
    ): ResponseEntity<ApiResponse<AccountView>> =
        update(code, request)

    @PutMapping("/{code}")
    fun update(
        @PathVariable code: String,
        @Valid @RequestBody request: UpdateAccountRequest,
    ): ResponseEntity<ApiResponse<AccountView>> =
        ok(accountingService.updateAccount(code, request.nameAr, request.nameEn, request.type, request.parentCode))

    @Operation(summary = "Delete account (only with no children and no lines)")
    @DeleteMapping("/{code}")
    fun delete(@PathVariable code: String): ResponseEntity<ApiResponse<Nothing>> {
        accountingService.deleteAccount(code)
        return deleted(MessageService.t("success.deleted"))
    }
}

@Tag(name = "Accounting — journals", description = "Journal entries — ACCOUNTANT")
@RestController
@RequestMapping(AccountingRoutes.JOURNAL_ENTRIES)
@PreAuthorize(ACCOUNTANT_ACCESS)
class JournalEntriesController(
    private val accountingService: AccountingService,
) : BaseController() {

    @Operation(summary = "Post balanced journal")
    @PostMapping
    fun post(
        @Valid @RequestBody request: PostJournalRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<JournalView>> =
        created(
            accountingService.postJournal(
                request.branchId, request.entryDate, request.source, request.ref, request.memo,
                request.lines.map { JournalLineInput(it.accountCode, it.debit, it.credit) },
                principal.fullName,
            ),
        )

    @Operation(summary = "List journals")
    @GetMapping
    fun list(@RequestParam(required = false) branchId: UUID?): ResponseEntity<ApiResponse<List<JournalView>>> =
        ok(accountingService.journals(branchId))

    @Operation(summary = "Get journal by id")
    @GetMapping("/{id}")
    fun get(@PathVariable id: UUID): ResponseEntity<ApiResponse<JournalView>> =
        ok(accountingService.journal(id))
}

@Tag(name = "Accounting — ledger", description = "General ledger — ACCOUNTANT")
@RestController
@RequestMapping(AccountingRoutes.GENERAL_LEDGER)
@PreAuthorize(ACCOUNTANT_ACCESS)
class GeneralLedgerController(
    private val accountingService: AccountingService,
) : BaseController() {

    @Operation(summary = "General ledger for an account, ordered by entry date")
    @GetMapping
    fun ledger(
        @RequestParam accountCode: String,
        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) from: LocalDate?,
        @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) to: LocalDate?,
    ): ResponseEntity<ApiResponse<List<LedgerLineView>>> =
        ok(accountingService.generalLedger(accountCode, from, to))
}

@Tag(name = "Accounting — treasuries", description = "Treasuries — ACCOUNTANT")
@RestController
@RequestMapping(AccountingRoutes.TREASURIES)
@PreAuthorize(ACCOUNTANT_ACCESS)
class TreasuriesController(
    private val accountingService: AccountingService,
) : BaseController() {

    @Operation(summary = "List treasuries")
    @GetMapping
    fun list(@RequestParam(required = false) branchId: UUID?): ResponseEntity<ApiResponse<List<TreasuryView>>> =
        ok(accountingService.treasuries(branchId))

    @Operation(summary = "Create treasury")
    @PostMapping
    fun create(@Valid @RequestBody request: CreateTreasuryRequest): ResponseEntity<ApiResponse<TreasuryView>> =
        created(accountingService.createTreasury(request.branchId, request.name, request.openingBalance))

    @Operation(summary = "Get treasury by id")
    @GetMapping("/{id}")
    fun get(@PathVariable id: UUID): ResponseEntity<ApiResponse<TreasuryView>> =
        ok(accountingService.treasury(id))

    @Operation(summary = "Update treasury")
    @PatchMapping("/{id}")
    fun patchUpdate(
        @PathVariable id: UUID,
        @Valid @RequestBody request: UpdateTreasuryRequest,
    ): ResponseEntity<ApiResponse<TreasuryView>> =
        update(id, request)

    @PutMapping("/{id}")
    fun update(
        @PathVariable id: UUID,
        @Valid @RequestBody request: UpdateTreasuryRequest,
    ): ResponseEntity<ApiResponse<TreasuryView>> =
        ok(accountingService.updateTreasury(id, request.name))

    @Operation(summary = "Delete treasury")
    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID): ResponseEntity<ApiResponse<Nothing>> {
        accountingService.deleteTreasury(id)
        return deleted(MessageService.t("success.deleted"))
    }
}

@Tag(name = "Accounting — transfers", description = "Treasury transfers — ACCOUNTANT")
@RestController
@RequestMapping(AccountingRoutes.TREASURY_TRANSFERS)
@PreAuthorize(ACCOUNTANT_ACCESS)
class TreasuryTransfersController(
    private val accountingService: AccountingService,
) : BaseController() {

    @Operation(summary = "Transfer funds between treasuries (atomic)")
    @PostMapping
    fun transfer(
        @Valid @RequestBody request: TransferRequest,
        @AuthenticationPrincipal principal: UserPrincipal,
    ): ResponseEntity<ApiResponse<TransferView>> =
        created(accountingService.transfer(request.fromId, request.toId, request.amount, principal.fullName))
}

@Tag(name = "Accounting — expenses", description = "Expenses — ACCOUNTANT")
@RestController
@RequestMapping(AccountingRoutes.EXPENSES)
@PreAuthorize(ACCOUNTANT_ACCESS)
class ExpensesController(
    private val accountingService: AccountingService,
) : BaseController() {

    @Operation(summary = "List expenses")
    @GetMapping
    fun list(@RequestParam(required = false) branchId: UUID?): ResponseEntity<ApiResponse<List<ExpenseView>>> =
        ok(accountingService.expenses(branchId))

    @Operation(summary = "Create expense")
    @PostMapping
    fun create(@Valid @RequestBody request: ExpenseRequest): ResponseEntity<ApiResponse<ExpenseView>> =
        created(
            accountingService.createExpense(
                request.branchId, request.category, request.amount,
                request.receiptPhoto, request.approvedBy,
            ),
        )

    @Operation(summary = "Get expense by id")
    @GetMapping("/{id}")
    fun get(@PathVariable id: UUID): ResponseEntity<ApiResponse<ExpenseView>> =
        ok(accountingService.expense(id))

    @Operation(summary = "Update expense")
    @PatchMapping("/{id}")
    fun patchUpdate(
        @PathVariable id: UUID,
        @Valid @RequestBody request: UpdateExpenseRequest,
    ): ResponseEntity<ApiResponse<ExpenseView>> =
        update(id, request)

    @PutMapping("/{id}")
    fun update(
        @PathVariable id: UUID,
        @Valid @RequestBody request: UpdateExpenseRequest,
    ): ResponseEntity<ApiResponse<ExpenseView>> =
        ok(accountingService.updateExpense(id, request.category, request.amount, request.receiptPhoto, request.approvedBy))

    @Operation(summary = "Delete expense")
    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID): ResponseEntity<ApiResponse<Nothing>> {
        accountingService.deleteExpense(id)
        return deleted(MessageService.t("success.deleted"))
    }
}

@Tag(name = "Accounting — checks", description = "Checks — ACCOUNTANT")
@RestController
@RequestMapping(AccountingRoutes.CHECKS)
@PreAuthorize(ACCOUNTANT_ACCESS)
class ChecksController(
    private val accountingService: AccountingService,
) : BaseController() {

    @Operation(summary = "List checks")
    @GetMapping
    fun list(@RequestParam(required = false) status: String?): ResponseEntity<ApiResponse<List<CheckView>>> =
        ok(accountingService.checks(status))

    @Operation(summary = "Create check")
    @PostMapping
    fun create(@Valid @RequestBody request: CheckRequest): ResponseEntity<ApiResponse<CheckView>> =
        created(accountingService.createCheck(request.direction, request.amount, request.dueDate, request.party))

    @Operation(summary = "Get check by id")
    @GetMapping("/{id}")
    fun get(@PathVariable id: UUID): ResponseEntity<ApiResponse<CheckView>> =
        ok(accountingService.check(id))

    @Operation(summary = "Update check")
    @PatchMapping("/{id}")
    fun patchUpdate(
        @PathVariable id: UUID,
        @Valid @RequestBody request: UpdateCheckRequest,
    ): ResponseEntity<ApiResponse<CheckView>> =
        update(id, request)

    @PutMapping("/{id}")
    fun update(
        @PathVariable id: UUID,
        @Valid @RequestBody request: UpdateCheckRequest,
    ): ResponseEntity<ApiResponse<CheckView>> =
        ok(accountingService.updateCheck(id, request.dueDate, request.party))

    @Operation(summary = "Delete check")
    @DeleteMapping("/{id}")
    fun delete(@PathVariable id: UUID): ResponseEntity<ApiResponse<Nothing>> {
        accountingService.deleteCheck(id)
        return deleted(MessageService.t("success.deleted"))
    }

    @Operation(summary = "Move check status (held -> cashed/bounced/returned)")
    @PostMapping("/{id}/status")
    fun status(
        @PathVariable id: UUID,
        @Valid @RequestBody request: CheckStatusRequest,
    ): ResponseEntity<ApiResponse<CheckView>> =
        ok(accountingService.checkStatus(id, request.status))
}

@Tag(name = "Accounting — tax report", description = "VAT report (prices VAT-inclusive) — ACCOUNTANT")
@RestController
@RequestMapping(AccountingRoutes.TAX_REPORT)
@PreAuthorize(ACCOUNTANT_ACCESS)
class TaxReportController(
    private val accountingService: AccountingService,
) : BaseController() {

    @Operation(summary = "Tax report: VAT-inclusive revenue + 14/114 VAT portion")
    @GetMapping
    fun tax(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) from: LocalDate,
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) to: LocalDate,
    ): ResponseEntity<ApiResponse<TaxReportView>> =
        ok(accountingService.taxReport(from, to))
}

@Tag(name = "Accounting — profit & loss", description = "Profit/loss report — ACCOUNTANT")
@RestController
@RequestMapping(AccountingRoutes.PROFIT_AND_LOSS)
@PreAuthorize(ACCOUNTANT_ACCESS)
class ProfitLossController(
    private val accountingService: AccountingService,
) : BaseController() {

    @Operation(summary = "Profit & loss: revenue - COGS - expenses")
    @GetMapping
    fun profitLoss(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) from: LocalDate,
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) to: LocalDate,
    ): ResponseEntity<ApiResponse<ProfitLossView>> =
        ok(accountingService.profitLoss(from, to))
}

@Tag(name = "Accounting — balance sheet", description = "Balance sheet report — ACCOUNTANT")
@RestController
@RequestMapping(AccountingRoutes.BALANCE_SHEET)
@PreAuthorize(ACCOUNTANT_ACCESS)
class BalanceSheetController(
    private val accountingService: AccountingService,
) : BaseController() {

    @Operation(summary = "Balance sheet: assets, liabilities, equity as of date")
    @GetMapping
    fun balanceSheet(
        @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) to: LocalDate,
    ): ResponseEntity<ApiResponse<BalanceSheetView>> =
        ok(accountingService.balanceSheet(to))
}
