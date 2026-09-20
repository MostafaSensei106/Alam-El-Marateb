package com.mostafasensei.alamelmarateb.core.config

import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Configuration
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer
import java.nio.file.Paths

/** Serves local uploads (see StorageService) under the uploads path. */
@Configuration
class UploadsWebConfig(
    @Value("\${app.storage.dir:./data/uploads}") private val baseDir: String,
) : WebMvcConfigurer {

    override fun addResourceHandlers(registry: ResourceHandlerRegistry) {
        val location = Paths.get(baseDir).toAbsolutePath().toUri().toString()
        registry.addResourceHandler("/uploads/**").addResourceLocations(location)
    }
}
