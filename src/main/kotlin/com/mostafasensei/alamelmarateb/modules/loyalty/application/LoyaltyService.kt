package com.mostafasensei.alamelmarateb.modules.loyalty.application

import com.mostafasensei.alamelmarateb.core.events.OrderDeliveredEvent
import com.mostafasensei.alamelmarateb.core.exceptions.BadRequestException
import com.mostafasensei.alamelmarateb.core.exceptions.ConflictException
import com.mostafasensei.alamelmarateb.modules.loyalty.data.repository.LoyaltyAccountRepository
import com.mostafasensei.alamelmarateb.modules.loyalty.data.repository.LoyaltyLedgerRepository
import com.mostafasensei.alamelmarateb.modules.loyalty.domain.entity.LoyaltyAccountJpaEntity
import com.mostafasensei.alamelmarateb.modules.loyalty.domain.entity.LoyaltyLedgerJpaEntity
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.transaction.event.TransactionPhase
import org.springframework.transaction.event.TransactionalEventListener
import java.math.BigDecimal
import java.math.RoundingMode
import java.util.UUID

data class LoyaltyBalance(val points: Int, val lifetimeEarned: Int)

data class LoyaltyEntry(
    val orderId: UUID?,
    val delta: Int,
    val reason: String,
    val balanceAfter: Int,
    val at: String?,
)

/**
 * Loyalty points (sales nice-to-have).
 * - Earn: 1 pt per `earnPerEgp` EGP of delivered orders (event-driven, AFTER_COMMIT).
 * - Redeem: points convert at `egpPerPoint`, applied as order discount at place-order.
 * - Earn is idempotent per order (ledger guard); delivery events fire only on
 *   real status transitions, never on replayed reads.
 */
@Service
class LoyaltyService(
    private val accountRepository: LoyaltyAccountRepository,
    private val ledgerRepository: LoyaltyLedgerRepository,
    @Value("\${app.loyalty.enabled:true}") private val enabled: Boolean,
    @Value("\${app.loyalty.earn-per-egp:10}") private val earnPerEgp: Int,
    @Value("\${app.loyalty.egp-per-point:1}") private val egpPerPoint: Int,
) {

    @TransactionalEventListener(phase = TransactionPhase.AFTER_COMMIT, fallbackExecution = true)
    fun onOrderDelivered(event: OrderDeliveredEvent) {
        if (!enabled) return
        val userId = event.customerId ?: return
        val points = event.grandTotal.divide(earnPerEgp.toBigDecimal(), 0, RoundingMode.DOWN).toInt()
        if (points <= 0) return
        if (ledgerRepository.existsByOrderIdAndReason(event.orderId, "EARN")) return
        val account = accountOf(userId)
        account.points += points
        account.lifetimeEarned += points
        accountRepository.save(account)
        ledgerRepository.save(
            LoyaltyLedgerJpaEntity(
                userId = userId, orderId = event.orderId, delta = points,
                reason = "EARN", balanceAfter = account.points,
            ),
        )
    }

    /** Validates + prices a redemption. The actual deduction happens post-finalize. */
    @Transactional(readOnly = true)
    fun quoteRedemption(customerId: UUID, points: Int): BigDecimal {
        if (!enabled || points <= 0) throw BadRequestException("error.loyalty.amount_positive")
        val account = accountRepository.findById(customerId).orElse(null)
        val available = account?.points ?: 0
        if (available < points) throw ConflictException("error.loyalty.insufficient", listOf(available))
        return (points * egpPerPoint).toBigDecimal().setScale(2, RoundingMode.HALF_EVEN)
    }

    @Transactional
    fun deduct(customerId: UUID, orderId: UUID, points: Int): BigDecimal {
        val discount = quoteRedemption(customerId, points)
        val account = accountOf(customerId)
        if (account.points < points) throw ConflictException("error.loyalty.insufficient", listOf(account.points))
        account.points -= points
        accountRepository.save(account)
        ledgerRepository.save(
            LoyaltyLedgerJpaEntity(
                userId = customerId, orderId = orderId, delta = -points,
                reason = "REDEEM", balanceAfter = account.points,
            ),
        )
        return discount
    }

    /**
     * Checkout redemption: charges whole points for at most [maxDiscount],
     * so points are never over-spent when the discount is capped by the total.
     */
    @Transactional
    fun spend(customerId: UUID, orderId: UUID, requestedPoints: Int, maxDiscount: BigDecimal): Pair<Int, BigDecimal> {
        if (!enabled || requestedPoints <= 0) throw BadRequestException("error.loyalty.amount_positive")
        val account = accountOf(customerId)
        val affordablePoints = (maxDiscount.divide(egpPerPoint.toBigDecimal(), 0, RoundingMode.DOWN)).toInt()
        val points = minOf(requestedPoints, account.points, affordablePoints)
        if (points <= 0) throw ConflictException("error.loyalty.insufficient", listOf(account.points))
        account.points -= points
        accountRepository.save(account)
        val discount = (points * egpPerPoint).toBigDecimal().setScale(2, RoundingMode.HALF_EVEN)
        ledgerRepository.save(
            LoyaltyLedgerJpaEntity(
                userId = customerId, orderId = orderId, delta = -points,
                reason = "REDEEM", balanceAfter = account.points,
            ),
        )
        return points to discount
    }

    @Transactional(readOnly = true)
    fun balance(userId: UUID): LoyaltyBalance {
        val account = accountRepository.findById(userId).orElse(null)
        return LoyaltyBalance(account?.points ?: 0, account?.lifetimeEarned ?: 0)
    }

    @Transactional(readOnly = true)
    fun ledger(userId: UUID): List<LoyaltyEntry> =
        ledgerRepository.findByUserIdOrderByCreatedAtDesc(userId).map {
            LoyaltyEntry(it.orderId, it.delta, it.reason, it.balanceAfter, it.createdAt?.toString())
        }

    private fun accountOf(userId: UUID): LoyaltyAccountJpaEntity =
        accountRepository.findById(userId).orElseGet {
            accountRepository.save(LoyaltyAccountJpaEntity(userId = userId))
        }
}
