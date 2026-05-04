import Foundation

struct Style: Identifiable, Codable {
    let id: String
    let name: String
    let creditCost: Int
    let description: String
    let previewImageName: String
    let category: StyleCategory

    enum StyleCategory: String, Codable, CaseIterable {
        case all = "All"
        case anime = "Anime"
        case game3d = "3D Game"
        case cyberpunk = "Cyberpunk"
        case professional = "Professional"
        case fantasy = "Fantasy"
    }

    static let allStyles: [Style] = [
        Style(id: "anime", name: "Anime", creditCost: 10, description: "Japanese anime style", previewImageName: "style_anime", category: .anime),
        Style(id: "cyberpunk", name: "Cyberpunk", creditCost: 10, description: "Neon-lit futuristic", previewImageName: "style_cyberpunk", category: .cyberpunk),
        Style(id: "3d_game", name: "3D Game", creditCost: 15, description: "Video game character", previewImageName: "style_3dgame", category: .game3d),
        Style(id: "professional", name: "Professional", creditCost: 15, description: "Business headshot", previewImageName: "style_professional", category: .professional),
        Style(id: "fantasy", name: "Fantasy", creditCost: 15, description: "Medieval warrior", previewImageName: "style_fantasy", category: .fantasy),
        Style(id: "sci-fi", name: "Sci-Fi", creditCost: 10, description: "Space explorer", previewImageName: "style_scifi", category: .cyberpunk),
        Style(id: "retro", name: "Retro", creditCost: 10, description: "80s vaporwave", previewImageName: "style_retro", category: .anime),
        Style(id: "portrait", name: "Portrait", creditCost: 20, description: "Realistic portrait", previewImageName: "style_portrait", category: .professional),
        Style(id: "pixar", name: "Pixar", creditCost: 15, description: "3D animated movie style", previewImageName: "style_pixar", category: .game3d),
        Style(id: "gothic", name: "Gothic", creditCost: 10, description: "Dark romantic", previewImageName: "style_gothic", category: .fantasy)
    ]
}
