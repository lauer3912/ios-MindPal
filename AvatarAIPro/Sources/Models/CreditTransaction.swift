import Foundation

struct CreditTransaction: Identifiable, Codable {
    let id: String
    let amount: Int
    let type: TransactionType
    let timestamp: Date
    let description: String

    enum TransactionType: String, Codable {
        case purchase = "purchase"
        case spend = "spend"
        case reward = "reward"
        case refund = "refund"
    }

    init(
        id: String = UUID().uuidString,
        amount: Int,
        type: TransactionType,
        timestamp: Date = Date(),
        description: String = ""
    ) {
        self.id = id
        self.amount = amount
        self.type = type
        self.timestamp = timestamp
        self.description = description
    }
}
