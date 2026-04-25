import Foundation

struct JournalEntry: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    var mood: String
    var moodIntensity: Int
    var createdAt: Date
    var updatedAt: Date
    var tags: [String]
    var isFavorite: Bool

    init(id: UUID = UUID(), title: String, content: String, mood: String, moodIntensity: Int = 3, createdAt: Date = Date(), updatedAt: Date = Date(), tags: [String] = [], isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.content = content
        self.mood = mood
        self.moodIntensity = moodIntensity
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tags = tags
        self.isFavorite = isFavorite
    }
}

struct MoodData {
    let emoji: String
    let name: String
    let color: String

    static let moods: [MoodData] = [
        MoodData(emoji: "😊", name: "Happy", color: "#6EE7B7"),
        MoodData(emoji: "😌", name: "Calm", color: "#A78BFA"),
        MoodData(emoji: "😐", name: "Neutral", color: "#9B8FE8"),
        MoodData(emoji: "😔", name: "Sad", color: "#60A5FA"),
        MoodData(emoji: "😰", name: "Anxious", color: "#FBBF24"),
        MoodData(emoji: "😤", name: "Angry", color: "#F87171"),
    ]
}