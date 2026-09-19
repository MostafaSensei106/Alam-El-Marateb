package com.mostafasensei.alamelmarateb.core.exceptions

class NotFoundException(message: String) : RuntimeException(message)

class ConflictException(message: String) : RuntimeException(message)

class BadRequestException(message: String, val errors: List<String>? = null) : RuntimeException(message)
