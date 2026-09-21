package com.mostafasensei.alamelmarateb.modules.product.data.repository

import com.mostafasensei.alamelmarateb.modules.product.domain.entity.PresetAttributeValueJpaEntity
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import java.util.UUID

@Repository
interface PresetAttributeValueJpaRepository : JpaRepository<PresetAttributeValueJpaEntity, UUID> {
    fun findByPresetId(presetId: UUID): List<PresetAttributeValueJpaEntity>
}
