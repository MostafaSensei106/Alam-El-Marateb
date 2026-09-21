package com.mostafasensei.alamelmarateb.core.config

import org.springframework.boot.jackson.autoconfigure.JsonMapperBuilderCustomizer
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import tools.jackson.core.JsonGenerator
import tools.jackson.core.JsonParser
import tools.jackson.databind.DeserializationContext
import tools.jackson.databind.SerializationContext
import tools.jackson.databind.deser.std.StdDeserializer
import tools.jackson.databind.module.SimpleModule
import tools.jackson.databind.ser.std.StdSerializer
import kotlin.time.Instant

/**
 * API JSON contract fixes:
 * - `kotlin.time.Instant` (ApiResponse.timestamp, every createdAt/updatedAt)
 *   serializes as ISO-8601 (`2026-09-21T12:00:00.123Z`) instead of the raw
 *   `{epochSeconds, nanosecondsOfSecond}` object no frontend can use.
 *   Deserializer accepts the same shape back.
 */
@Configuration
class JacksonConfig {

    @Bean
    fun kotlinInstantCustomizer(): JsonMapperBuilderCustomizer =
        JsonMapperBuilderCustomizer { builder ->
            builder.addModule(
                SimpleModule("KotlinInstantModule")
                    .addSerializer(Instant::class.java, KotlinInstantSerializer)
                    .addDeserializer(Instant::class.java, KotlinInstantDeserializer),
            )
        }

    object KotlinInstantSerializer : StdSerializer<Instant>(Instant::class.java) {
        override fun serialize(value: Instant, gen: JsonGenerator, provider: SerializationContext) {
            gen.writeString(value.toString())
        }
    }

    object KotlinInstantDeserializer : StdDeserializer<Instant>(Instant::class.java) {
        override fun deserialize(p: JsonParser, ctxt: DeserializationContext): Instant =
            Instant.parse(p.valueAsString)
    }
}
