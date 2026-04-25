import Foundation

class DataStore {
    static let shared = DataStore()
    private let entriesKey = "journal_entries"
    private let streaksKey = "current_streak"
    
    private init() {}

    var entries: [JournalEntry] {
        get {
            guard let data = UserDefaults.standard.data(forKey: entriesKey),
                  let entries = try? JSONDecoder().decode([JournalEntry].self, from: data) else {
                return []
            }
            return entries.sorted { $0.createdAt > $1.createdAt }
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: entriesKey)
            }
        }
    }

    func addEntry(_ entry: JournalEntry) {
        var current = entries
        current.insert(entry, at: 0)
        entries = current
        updateStreak()
    }

    func updateEntry(_ entry: JournalEntry) {
        var current = entries
        if let index = current.firstIndex(where: { $0.id == entry.id }) {
            var updated = entry
            updated.updatedAt = Date()
            current[index] = updated
            entries = current
        }
    }

    func deleteEntry(_ entry: JournalEntry) {
        var current = entries
        current.removeAll { $0.id == entry.id }
        entries = current
    }

    func toggleFavorite(_ entry: JournalEntry) {
        var updated = entry
        updated.isFavorite.toggle()
        updateEntry(updated)
    }

    func searchEntries(_ query: String) -> [JournalEntry] {
        return entries.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            $0.content.localizedCaseInsensitiveContains(query)
        }
    }

    var currentStreak: Int {
        get { UserDefaults.standard.integer(forKey: streaksKey) }
        set { UserDefaults.standard.set(newValue, forKey: streaksKey) }
    }

    private func updateStreak() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastEntry = entries.first?.createdAt {
            let lastDate = calendar.startOfDay(for: lastEntry)
            let daysDiff = calendar.dateComponents([.day], from: lastDate, to: today).day ?? 0
            
            if daysDiff == 0 {
                // Same day
            } else if daysDiff == 1 {
                currentStreak += 1
            } else {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }
    }

    func moodStats(for period: Int = 7) -> [String: Int] {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -period, to: Date()) ?? Date()
        
        var stats: [String: Int] = [:]
        for entry in entries where entry.createdAt >= startDate {
            stats[entry.mood, default: 0] += 1
        }
        return stats
    }
}