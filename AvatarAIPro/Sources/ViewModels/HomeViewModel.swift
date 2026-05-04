import Foundation
import Combine

final class HomeViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var credits: Int = 0
    @Published private(set) var recentAvatars: [Avatar] = []
    @Published private(set) var featuredStyles: [Style] = Style.allStyles

    // MARK: - Private Properties

    private let creditsService = CreditsService.shared
    private let storageService = StorageService.shared

    // MARK: - Initialization

    init() {
        loadData()
    }

    // MARK: - Public Methods

    func loadData() {
        credits = creditsService.currentBalance
        loadRecentAvatars()
    }

    func refresh() {
        loadData()
    }

    // MARK: - Private Methods

    private func loadRecentAvatars() {
        let paths = storageService.getAllAvatarPaths()
        recentAvatars = paths.compactMap { path -> Avatar? in
            let id = (path as NSString).lastPathComponent.replacingOccurrences(of: ".png", with: "")
            return Avatar(id: id, imagePath: path, styleId: "unknown")
        }.sorted { $0.createdAt > $1.createdAt }
            .prefix(10)
            .map { $0 }
    }
}
