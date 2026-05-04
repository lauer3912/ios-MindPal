import Foundation
import Combine

final class ProfileViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var credits: Int = 0
    @Published private(set) var totalAvatarsGenerated: Int = 0
    @Published private(set) var stylesUsed: Int = 0
    @Published private(set) var memberSince: Date = Date()
    @Published private(set) var isPremium: Bool = false

    // MARK: - Private Properties

    private let creditsService = CreditsService.shared
    private let storageService = StorageService.shared

    // MARK: - Initialization

    init() {
        loadStats()
    }

    // MARK: - Public Methods

    func loadStats() {
        credits = creditsService.currentBalance

        let avatarPaths = storageService.getAllAvatarPaths()
        totalAvatarsGenerated = avatarPaths.count

        // Count unique styles used
        let uniqueStyles = Set(avatarPaths.map { path -> String in
            // Extract style from filename if possible
            return "unknown"
        })
        stylesUsed = uniqueStyles.count

        // Get account creation date from UserDefaults
        if let accountDate = UserDefaults.standard.object(forKey: "account_creation_date") as? Date {
            memberSince = accountDate
        } else {
            memberSince = Date()
            UserDefaults.standard.set(memberSince, forKey: "account_creation_date")
        }
    }

    func refresh() {
        loadStats()
    }

    func deleteAllData() {
        // Clear all avatars
        let avatarPaths = storageService.getAllAvatarPaths()
        for path in avatarPaths {
            let id = (path as NSString).lastPathComponent.replacingOccurrences(of: ".png", with: "")
            storageService.deleteAvatar(withId: id)
        }

        // Reset credits
        UserDefaults.standard.set(5, forKey: "credits_balance")

        loadStats()
    }
}
