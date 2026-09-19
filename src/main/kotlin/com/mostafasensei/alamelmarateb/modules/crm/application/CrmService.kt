package com.mostafasensei.alamelmarateb.modules.crm.application

import com.mostafasensei.alamelmarateb.core.audit.AuditLogService
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.crm.data.repository.CustomerAddressRepository
import com.mostafasensei.alamelmarateb.modules.crm.data.repository.CustomerProfileRepository
import com.mostafasensei.alamelmarateb.modules.crm.data.repository.FavoriteRepository
import com.mostafasensei.alamelmarateb.modules.crm.domain.entity.CustomerAddressJpaEntity
import com.mostafasensei.alamelmarateb.modules.crm.domain.entity.CustomerProfileJpaEntity
import com.mostafasensei.alamelmarateb.modules.crm.domain.entity.FavoriteJpaEntity
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.time.LocalDate
import java.util.UUID

data class ProfileView(
    val userId: UUID,
    val governorate: String?,
    val city: String?,
    val segment: String,
    val referralSource: String?,
    val birthDate: LocalDate?,
)

data class AddressView(
    val id: UUID?,
    val label: String,
    val phone: String,
    val governorate: String,
    val addressText: String,
    val isDefault: Boolean,
)

@Service
class CrmService(
    private val profileRepository: CustomerProfileRepository,
    private val addressRepository: CustomerAddressRepository,
    private val favoriteRepository: FavoriteRepository,
    private val auditLog: AuditLogService,
) {

    @Transactional
    fun profile(userId: UUID, governorate: String?, city: String?, referral: String?, birth: LocalDate?): ProfileView {
        val entity = profileRepository.findByUserId(userId).orElseGet {
            profileRepository.save(CustomerProfileJpaEntity(userId = userId))
        }
        if (governorate != null) entity.governorate = governorate
        if (city != null) entity.city = city
        if (referral != null) entity.referralSource = referral
        if (birth != null) entity.birthDate = birth
        val saved = profileRepository.save(entity)
        return ProfileView(userId, saved.governorate, saved.city, saved.segment, saved.referralSource, saved.birthDate)
    }

    @Transactional(readOnly = true)
    fun addresses(userId: UUID): List<AddressView> =
        addressRepository.findByUserIdOrderByIsDefaultDesc(userId).map { toView(it) }

    @Transactional
    fun addAddress(
        userId: UUID, label: String, phone: String, governorate: String,
        addressText: String, isDefault: Boolean, by: String?,
    ): AddressView {
        if (phone.isBlank() || governorate.isBlank() || addressText.isBlank()) {
            throw BadRequestException("Phone, governorate and address are required")
        }
        if (isDefault) {
            addressRepository.findByUserIdOrderByIsDefaultDesc(userId)
                .filter { it.isDefault }.forEach {
                    it.isDefault = false
                    addressRepository.save(it)
                }
        }
        val saved = addressRepository.save(
            CustomerAddressJpaEntity(
                userId = userId, label = label.ifBlank { "home" }, phone = phone,
                governorate = governorate, addressText = addressText, isDefault = isDefault,
            ),
        )
        auditLog.record("ADD_ADDRESS", "customer", userId, null, by, null)
        return toView(saved)
    }

    @Transactional
    fun removeAddress(userId: UUID, addressId: UUID) {
        val entity = addressRepository.findById(addressId).orElseThrow { NotFoundException("Address not found") }
        if (entity.userId != userId) throw NotFoundException("Address not found")
        addressRepository.delete(entity)
    }

    @Transactional(readOnly = true)
    fun favorites(userId: UUID): List<UUID> =
        favoriteRepository.findByUserId(userId).mapNotNull { it.productId }

    @Transactional
    fun addFavorite(userId: UUID, productId: UUID) {
        if (favoriteRepository.existsByUserIdAndProductId(userId, productId)) {
            throw ConflictException("Already in favorites")
        }
        favoriteRepository.save(FavoriteJpaEntity(userId = userId, productId = productId))
    }

    @Transactional
    fun removeFavorite(userId: UUID, productId: UUID) {
        if (favoriteRepository.deleteByUserIdAndProductId(userId, productId) == 0L) {
            throw NotFoundException("Favorite not found")
        }
    }

    private fun toView(e: CustomerAddressJpaEntity) = AddressView(
        e.id, e.label, e.phone, e.governorate, e.addressText, e.isDefault,
    )
}
