import Foundation

final class CreditsService {

    static let shared = CreditsService()

    private let userDefaults = UserDefaults.standard
    private let creditsKey = "credits_balance"
    private let transactionsKey = "credit_transactions"

    private init() {
        // Initialize with free credits if not set
        if userDefaults.object(forKey: creditsKey) == nil {
            userDefaults.set(5, forKey: creditsKey) // 5 free credits for new users
        }
    }

    // MARK: - Public Properties

    var currentBalance: Int {
        return userDefaults.integer(forKey: creditsKey)
    }

    // MARK: - Public Methods

    func deductCredits(_ amount: Int, for styleId: String) -> Bool {
        guard currentBalance >= amount else { return false }

        let newBalance = currentBalance - amount
        userDefaults.set(newBalance, forKey: creditsKey)

        let transaction = CreditTransaction(
            amount: amount,
            type: .spend,
            description: "Generated avatar with style: \(styleId)"
        )
        saveTransaction(transaction)

        return true
    }

    func addCredits(_ amount: Int, description: String = "") {
        let newBalance = currentBalance + amount
        userDefaults.set(newBalance, forKey: creditsKey)

        let transaction = CreditTransaction(
            amount: amount,
            type: .purchase,
            description: description.isEmpty ? "Purchased \(amount) credits" : description
        )
        saveTransaction(transaction)
    }

    func refundCredits(_ amount: Int, description: String = "Refund") {
        addCredits(amount, description: description)

        let transaction = CreditTransaction(
            amount: amount,
            type: .refund,
            description: description.isEmpty ? "Refunded \(amount) credits" : description
        )
        saveTransaction(transaction)
    }

    func canAfford(_ amount: Int) -> Bool {
        return currentBalance >= amount
    }

    func getTransactions() -> [CreditTransaction] {
        guard let data = userDefaults.data(forKey: transactionsKey),
              let transactions = try? JSONDecoder().decode([CreditTransaction].self, from: data) else {
            return []
        }
        return transactions.sorted { $0.timestamp > $1.timestamp }
    }

    // MARK: - Private Methods

    private func saveTransaction(_ transaction: CreditTransaction) {
        var transactions = getTransactions()
        transactions.append(transaction)

        if let data = try? JSONEncoder().encode(transactions) {
            userDefaults.set(data, forKey: transactionsKey)
        }
    }
}
