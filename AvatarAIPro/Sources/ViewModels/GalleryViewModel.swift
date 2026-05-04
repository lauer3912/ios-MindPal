import Foundation
import UIKit
import Combine

final class GalleryViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published private(set) var avatars: [Avatar] = []
    @Published private(set) var isLoading = false

    // MARK: - Private Properties

    private let storageService = StorageService.shared

    // MARK: - Initialization

    init() {
        loadAvatars()
    }

    // MARK: - Public Methods

    func loadAvatars() {
        isLoading = true

        let paths = storageService.getAllAvatarPaths()
        avatars = paths.compactMap { path -> Avatar? in
            let id = (path as NSString).lastPathComponent.replacingOccurrences(of: ".png", with: "")
            return Avatar(id: id, imagePath: path, styleId: "unknown")
        }.sorted { $0.createdAt > $1.createdAt }

        isLoading = false
    }

    func deleteAvatar(_ avatar: Avatar) {
        storageService.deleteAvatar(withId: avatar.id)
        avatars.removeAll { $0.id == avatar.id }
    }

    func getImage(for avatar: Avatar) -> UIImage? {
        return storageService.loadAvatar(withId: avatar.id)
    }

    func refresh() {
        loadAvatars()
    }
}
