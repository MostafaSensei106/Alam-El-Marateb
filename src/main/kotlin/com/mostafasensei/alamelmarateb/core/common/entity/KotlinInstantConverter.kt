package com.mostafasensei.alamelmarateb.core.common.entity

import jakarta.persistence.AttributeConverter
import jakarta.persistence.Converter
import java.sql.Timestamp
import kotlin.time.Instant
import kotlin.time.toJavaInstant
import kotlin.time.toKotlinInstant

/**
 * Lets all entities keep kotlinx-datetime [Instant] while Hibernate
 * persists them as regular TIMESTAMPTZ. Auto-applied everywhere.
 */
@Converter(autoApply = true)
class KotlinInstantConverter : AttributeConverter<Instant, Timestamp> {
    override fun convertToDatabaseColumn(attribute: Instant?): Timestamp? =
        attribute?.let { Timestamp.from(it.toJavaInstant()) }

    override fun convertToEntityAttribute(dbData: Timestamp?): Instant? =
        dbData?.toInstant()?.toKotlinInstant()
}
