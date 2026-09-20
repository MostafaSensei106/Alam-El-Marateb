package com.mostafasensei.alamelmarateb.modules.accounting.data.repository

import com.mostafasensei.alamelmarateb.modules.accounting.domain.entity.ChartOfAccountJpaEntity
import com.mostafasensei.alamelmarateb.modules.accounting.domain.entity.CheckJpaEntity
import com.mostafasensei.alamelmarateb.modules.accounting.domain.entity.ExpenseJpaEntity
import com.mostafasensei.alamelmarateb.modules.accounting.domain.entity.JournalEntryJpaEntity
import com.mostafasensei.alamelmarateb.modules.accounting.domain.entity.JournalLineJpaEntity
import com.mostafasensei.alamelmarateb.modules.accounting.domain.entity.TreasuryJpaEntity
import com.mostafasensei.alamelmarateb.modules.accounting.domain.entity.TreasuryTransferJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.time.LocalDate
import java.util.UUID

@Repository
interface ChartOfAccountRepository : JpaRepository<ChartOfAccountJpaEntity, String> {
    fun existsByParentCode(parentCode: String): Boolean
    fun findByBranchId(branchId: UUID): List<ChartOfAccountJpaEntity>
}

@Repository
interface JournalEntryRepository : JpaRepository<JournalEntryJpaEntity, UUID> {
    fun findByBranchId(branchId: UUID): List<JournalEntryJpaEntity>
    fun findByEntryDateBetween(from: LocalDate, to: LocalDate): List<JournalEntryJpaEntity>
    fun findByEntryDateLessThanEqual(to: LocalDate): List<JournalEntryJpaEntity>
}

@Repository
interface JournalLineRepository : JpaRepository<JournalLineJpaEntity, UUID> {
    fun findByEntryId(entryId: UUID): List<JournalLineJpaEntity>
    fun findByEntryIdIn(entryIds: Collection<UUID>): List<JournalLineJpaEntity>
    fun existsByAccountCode(accountCode: String): Boolean
}

@Repository
interface TreasuryRepository : JpaRepository<TreasuryJpaEntity, UUID> {
    fun findByBranchId(branchId: UUID): List<TreasuryJpaEntity>
}

@Repository
interface TreasuryTransferRepository : JpaRepository<TreasuryTransferJpaEntity, UUID> {
    fun existsByFromIdOrToId(fromId: UUID, toId: UUID): Boolean
}

@Repository
interface ExpenseRepository : JpaRepository<ExpenseJpaEntity, UUID> {
    fun findByBranchId(branchId: UUID): List<ExpenseJpaEntity>
}

@Repository
interface CheckRepository : JpaRepository<CheckJpaEntity, UUID> {
    fun findByStatus(status: String): List<CheckJpaEntity>
}
