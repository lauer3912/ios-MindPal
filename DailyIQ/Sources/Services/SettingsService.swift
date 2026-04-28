import Foundation
import UIKit
import AudioToolbox

class SettingsService {
    static let shared = SettingsService()

    private let defaults = UserDefaults.standard

    // MARK: - Keys

    private enum Keys {
        static let darkMode = "settings.darkMode"
        static let followSystemTheme = "settings.followSystemTheme"
        static let notificationsEnabled = "settings.notificationsEnabled"
        static let morningBriefingHour = "settings.morningBriefingHour"
        static let morningBriefingMinute = "settings.morningBriefingMinute"
        static let eveningReviewHour = "settings.eveningReviewHour"
        static let eveningReviewMinute = "settings.eveningReviewMinute"
        static let defaultFocusDuration = "settings.defaultFocusDuration"
        static let defaultBreakDuration = "settings.defaultBreakDuration"
        static let soundEnabled = "settings.soundEnabled"
        static let hapticEnabled = "settings.hapticEnabled"
        static let planningAggressiveness = "settings.planningAggressiveness"
        static let autoRegenerate = "settings.autoRegenerate"
        static let userName = "settings.userName"
        static let userTimezone = "settings.userTimezone"
    }

    private init() {}

    // MARK: - Appearance

    enum ThemeMode: Int {
        case system = 0
        case light = 1
        case dark = 2
    }

    var themeMode: ThemeMode {
        get { ThemeMode(rawValue: defaults.integer(forKey: Keys.followSystemTheme)) ?? .system }
        set {
            defaults.set(newValue.rawValue, forKey: Keys.followSystemTheme)
            applyTheme()
        }
    }

    var isDarkMode: Bool {
        switch themeMode {
        case .system:
            return UITraitCollection.current.userInterfaceStyle == .dark
        case .light:
            return false
        case .dark:
            return true
        }
    }

    func applyTheme() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }

            let style: UIUserInterfaceStyle
            switch self.themeMode {
            case .system:
                style = .unspecified
            case .light:
                style = .light
            case .dark:
                style = .dark
            }

            window.overrideUserInterfaceStyle = style
        }
    }

    // MARK: - Notifications

    var notificationsEnabled: Bool {
        get { defaults.bool(forKey: Keys.notificationsEnabled) }
        set { defaults.set(newValue, forKey: Keys.notificationsEnabled) }
    }

    var morningBriefingHour: Int {
        get { defaults.object(forKey: Keys.morningBriefingHour) as? Int ?? 8 }
        set { defaults.set(newValue, forKey: Keys.morningBriefingHour) }
    }

    var morningBriefingMinute: Int {
        get { defaults.object(forKey: Keys.morningBriefingMinute) as? Int ?? 0 }
        set { defaults.set(newValue, forKey: Keys.morningBriefingMinute) }
    }

    var eveningReviewHour: Int {
        get { defaults.object(forKey: Keys.eveningReviewHour) as? Int ?? 20 }
        set { defaults.set(newValue, forKey: Keys.eveningReviewHour) }
    }

    var eveningReviewMinute: Int {
        get { defaults.object(forKey: Keys.eveningReviewMinute) as? Int ?? 0 }
        set { defaults.set(newValue, forKey: Keys.eveningReviewMinute) }
    }

    // MARK: - Focus Timer

    var defaultFocusDuration: Int {
        get { defaults.object(forKey: Keys.defaultFocusDuration) as? Int ?? 25 }
        set { defaults.set(newValue, forKey: Keys.defaultFocusDuration) }
    }

    var defaultBreakDuration: Int {
        get { defaults.object(forKey: Keys.defaultBreakDuration) as? Int ?? 5 }
        set { defaults.set(newValue, forKey: Keys.defaultBreakDuration) }
    }

    // MARK: - Feedback

    var soundEnabled: Bool {
        get { defaults.object(forKey: Keys.soundEnabled) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Keys.soundEnabled) }
    }

    var hapticEnabled: Bool {
        get { defaults.object(forKey: Keys.hapticEnabled) as? Bool ?? true }
        set { defaults.set(newValue, forKey: Keys.hapticEnabled) }
    }

    // MARK: - AI Settings

    enum PlanningAggressiveness: Int {
        case relaxed = 0
        case moderate = 1
        case aggressive = 2

        var displayName: String {
            switch self {
            case .relaxed: return "Relaxed"
            case .moderate: return "Moderate"
            case .aggressive: return "Aggressive"
            }
        }

        var taskDensityFactor: Double {
            switch self {
            case .relaxed: return 0.5
            case .moderate: return 0.75
            case .aggressive: return 1.0
            }
        }
    }

    var planningAggressiveness: PlanningAggressiveness {
        get { PlanningAggressiveness(rawValue: defaults.integer(forKey: Keys.planningAggressiveness)) ?? .moderate }
        set { defaults.set(newValue.rawValue, forKey: Keys.planningAggressiveness) }
    }

    var autoRegenerate: Bool {
        get { defaults.object(forKey: Keys.autoRegenerate) as? Bool ?? false }
        set { defaults.set(newValue, forKey: Keys.autoRegenerate) }
    }

    // MARK: - User Profile

    var userName: String {
        get { defaults.string(forKey: Keys.userName) ?? "User" }
        set { defaults.set(newValue, forKey: Keys.userName) }
    }

    var userTimezone: TimeZone {
        get { defaults.object(forKey: Keys.userTimezone) as? TimeZone ?? TimeZone.current }
        set { defaults.set(newValue.identifier, forKey: Keys.userTimezone) }
    }

    // MARK: - Haptic Feedback

    func triggerHaptic(_ type: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard hapticEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: type)
        generator.impactOccurred()
    }

    // MARK: - Sound

    func playSound(_ name: String) {
        guard soundEnabled else { return }
        // Play system sound
        AudioServicesPlaySystemSound(0)
    }

    // MARK: - Data Export

    func exportData() -> Data? {
        let taskService = TaskService.shared
        let goalService = GoalService.shared

        let exportData: [String: Any] = [
            "tasks": taskService.getAllTasks().map { taskToDict($0) },
            "goals": goalService.getAllGoals().map { goalToDict($0) },
            "settings": [
                "themeMode": themeMode.rawValue,
                "notificationsEnabled": notificationsEnabled,
                "soundEnabled": soundEnabled,
                "hapticEnabled": hapticEnabled
            ],
            "exportDate": Date().timeIntervalSince1970
        ]

        return try? JSONSerialization.data(withJSONObject: exportData, options: .prettyPrinted)
    }

    func importData(_ data: Data) -> Bool {
        guard let importData = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return false
        }

        // Import tasks
        if let tasksArray = importData["tasks"] as? [[String: Any]] {
            for taskDict in tasksArray {
                if let task = dictToTask(taskDict) {
                    TaskService.shared.createTask(task)
                }
            }
        }

        // Import goals
        if let goalsArray = importData["goals"] as? [[String: Any]] {
            for goalDict in goalsArray {
                if let goal = dictToGoal(goalDict) {
                    GoalService.shared.createGoal(goal)
                }
            }
        }

        return true
    }

    private func taskToDict(_ task: Task) -> [String: Any] {
        return [
            "id": task.id.uuidString,
            "title": task.title,
            "notes": task.notes ?? "",
            "estimatedMinutes": task.estimatedMinutes,
            "priority": task.priority.rawValue,
            "category": task.category.rawValue,
            "energyRequired": task.energyRequired.rawValue,
            "status": task.status.rawValue,
            "createdAt": task.createdAt.timeIntervalSince1970
        ]
    }

    private func goalToDict(_ goal: Goal) -> [String: Any] {
        return [
            "id": goal.id.uuidString,
            "title": goal.title,
            "targetDate": goal.targetDate.timeIntervalSince1970,
            "progress": goal.progress,
            "createdAt": goal.createdAt.timeIntervalSince1970
        ]
    }

    private func dictToTask(_ dict: [String: Any]) -> Task? {
        guard let idStr = dict["id"] as? String,
              let id = UUID(uuidString: idStr),
              let title = dict["title"] as? String else {
            return nil
        }

        return Task(
            id: id,
            title: title,
            notes: dict["notes"] as? String,
            estimatedMinutes: dict["estimatedMinutes"] as? Int ?? 30,
            priority: Priority(rawValue: dict["priority"] as? Int ?? 2) ?? .p2,
            category: Category(rawValue: dict["category"] as? String ?? "personal") ?? .personal,
            energyRequired: EnergyLevel(rawValue: dict["energyRequired"] as? Int ?? 2) ?? .medium,
            dueDate: nil,
            recurring: nil,
            status: TaskStatus(rawValue: dict["status"] as? String ?? "pending") ?? .pending,
            createdAt: Date(timeIntervalSince1970: dict["createdAt"] as? TimeInterval ?? Date().timeIntervalSince1970)
        )
    }

    private func dictToGoal(_ dict: [String: Any]) -> Goal? {
        guard let idStr = dict["id"] as? String,
              let id = UUID(uuidString: idStr),
              let title = dict["title"] as? String else {
            return nil
        }

        return Goal(
            id: id,
            title: title,
            targetDate: Date(timeIntervalSince1970: dict["targetDate"] as? TimeInterval ?? Date().timeIntervalSince1970),
            progress: dict["progress"] as? Double ?? 0,
            linkedTaskIds: [],
            createdAt: Date(timeIntervalSince1970: dict["createdAt"] as? TimeInterval ?? Date().timeIntervalSince1970)
        )
    }
}
