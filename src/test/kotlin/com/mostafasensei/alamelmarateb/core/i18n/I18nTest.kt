package com.mostafasensei.alamelmarateb.core.i18n

import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.i18n.LocaleContextHolder
import java.util.Locale
import kotlin.test.assertEquals

@SpringBootTest
class I18nTest {

    @Autowired
    private lateinit var messages: MessageService

    @Test
    fun `default locale is Arabic`() {
        LocaleContextHolder.setLocale(Locale("fr"))
        try {
            assertEquals("تمت العملية بنجاح", messages.get("success.operation"))
        } finally {
            LocaleContextHolder.resetLocaleContext()
        }
    }

    @Test
    fun `english header resolves English`() {
        LocaleContextHolder.setLocale(Locale("en"))
        try {
            assertEquals("Operation Successful", messages.get("success.operation"))
            assertEquals("Invalid phone or password", messages.get("auth.invalid_credentials"))
        } finally {
            LocaleContextHolder.resetLocaleContext()
        }
    }

    @Test
    fun `unknown code falls back to code`() {
        assertEquals("no.such.key", messages.get("no.such.key"))
    }
}
