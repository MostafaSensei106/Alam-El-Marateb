package com.mostafasensei.alamelmarateb

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.scheduling.annotation.EnableScheduling

@SpringBootApplication
@EnableScheduling
class AlamelmaratebApplication

fun main(args: Array<String>) {
    runApplication<AlamelmaratebApplication>(*args)
}
