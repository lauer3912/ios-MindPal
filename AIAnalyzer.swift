import Foundation

class AIAnalyzer {
    static let shared = AIAnalyzer()

    private init() {}

    // Analyze entry content and generate reflection prompt
    func generateReflectionPrompt(for entry: JournalEntry) -> String? {
        let content = entry.content.lowercased()
        let mood = entry.mood

        // Simple keyword-based analysis
        if content.contains("work") || content.contains("job") || content.contains("career") {
            if mood == "😰" {
                return "What specific aspect of work made you feel anxious? Is there something you can control about this situation?"
            }
        }

        if content.contains("family") || content.contains("mom") || content.contains("dad") || content.contains("parent") {
            if mood == "😔" {
                return "Family can bring up complex emotions. What would help you feel more connected to your loved ones right now?"
            }
        }

        if content.contains("sleep") || content.contains("tired") || content.contains("exhausted") {
            return "How can you prioritize better rest? Even small changes to your sleep routine can make a difference."
        }

        if content.contains("happy") || content.contains("grateful") || content.contains("thankful") {
            return "What made today special? Try to notice these positive moments more often - they compound over time."
        }

        // Default prompts based on mood
        switch mood {
        case "😊": return "What's one thing that contributed to your happiness today?"
        case "😌": return "What activity or thought helped you feel calm?"
        case "😐": return "Is there something you're avoiding thinking about?"
        case "😔": return "Remember: it's okay to feel sad. What small thing might lift your spirits?"
        case "😰": return "Take a deep breath. What's the worst that could happen? How likely is that?"
        case "😤": return "What's underneath your anger? Often anger masks hurt or frustration."
        default: return "What would you tell a friend in the same situation?"
        }
    }

    // Generate weekly summary
    func generateWeeklySummary(entries: [JournalEntry]) -> String {
        let moodCounts = entries.reduce(into: [:]) { counts, entry in
            counts[entry.mood, default: 0] += 1
        }

        let totalEntries = entries.count
        guard totalEntries > 0 else {
            return "Start journaling to receive your first AI insight!"
        }

        let dominantMood = moodCounts.max { $0.value < $1.value }?.key ?? "😐"

        var summary = "📊 Your Week in Review\n\n"
        summary += "You wrote \(totalEntries) entries this week.\n"
        summary += "Your dominant mood was \(dominantMood).\n\n"

        if let happyCount = moodCounts["😊"], happyCount > totalEntries / 2 {
            summary += "🌟 You've had many positive moments! Keep building on this energy.\n"
        }

        if let anxiousCount = moodCounts["😰"], anxiousCount > totalEntries / 3 {
            summary += "💙 You've faced some anxiety this week. Remember to practice self-care.\n"
        }

        let streak = DataStore.shared.currentStreak
        if streak >= 3 {
            summary += "🔥 \(streak)-day journaling streak! Consistency is building your self-awareness.\n"
        }

        return summary
    }

    // Detect patterns
    func detectPatterns(entries: [JournalEntry]) -> [String] {
        var patterns: [String] = []

        let calendar = Calendar.current
        var moodByHour: [Int: [String]] = [:]

        for entry in entries {
            let hour = calendar.component(.hour, from: entry.createdAt)
            moodByHour[hour, default: []].append(entry.mood)
        }

        // Find best writing time
        if let bestHour = moodByHour.max(by: { $0.value.count < $1.value.count })?.key {
            let hourStr = bestHour > 12 ? "\(bestHour - 12) PM" : "\(bestHour) AM"
            patterns.append("⏰ You write best at \(hourStr)")
        }

        // Mood pattern by day of week
        var moodByDay: [Int: [String]] = [:]
        for entry in entries {
            let day = calendar.component(.weekday, from: entry.createdAt)
            moodByDay[day, default: []].append(entry.mood)
        }

        if let (sadDay, _) = moodByDay.first(where: { $0.value.contains("😔") || $0.value.contains("😰") }) {
            let dayNames = ["", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            patterns.append("📅 You tend to feel more anxious on \(dayNames[sadDay])s")
        }

        return patterns
    }
}