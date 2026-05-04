import Foundation
import UIKit
import Combine

final class GenerationViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var isGenerating = false
    @Published private(set) var progress: Double = 0
    @Published private(set) var generatedAvatar: UIImage?
    @Published private(set) var error: Error?
    @Published private(set) var creditsRemaining: Int = 0

    // MARK: - Properties

    let selectedStyle: Style
    let uploadedImage: UIImage

    // MARK: - Private Properties

    private let creditsService = CreditsService.shared
    private let aiService = AIService.shared
    private let storageService = StorageService.shared

    // MARK: - Initialization

    init(style: Style, image: UIImage) {
        self.selectedStyle = style
        self.uploadedImage = image
        self.creditsRemaining = creditsService.currentBalance
    }

    // MARK: - Public Methods

    func generateAvatar() {
        guard creditsService.canAfford(selectedStyle.creditCost) else {
            error = AIServiceError.insufficientCredits
            return
        }

        isGenerating = true
        progress = 0

        // Simulate progress updates
        simulateProgress()

        aiService.generateAvatar(from: uploadedImage, style: selectedStyle) { [weak self] result in
            guard let self = self else { return }

            self.isGenerating = false
            self.progress = 1.0

            switch result {
            case .success(let avatar):
                // Deduct credits
                _ = self.creditsService.deductCredits(self.selectedStyle.creditCost, for: self.selectedStyle.id)

                // Save avatar
                let avatarId = UUID().uuidString
                if let savedPath = self.storageService.saveAvatar(avatar, withId: avatarId) {
                    var savedAvatar = Avatar(id: avatarId, imagePath: savedPath, styleId: self.selectedStyle.id)
                    self.generatedAvatar = avatar
                } else {
                    self.generatedAvatar = avatar
                }

                self.creditsRemaining = self.creditsService.currentBalance

            case .failure(let error):
                self.error = error

                // Refund credits
                self.creditsService.refundCredits(self.selectedStyle.creditCost, description: "Generation failed")
                self.creditsRemaining = self.creditsService.currentBalance
            }
        }
    }

    func cancel() {
        isGenerating = false
        progress = 0
    }

    // MARK: - Private Methods

    private func simulateProgress() {
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self, self.isGenerating else {
                timer.invalidate()
                return
            }

            DispatchQueue.main.async {
                self.progress = min(self.progress + 0.05, 0.9)
            }
        }
        RunLoop.main.add(timer, forMode: .common)
    }
}
