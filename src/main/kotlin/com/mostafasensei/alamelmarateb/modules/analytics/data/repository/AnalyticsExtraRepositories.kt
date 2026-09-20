package com.mostafasensei.alamelmarateb.modules.analytics.data.repository

import com.mostafasensei.alamelmarateb.modules.analytics.domain.entity.AppEventJpaEntity
import com.mostafasensei.alamelmarateb.modules.analytics.domain.entity.InquiryJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface InquiryRepository : JpaRepository<InquiryJpaEntity, UUID> {
    fun findByBranchIdOrderByCreatedAtDesc(branchId: UUID): List<InquiryJpaEntity>
}

@Repository
interface AppEventRepository : JpaRepository<AppEventJpaEntity, UUID>
