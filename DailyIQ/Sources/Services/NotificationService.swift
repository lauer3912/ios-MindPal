import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()

    private init() {}

    // MARK: - Authorization

    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error)")
            }
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    func checkAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }

    // MARK: - Task Notifications

    /// Schedule a notification for a task
    func scheduleTaskNotification(for task: Task, at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Task Reminder"
        content.body = task.title
        content.sound = .default
        content.badge = 1

        // Add category for actions
        content.categoryIdentifier = "TASK_REMINDER"

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(
            identifier: task.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }

    /// Schedule notification for task block start
    func scheduleTaskBlockNotification(for block: TaskBlock) {
        let content = UNMutableNotificationContent()
        content.title = "Starting: \(block.task.title)"
        content.body = "Time to focus! Estimated duration: \(block.task.estimatedMinutes) minutes."
        content.sound = .default
        content.categoryIdentifier = "TASK_START"

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: block.startTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(
            identifier: block.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling block notification: \(error)")
            }
        }
    }

    /// Schedule notification for task block end
    func scheduleTaskBlockEndNotification(for block: TaskBlock) {
        let content = UNMutableNotificationContent()
        content.title = "Task Complete"
        content.body = "\(block.task.title) - Time's up! Mark as complete?"
        content.sound = .default
        content.categoryIdentifier = "TASK_END"

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: block.endTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(
            identifier: "\(block.id.uuidString)-end",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling end notification: \(error)")
            }
        }
    }

    // MARK: - Daily Briefing

    /// Schedule morning briefing notification
    func scheduleMorningBriefing(hour: Int = 8, minute: Int = 0) {
        let content = UNMutableNotificationContent()
        content.title = "Good Morning! ☀️"
        content.body = "Start your day with a plan. Tap to see your schedule."
        content.sound = .default
        content.categoryIdentifier = "MORNING_BRIEFING"

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: "morning-briefing",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling morning briefing: \(error)")
            }
        }
    }

    /// Schedule evening review notification
    func scheduleEveningReview(hour: Int = 20, minute: Int = 0) {
        let content = UNMutableNotificationContent()
        content.title = "Evening Review 🌙"
        content.body = "How did your day go? Review your progress."
        content.sound = .default
        content.categoryIdentifier = "EVENING_REVIEW"

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: "evening-review",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling evening review: \(error)")
            }
        }
    }

    // MARK: - Break Reminders

    /// Schedule break reminder
    func scheduleBreakReminder(afterMinutes: Int = 25) {
        let content = UNMutableNotificationContent()
        content.title = "Break Time! 💪"
        content.body = "You've been focused for \(afterMinutes) minutes. Take a short break."
        content.sound = .default
        content.categoryIdentifier = "BREAK_REMINDER"

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(afterMinutes * 60), repeats: false)

        let request = UNNotificationRequest(
            identifier: "break-reminder",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling break reminder: \(error)")
            }
        }
    }

    // MARK: - Goal Notifications

    /// Schedule goal deadline reminder
    func scheduleGoalReminder(for goal: Goal, daysBefore: Int = 1) {
        guard let reminderDate = Calendar.current.date(byAdding: .day, value: -daysBefore, to: goal.targetDate) else { return }

        let content = UNMutableNotificationContent()
        content.title = "Goal Deadline Approaching"
        content.body = "\(goal.title) is due soon! Current progress: \(Int(goal.progress * 100))%"
        content.sound = .default
        content.categoryIdentifier = "GOAL_REMINDER"

        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        let request = UNNotificationRequest(
            identifier: "goal-\(goal.id.uuidString)",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling goal reminder: \(error)")
            }
        }
    }

    // MARK: - Cancel Notifications

    func cancelNotification(for identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    // MARK: - Notification Categories

    func setupNotificationCategories() {
        // Task reminder actions
        let completeAction = UNNotificationAction(
            identifier: "COMPLETE_TASK",
            title: "Mark Complete",
            options: [.foreground]
        )

        let deferAction = UNNotificationAction(
            identifier: "DEFER_TASK",
            title: "Defer",
            options: [.foreground]
        )

        let taskCategory = UNNotificationCategory(
            identifier: "TASK_REMINDER",
            actions: [completeAction, deferAction],
            intentIdentifiers: [],
            options: []
        )

        // Morning briefing category
        let viewScheduleAction = UNNotificationAction(
            identifier: "VIEW_SCHEDULE",
            title: "View Schedule",
            options: [.foreground]
        )

        let morningCategory = UNNotificationCategory(
            identifier: "MORNING_BRIEFING",
            actions: [viewScheduleAction],
            intentIdentifiers: [],
            options: []
        )

        UNUserNotificationCenter.current().setNotificationCategories([taskCategory, morningCategory])
    }
}
