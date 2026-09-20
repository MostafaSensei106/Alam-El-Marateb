package com.mostafasensei.alamelmarateb.modules.estimator.data.repository

import com.mostafasensei.alamelmarateb.modules.estimator.domain.entity.EstimateRunJpaEntity
import com.mostafasensei.alamelmarateb.modules.estimator.domain.entity.SpinCampaignJpaEntity
import com.mostafasensei.alamelmarateb.modules.estimator.domain.entity.SpinPlayJpaEntity
import com.mostafasensei.alamelmarateb.modules.estimator.domain.entity.SpinPrizeJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface EstimateRunRepository : JpaRepository<EstimateRunJpaEntity, UUID>

@Repository
interface SpinCampaignRepository : JpaRepository<SpinCampaignJpaEntity, UUID> {
    fun findByIsActiveTrueOrderByStartsAtDesc(): List<SpinCampaignJpaEntity>
}

@Repository
interface SpinPrizeRepository : JpaRepository<SpinPrizeJpaEntity, UUID> {
    fun findByCampaignIdOrderBySortOrderAsc(campaignId: UUID): List<SpinPrizeJpaEntity>
    fun countByCampaignId(campaignId: UUID): Long
}

@Repository
interface SpinPlayRepository : JpaRepository<SpinPlayJpaEntity, UUID> {
    fun countByCampaignIdAndUserId(campaignId: UUID, userId: UUID): Long
    fun countByPrizeIdAndWonTrue(prizeId: UUID): Long
}
