import Foundation
import UIKit

final class StorageService {

    static let shared = StorageService()

    private let fileManager = FileManager.default
    private let documentsDirectory: URL

    private init() {
        documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    // MARK: - Public Methods

    func saveAvatar(_ image: UIImage, withId id: String) -> String? {
        let avatarsDirectory = documentsDirectory.appendingPathComponent("Avatars", isDirectory: true)

        do {
            try fileManager.createDirectory(at: avatarsDirectory, withIntermediateDirectories: true)

            let imagePath = avatarsDirectory.appendingPathComponent("\(id).png")

            guard let data = image.pngData() else { return nil }

            try data.write(to: imagePath)

            return imagePath.path
        } catch {
            print("Failed to save avatar: \(error)")
            return nil
        }
    }

    func loadAvatar(withId id: String) -> UIImage? {
        let imagePath = documentsDirectory
            .appendingPathComponent("Avatars", isDirectory: true)
            .appendingPathComponent("\(id).png")

        guard fileManager.fileExists(atPath: imagePath.path),
              let data = try? Data(contentsOf: imagePath),
              let image = UIImage(data: data) else {
            return nil
        }

        return image
    }

    func deleteAvatar(withId id: String) {
        let imagePath = documentsDirectory
            .appendingPathComponent("Avatars", isDirectory: true)
            .appendingPathComponent("\(id).png")

        try? fileManager.removeItem(at: imagePath)
    }

    func getAllAvatarPaths() -> [String] {
        let avatarsDirectory = documentsDirectory.appendingPathComponent("Avatars", isDirectory: true)

        guard let files = try? fileManager.contentsOfDirectory(atPath: avatarsDirectory.path) else {
            return []
        }

        return files.filter { $0.hasSuffix(".png") }
    }

    func getAvatarsDirectory() -> URL {
        return documentsDirectory.appendingPathComponent("Avatars", isDirectory: true)
    }

    // MARK: - UserDefaults Helpers

    func saveObject<T: Encodable>(_ object: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(object) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func loadObject<T: Decodable>(forKey key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key),
              let object = try? JSONDecoder().decode(T.self, from: data) else {
            return nil
        }
        return object
    }
}
