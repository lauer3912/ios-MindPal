import Foundation

class InsightsService {
    static let shared = InsightsService()

    private let taskService = TaskService.shared
    private let goalService = GoalService.shared

    private init() {}

    // MARK: - Weekly Summary

    struct WeeklySummary {
        let tasksCompleted: Int
        let focusHours: Double
        let productivityScore: Int
        let bestDay: String
        let completionRate: Double
        let totalTasks: Int
    }

    func getWeeklySummary() -> WeeklySummary {
        let calendar = Calendar.current
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        let today = Date()

        var tasksCompleted = 0
        var totalTasks = 0
        var focusMinutes = 0
        var dayScores: [String: Int] = [:]

        // Iterate through each day of the week
        var currentDate = weekStart
        while currentDate <= today {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "EEEE"
            let dayName = dayFormatter.string(from: currentDate)

            let dayCompleted = taskService.getCompletedTasksCount(for: currentDate)
            tasksCompleted += dayCompleted

            let dayTotal = taskService.getTasksForDate(currentDate).count
            totalTasks += dayTotal

            let dayScore = dayTotal > 0 ? Int(Double(dayCompleted) / Double(dayTotal) * 100) : 0
            dayScores[dayName] = dayScore

            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        // Find best day
        let bestDay = dayScores.max(by: { $0.value < $1.value })?.key ?? "N/A"

        // Calculate completion rate
        let completionRate = totalTasks > 0 ? Double(tasksCompleted) / Double(totalTasks) : 0

        // Calculate productivity score (0-100)
        let productivityScore = min(100, Int(completionRate * 100))

        // Focus hours (estimate based on completed tasks)
        let focusHours = Double(focusMinutes) / 60.0

        return WeeklySummary(
            tasksCompleted: tasksCompleted,
            focusHours: focusHours,
            productivityScore: productivityScore,
            bestDay: bestDay,
            completionRate: completionRate,
            totalTasks: totalTasks
        )
    }

    // MARK: - Energy Trends

    struct EnergyTrend {
        let date: Date
        let level: Int
    }

    func getEnergyTrends(forDays days: Int = 7) -> [EnergyTrend] {
        var trends: [EnergyTrend] = []
        let calendar = Calendar.current
        var currentDate = calendar.startOfDay(for: Date())

        for _ in 0..<days {
            // In a real app, this would come from user input or device data
            // For now, use a simulated pattern
            let hour = calendar.component(.hour, from: Date())
            let baseLevel = 70
            let variation = Int.random(in: -20...20)
            let level = max(0, min(100, baseLevel + variation))

            trends.append(EnergyTrend(date: currentDate, level: level))
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }

        return trends.reversed()
    }

    // MARK: - Focus Time Stats

    struct FocusStats {
        let todayMinutes: Int
        let weekMinutes: Int
        let avgDailyMinutes: Double
        let peakHour: Int
        let streak: Int
    }

    func getFocusStats() -> FocusStats {
        let calendar = Calendar.current
        let today = Date()
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!

        var weekMinutes = 0
        var currentDate = weekStart

        while currentDate <= today {
            // In real app, calculate from task blocks
            let dayMinutes = taskService.getTotalFocusMinutes(for: currentDate)
            weekMinutes += dayMinutes
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        let todayMinutes = taskService.getTotalFocusMinutes(for: today)
        let daysInWeek = calendar.dateComponents([.day], from: weekStart, to: today).day ?? 1
        let avgDaily = daysInWeek > 0 ? Double(weekMinutes) / Double(daysInWeek) : 0

        let streak = taskService.getStreak()

        // Peak hour (simulated)
        let peakHour = 10

        return FocusStats(
            todayMinutes: todayMinutes,
            weekMinutes: weekMinutes,
            avgDailyMinutes: avgDaily,
            peakHour: peakHour,
            streak: streak
        )
    }

    // MARK: - Task Completion Rate

    func getCompletionRate(forDays days: Int = 7) -> Double {
        let calendar = Calendar.current
        var totalTasks = 0
        var completedTasks = 0
        var currentDate = calendar.startOfDay(for: Date())

        for _ in 0..<days {
            let dayTotal = taskService.getTasksForDate(currentDate).count
            let dayCompleted = taskService.getCompletedTasksCount(for: currentDate)

            totalTasks += dayTotal
            completedTasks += dayCompleted

            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }

        return totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0
    }

    // MARK: - AI Insights

    struct AIInsight {
        let title: String
        let description: String
        let type: InsightType
    }

    enum InsightType {
        case productivity
        case energy
        case goal
        case suggestion
    }

    func generateAIInsights() -> [AIInsight] {
        var insights: [AIInsight] = []
        let summary = getWeeklySummary()
        let focusStats = getFocusStats()
        let completionRate = getCompletionRate()

        // Energy insight
        if summary.completionRate < 0.6 {
            insights.append(AIInsight(
                title: "Energy Optimization",
                description: "Your completion rate is \(Int(summary.completionRate * 100))%. Try scheduling high-priority tasks during your peak energy hours (9-11 AM).",
                type: .energy
            ))
        }

        // Focus time insight
        if focusStats.avgDailyMinutes < 120 {
            insights.append(AIInsight(
                title: "Focus Time Opportunity",
                description: "You're averaging \(Int(focusStats.avgDailyMinutes)) minutes of focus time daily. Aim for at least 2 hours for optimal productivity.",
                type: .productivity
            ))
        }

        // Streak encouragement
        if focusStats.streak > 3 {
            insights.append(AIInsight(
                title: "🔥 \(focusStats.streak) Day Streak!",
                description: "You're on fire! Keep the momentum going. Consistency is key to building productive habits.",
                type: .productivity
            ))
        }

        // Goal alignment
        let activeGoals = goalService.getActiveGoals()
        if !activeGoals.isEmpty {
            insights.append(AIInsight(
                title: "Goal Progress",
                description: "You have \(activeGoals.count) active goals. \(activeGoals.filter { $0.progress > 0.5 }.count) are over 50% complete!",
                type: .goal
            ))
        }

        // Scheduling suggestion
        if summary.tasksCompleted < 10 {
            insights.append(AIInsight(
                title: "Scheduling Tip",
                description: "Consider breaking larger tasks into smaller 25-30 minute blocks. This makes them easier to complete and provides natural break points.",
                type: .suggestion
            ))
        }

        return insights
    }

    // MARK: - Productivity Chart Data

    struct ChartDataPoint {
        let label: String
        let value: Double
    }

    func getProductivityChartData(forDays days: Int = 7) -> [ChartDataPoint] {
        var data: [ChartDataPoint] = []
        let calendar = Calendar.current
        var currentDate = calendar.startOfDay(for: Date())

        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE"

        for _ in 0..<days {
            let dayName = dayFormatter.string(from: currentDate)
            let completed = taskService.getCompletedTasksCount(for: currentDate)
            let total = taskService.getTasksForDate(currentDate).count
            let rate = total > 0 ? Double(completed) / Double(total) : 0

            data.append(ChartDataPoint(label: dayName, value: rate))
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }

        return data.reversed()
    }

    // MARK: - Achievement Badges

    struct Achievement {
        let id: String
        let name: String
        let description: String
        let iconName: String
        let unlocked: Bool
        let unlockedDate: Date?
    }

    func getAchievements() -> [Achievement] {
        var achievements: [Achievement] = []
        let focusStats = getFocusStats()
        let summary = getWeeklySummary()
        let completionRate = getCompletionRate()

        // First task completed
        achievements.append(Achievement(
            id: "first-task",
            name: "Getting Started",
            description: "Complete your first task",
            iconName: "star.fill",
            unlocked: summary.tasksCompleted >= 1,
            unlockedDate: summary.tasksCompleted >= 1 ? Date() : nil
        ))

        // 7 day streak
        achievements.append(Achievement(
            id: "week-streak",
            name: "Week Warrior",
            description: "Maintain a 7-day streak",
            iconName: "flame.fill",
            unlocked: focusStats.streak >= 7,
            unlockedDate: focusStats.streak >= 7 ? Date() : nil
        ))

        // High productivity
        achievements.append(Achievement(
            id: "high-productivity",
            name: "Productivity Pro",
            description: "Achieve 80%+ completion rate for a week",
            iconName: "chart.line.uptrend.xyaxis",
            unlocked: completionRate >= 0.8,
            unlockedDate: completionRate >= 0.8 ? Date() : nil
        ))

        // Focus master
        achievements.append(Achievement(
            id: "focus-master",
            name: "Focus Master",
            description: "Complete 10 hours of focused work",
            iconName: "brain.head.profile",
            unlocked: focusStats.weekMinutes >= 600,
            unlockedDate: focusStats.weekMinutes >= 600 ? Date() : nil
        ))

        return achievements
    }
}
