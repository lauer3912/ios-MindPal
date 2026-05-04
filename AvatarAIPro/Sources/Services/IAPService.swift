import Foundation
import StoreKit

final class IAPService: NSObject {

    static let shared = IAPService()

    // MARK: - Product IDs

    enum ProductID: String, CaseIterable {
        case credits50 = "com.ggsheng.AvatarAIPro.credits50"
        case credits200 = "com.ggsheng.AvatarAIPro.credits200"
        case credits500 = "com.ggsheng.AvatarAIPro.credits500"
        case subscriptionMonthly = "com.ggsheng.AvatarAIPro.subscription.monthly"

        var credits: Int {
            switch self {
            case .credits50: return 50
            case .credits200: return 200
            case .credits500: return 500
            case .subscriptionMonthly: return 0 // Unlimited
            }
        }

        var price: String {
            switch self {
            case .credits50: return "$0.99"
            case .credits200: return "$3.99"
            case .credits500: return "$6.99"
            case .subscriptionMonthly: return "$9.99/month"
            }
        }
    }

    // MARK: - Properties

    private var products: [ProductID: Product] = [:]
    private var purchaseCompletion: ((Result<ProductID, Error>) -> Void)?

    // MARK: - Public Methods

    func loadProducts() async {
        do {
            let productIds = Set(ProductID.allCases.map { $0.rawValue })
            let storeProducts = try await Product.products(for: productIds)

            for product in storeProducts {
                if let productId = ProductID(rawValue: product.id) {
                    products[productId] = product
                }
            }
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func purchase(_ productId: ProductID, completion: @escaping (Result<ProductID, Error>) -> Void) {
        purchaseCompletion = completion

        guard let product = products[productId] else {
            completion(.failure(IAPError.productNotFound))
            return
        }

        Task {
            do {
                let result = try await product.purchase()

                switch result {
                case .success(let verification):
                    let transaction = try checkVerified(verification)

                    await updateTransactionStatus(transaction)
                    await transaction.finish()

                    DispatchQueue.main.async {
                        completion(.success(productId))
                    }

                case .userCancelled:
                    DispatchQueue.main.async {
                        completion(.failure(IAPError.userCancelled))
                    }

                case .pending:
                    DispatchQueue.main.async {
                        completion(.failure(IAPError.pending))
                    }

                @unknown default:
                    DispatchQueue.main.async {
                        completion(.failure(IAPError.unknown))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func restorePurchases(completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await AppStore.sync()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    // MARK: - Private Methods

    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw IAPError.verificationFailed
        case .verified(let safe):
            return safe
        }
    }

    private func updateTransactionStatus(_ transaction: Transaction) async {
        // Update user entitlements here
    }

    // MARK: - Errors

    enum IAPError: LocalizedError {
        case productNotFound
        case userCancelled
        case pending
        case verificationFailed
        case unknown

        var errorDescription: String? {
            switch self {
            case .productNotFound: return "Product not found"
            case .userCancelled: return "Purchase cancelled"
            case .pending: return "Purchase is pending"
            case .verificationFailed: return "Purchase verification failed"
            case .unknown: return "Unknown error occurred"
            }
        }
    }
}
