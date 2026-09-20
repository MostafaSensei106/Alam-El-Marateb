package com.mostafasensei.alamelmarateb.modules.accounting.domain.entity

import com.mostafasensei.alamelmarateb.core.common.entity.EntityBase
import jakarta.persistence.Column
import jakarta.persistence.Entity
import jakarta.persistence.EntityListeners
import jakarta.persistence.Id
import jakarta.persistence.Table
import jakarta.persistence.Version
import org.hibernate.annotations.CreationTimestamp
import org.hibernate.annotations.UpdateTimestamp
import org.springframework.data.annotation.CreatedBy
import org.springframework.data.annotation.LastModifiedBy
import org.springframework.data.jpa.domain.support.AuditingEntityListener
import java.math.BigDecimal
import java.time.LocalDate
import java.util.UUID

/**
 * Chart of accounts — String PK (hierarchical code), so it cannot extend
 * EntityBase<UUID>; audit columns are mapped explicitly to match V11.
 */
@Entity
@Table(name = "chart_of_accounts")
@EntityListeners(AuditingEntityListener::class)
class ChartOfAccountJpaEntity(
    @Id
    @Column(name = "code", nullable = false, length = 20)
    var code: String = "",

    @Column(name = "name_ar", nullable = false, length = 150)
    var nameAr: String = "",

    @Column(name = "name_en", length = 150)
    var nameEn: String? = null,

    @Column(name = "type", nullable = false, length = 20)
    var type: String = "",

    @Column(name = "parent_code", length = 20)
    var parentCode: String? = null,

    @Column(name = "branch_id", columnDefinition = "UUID")
    var branchId: UUID? = null,

    @CreationTimestamp
    @Column(name = "created_at", updatable = false, nullable = false)
    var createdAt: java.time.Instant = kotlin.time.Clock.System.now(),

    @UpdateTimestamp
    @Column(name = "updated_at", nullable = false)
    var updatedAt: java.time.Instant = kotlin.time.Clock.System.now(),

    @CreatedBy
    @Column(name = "created_by", nullable = false, updatable = false)
    var createdBy: String? = null,

    @LastModifiedBy
    @Column(name = "updated_by")
    var updatedBy: String? = null,

    @Version
    @Column(name = "version", nullable = false)
    var version: Long = 0,
)

@Entity
@Table(name = "journal_entries")
class JournalEntryJpaEntity(
    @Column(name = "branch_id", columnDefinition = "UUID")
    var branchId: UUID? = null,

    @Column(name = "entry_date", nullable = false)
    var entryDate: LocalDate? = null,

    @Column(name = "source", nullable = false, length = 30)
    var source: String = "",

    @Column(name = "ref", length = 100)
    var ref: String? = null,

    @Column(name = "memo", columnDefinition = "TEXT")
    var memo: String? = null,
) : EntityBase<UUID>()

@Entity
@Table(name = "journal_lines")
class JournalLineJpaEntity(
    @Column(name = "entry_id", nullable = false, columnDefinition = "UUID")
    var entryId: UUID? = null,

    @Column(name = "account_code", nullable = false, length = 20)
    var accountCode: String = "",

    @Column(name = "debit", nullable = false, precision = 12, scale = 2)
    var debit: BigDecimal = BigDecimal.ZERO,

    @Column(name = "credit", nullable = false, precision = 12, scale = 2)
    var credit: BigDecimal = BigDecimal.ZERO,
) : EntityBase<UUID>()

@Entity
@Table(name = "treasuries")
class TreasuryJpaEntity(
    @Column(name = "branch_id", columnDefinition = "UUID")
    var branchId: UUID? = null,

    @Column(name = "name", nullable = false, length = 150)
    var name: String = "",

    @Column(name = "balance", nullable = false, precision = 12, scale = 2)
    var balance: BigDecimal = BigDecimal.ZERO,
) : EntityBase<UUID>()

@Entity
@Table(name = "treasury_transfers")
class TreasuryTransferJpaEntity(
    @Column(name = "from_id", nullable = false, columnDefinition = "UUID")
    var fromId: UUID? = null,

    @Column(name = "to_id", nullable = false, columnDefinition = "UUID")
    var toId: UUID? = null,

    @Column(name = "amount", nullable = false, precision = 12, scale = 2)
    var amount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "at", nullable = false)
    var at: java.time.Instant = kotlin.time.Clock.System.now(),

    @Column(name = "by_name", length = 100)
    var by: String? = null,
) : EntityBase<UUID>()

@Entity
@Table(name = "expenses")
class ExpenseJpaEntity(
    @Column(name = "branch_id", columnDefinition = "UUID")
    var branchId: UUID? = null,

    @Column(name = "category", nullable = false, length = 100)
    var category: String = "",

    @Column(name = "amount", nullable = false, precision = 12, scale = 2)
    var amount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "receipt_photo", columnDefinition = "TEXT")
    var receiptPhoto: String? = null,

    @Column(name = "approved_by", length = 100)
    var approvedBy: String? = null,
) : EntityBase<UUID>()

@Entity
@Table(name = "checks")
class CheckJpaEntity(
    @Column(name = "direction", nullable = false, length = 10)
    var direction: String = "",

    @Column(name = "amount", nullable = false, precision = 12, scale = 2)
    var amount: BigDecimal = BigDecimal.ZERO,

    @Column(name = "due_date")
    var dueDate: LocalDate? = null,

    @Column(name = "status", nullable = false, length = 20)
    var status: String = "held",

    @Column(name = "party", length = 150)
    var party: String? = null,
) : EntityBase<UUID>()
