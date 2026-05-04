import Foundation

struct Avatar: Identifiable, Codable {
    let id: String
    let imagePath: String
    let styleId: String
    let createdAt: Date

    init(id: String = UUID().uuidString, imagePath: String, styleId: String, createdAt: Date = Date()) {
        self.id = id
        self.imagePath = imagePath
        self.styleId = styleId
        self.createdAt = createdAt
    }
}
