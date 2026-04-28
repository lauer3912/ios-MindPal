import Foundation

/// Manages widget data by updating shared UserDefaults for the widget extension
class WidgetDataManager {
    static let shared = WidgetDataManager()

    private let sharedDefaults: UserDefaults?
    private let suiteName = "group.com.ggsheng.DailyIQ"

    private init() {
        sharedDefaults = UserDefaults(suiteName: suiteName)
    }

    // MARK: - Update Widget Data

    /// Call this whenever task data changes to update the widget
    func updateWidgetData() {
        let taskService = TaskService.shared
        let insightsService = InsightsService.shared

        let today = Date()
        let pendingTasks = taskService.getPendingTasks()
        let todayTasks = taskService.getTasksForDate(today)
        let completedToday = taskService.getCompletedTasksCount(for: today)
        let focusStats = insightsService.getFocusStats()

        // Calculate energy level based on time of day
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: today)
        let energyLevel = calculateEnergyLevel(for: hour)

        // Get next task
        let nextTask = pendingTasks.first
        let nextTaskTitle = nextTask?.title
        let nextTaskTime = nextTask?.dueDate?.timeString

        // Update shared defaults
        sharedDefaults?.set(energyLevel, forKey: "widget_energy_level")
        sharedDefaults?.set(completedToday, forKey: "widget_completed_tasks")
        sharedDefaults?.set(todayTasks.count, forKey: "widget_total_tasks")
        sharedDefaults?.set(nextTaskTitle, forKey: "widget_next_task_title")
        sharedDefaults?.set(nextTaskTime, forKey: "widget_next_task_time")
        sharedDefaults?.set(focusStats.streak, forKey: "widget_streak")

        // Force synchronize to ensure widget sees updates
        sharedDefaults?.synchronize()

        // Trigger widget reload
        reloadWidget()
    }

    /// Call this when a task is completed or schedule changes
    func refreshWidget() {
        updateWidgetData()
    }

    private func calculateEnergyLevel(for hour: Int) -> Int {
        // Peak hours: 9-11 AM (high), 2-4 PM (medium), rest (low)
        if hour >= 9 && hour <= 11 {
            return 90
        } else if hour >= 14 && hour <= 16 {
            return 70
        } else if hour >= 6 && hour <= 20 {
            return 50
        } else {
            return 30
        }
    }

    private func reloadWidget() {
        #if canImport(WidgetKit)
        import WidgetKit
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
        #endif
    }
}
