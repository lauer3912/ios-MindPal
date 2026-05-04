import Foundation
import Combine
import StoreKit

final class StoreViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var credits: Int = 0
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published private(set) var purchaseSuccess = false

    // MARK: - Product Packages

    let creditPackages: [(id: IAPService.ProductID, credits: Int, price: String, description: String)] = [
        (.credits50, 50, "$0.99", "50 Credits"),
        (.credits200, 200, "$3.99", "200 Credits (Save 33%)"),
        (.credits500, 500, "$6.99", "500 Credits (Best Value)")
    ]

    // MARK: - Private Properties

    private let creditsService = CreditsService.shared
    private let iapService = IAPService.shared

    // MARK: - Initialization

    init() {
        credits = creditsService.currentBalance
        loadProducts()
    }

    // MARK: - Public Methods

    func loadProducts() {
        Task { @MainActor in
            await iapService.loadProducts()
        }
    }

    func purchaseCredits(_ packageId: IAPService.ProductID) {
        isLoading = true
        errorMessage = nil
        purchaseSuccess = false

        iapService.purchase(packageId) { [weak self] result in
            guard let self = self else { return }

            self.isLoading = false

            switch result {
            case .success(let productId):
                // Add credits based on product
                if productId.credits > 0 {
                    self.creditsService.addCredits(productId.credits, description: "Purchased \(productId.credits) credits")
                }
                self.credits = self.creditsService.currentBalance
                self.purchaseSuccess = true

            case .failure(let error):
                if case IAPService.IAPError.userCancelled = error {
                    // Don't show error for user cancellation
                } else {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    func restorePurchases() {
        isLoading = true
        errorMessage = nil

        iapService.restorePurchases { [weak self] result in
            guard let self = self else { return }

            self.isLoading = false

            switch result {
            case .success:
                self.credits = self.creditsService.currentBalance
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func refresh() {
        credits = creditsService.currentBalance
    }
}
