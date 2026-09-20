package com.mostafasensei.alamelmarateb.modules.sales.application

import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.NotFoundException
import com.mostafasensei.alamelmarateb.modules.product.data.repository.ProductVariantRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.CartItemRepository
import com.mostafasensei.alamelmarateb.modules.sales.data.repository.CartRepository
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.CartItemJpaEntity
import com.mostafasensei.alamelmarateb.modules.sales.domain.entity.CartJpaEntity
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import java.math.BigDecimal
import java.util.UUID

data class CartLineView(
    val variantId: UUID,
    val qty: Int,
    val unitPrice: BigDecimal,
    val lineTotal: BigDecimal,
)

data class CartView(
    val id: UUID?,
    val lines: List<CartLineView>,
    val subtotal: BigDecimal,
)

@Service
class CartService(
    private val cartRepository: CartRepository,
    private val cartItemRepository: CartItemRepository,
    private val variantRepository: ProductVariantRepository,
) {

    @Transactional
    fun getOrCreate(customerId: UUID?, guestKey: String?): CartView {
        if (customerId == null && guestKey.isNullOrBlank()) throw BadRequestException("error.cart.identity_required")
        val cart = (customerId?.let { cartRepository.findByCustomerId(it).orElse(null) }
            ?: guestKey?.let { cartRepository.findByGuestKey(it).orElse(null) })
            ?: cartRepository.save(CartJpaEntity(customerId = customerId, guestKey = guestKey))
        return view(cart)
    }

    @Transactional
    fun add(customerId: UUID?, guestKey: String?, variantId: UUID, qty: Int): CartView {
        if (qty <= 0) throw BadRequestException("error.cart.qty_positive")
        variantRepository.findById(variantId) ?: throw NotFoundException("error.cart.unknown_variant")
        if (customerId == null && guestKey.isNullOrBlank()) throw BadRequestException("error.cart.identity_required")
        val cart = (customerId?.let { cartRepository.findByCustomerId(it).orElse(null) }
            ?: guestKey?.let { cartRepository.findByGuestKey(it).orElse(null) })
            ?: cartRepository.save(CartJpaEntity(customerId = customerId, guestKey = guestKey))
        val existing = cart.items.firstOrNull { it.variantId == variantId }
        if (existing == null) {
            cart.items.add(CartItemJpaEntity(cart = cart, variantId = variantId, qty = qty))
        } else {
            existing.qty += qty
        }
        return view(cartRepository.save(cart))
    }

    @Transactional
    fun setQty(customerId: UUID?, guestKey: String?, variantId: UUID, qty: Int): CartView {
        if (qty < 0) throw BadRequestException("error.cart.qty_negative")
        val cart = load(customerId, guestKey)
        val existing = cart.items.firstOrNull { it.variantId == variantId }
            ?: throw NotFoundException("error.cart.item_not_found")
        if (qty == 0) {
            cart.items.remove(existing)
            cartItemRepository.delete(existing)
        } else {
            existing.qty = qty
        }
        return view(cartRepository.save(cart))
    }

    @Transactional
    fun clear(customerId: UUID?, guestKey: String?): CartView {
        val cart = load(customerId, guestKey)
        cart.items.clear()
        return view(cartRepository.save(cart))
    }

    /** On login: fold guest cart into the customer cart. */
    @Transactional
    fun merge(guestKey: String, customerId: UUID): CartView {
        val guest = cartRepository.findByGuestKey(guestKey).orElseThrow { NotFoundException("error.cart.not_found") }
        val mine = cartRepository.findByCustomerId(customerId)
            .orElseGet { cartRepository.save(CartJpaEntity(customerId = customerId)) }
        guest.items.forEach { g ->
            val existing = mine.items.firstOrNull { it.variantId == g.variantId }
            if (existing == null) {
                mine.items.add(CartItemJpaEntity(cart = mine, variantId = g.variantId, qty = g.qty))
            } else {
                existing.qty += g.qty
            }
        }
        cartRepository.save(mine)
        cartRepository.delete(guest)
        return view(mine)
    }

    private fun load(customerId: UUID?, guestKey: String?): CartJpaEntity =
        (customerId?.let { cartRepository.findByCustomerId(it).orElse(null) }
            ?: guestKey?.let { cartRepository.findByGuestKey(it).orElse(null) })
            ?: throw NotFoundException("error.cart.not_found")

    private fun view(cart: CartJpaEntity): CartView {
        val lines = cart.items.mapNotNull { item ->
            val variant = variantRepository.findById(item.variantId!!) ?: return@mapNotNull null
            val total = variant.sellingPrice.multiply(item.qty.toBigDecimal())
                .setScale(2, java.math.RoundingMode.HALF_EVEN)
            CartLineView(
                variantId = item.variantId!!,
                qty = item.qty,
                unitPrice = variant.sellingPrice,
                lineTotal = total,
            )
        }
        return CartView(
            cart.id, lines,
            lines.fold(BigDecimal.ZERO) { acc, l -> acc.add(l.lineTotal) }
                .setScale(2, java.math.RoundingMode.HALF_EVEN),
        )
    }
}
