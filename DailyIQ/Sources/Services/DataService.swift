import Foundation
import SQLite

final class DataService {
    static let shared = DataService()

    private var db: Connection?

    // Tables
    private let tasks = Table("tasks")
    private let events = Table("events")
    private let goals = Table("goals")
    private let insights = Table("insights")
    private let settings = Table("settings")
    private let statistics = Table("statistics")

    // Task columns
    private let taskId = Expression<String>("id")
    private let taskTitle = Expression<String>("title")
    private let taskNotes = Expression<String?>("notes")
    private let taskEstimatedMinutes = Expression<Int>("estimated_minutes")
    private let taskPriority = Expression<Int>("priority")
    private let taskCategory = Expression<String>("category")
    private let taskEnergyRequired = Expression<Int>("energy_required")
    private let taskDueDate = Expression<Date?>("due_date")
    private let taskRecurring = Expression<String?>("recurring")
    private let taskStatus = Expression<String>("status")
    private let taskCreatedAt = Expression<Date>("created_at")
    private let taskCompletedAt = Expression<Date?>("completed_at")

    // Event columns
    private let eventId = Expression<String>("id")
    private let eventTitle = Expression<String>("title")
    private let eventNotes = Expression<String?>("notes")
    private let eventStartTime = Expression<Date>("start_time")
    private let eventEndTime = Expression<Date>("end_time")
    private let eventIsAllDay = Expression<Bool>("is_all_day")
    private let eventRepeatRule = Expression<String?>("repeat_rule")
    private let eventColor = Expression<String>("color")
    private let eventLocation = Expression<String?>("location")
    private let eventReminder = Expression<Int>("reminder")
    private let eventIsPinned = Expression<Bool>("is_pinned")
    private let eventCreatedAt = Expression<Date>("created_at")

    // Goal columns
    private let goalId = Expression<String>("id")
    private let goalTitle = Expression<String>("title")
    private let goalTargetDate = Expression<Date>("target_date")
    private let goalProgress = Expression<Double>("progress")
    private let goalLinkedTaskIds = Expression<String>("linked_task_ids")
    private let goalCreatedAt = Expression<Date>("created_at")
    private let goalCategory = Expression<String>("category")

    // Insight columns
    private let insightId = Expression<String>("id")
    private let insightType = Expression<String>("type")
    private let insightTitle = Expression<String>("title")
    private let insightMessage = Expression<String>("message")
    private let insightActionLabel = Expression<String?>("action_label")
    private let insightActionData = Expression<String?>("action_data")
    private let insightCreatedAt = Expression<Date>("created_at")
    private let insightIsRead = Expression<Bool>("is_read")

    // Settings
    private let settingsData = Expression<Data>("settings_data")

    private init() {
        setupDatabase()
    }

    private func setupDatabase() {
        do {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dbPath = documentsPath.appendingPathComponent("dailyiq.sqlite3")
            db = try Connection(dbPath.path)
            createTables()
        } catch {
            print("Database setup error: \(error)")
        }
    }

    private func createTables() {
        do {
            try db?.run(tasks.create(ifNotExists: true) { t in
                t.column(taskId, primaryKey: true)
                t.column(taskTitle)
                t.column(taskNotes)
                t.column(taskEstimatedMinutes)
                t.column(taskPriority)
                t.column(taskCategory)
                t.column(taskEnergyRequired)
                t.column(taskDueDate)
                t.column(taskRecurring)
                t.column(taskStatus)
                t.column(taskCreatedAt)
                t.column(taskCompletedAt)
            })

            try db?.run(events.create(ifNotExists: true) { t in
                t.column(eventId, primaryKey: true)
                t.column(eventTitle)
                t.column(eventNotes)
                t.column(eventStartTime)
                t.column(eventEndTime)
                t.column(eventIsAllDay)
                t.column(eventRepeatRule)
                t.column(eventColor)
                t.column(eventLocation)
                t.column(eventReminder)
                t.column(eventIsPinned)
                t.column(eventCreatedAt)
            })

            try db?.run(goals.create(ifNotExists: true) { t in
                t.column(goalId, primaryKey: true)
                t.column(goalTitle)
                t.column(goalTargetDate)
                t.column(goalProgress)
                t.column(goalLinkedTaskIds)
                t.column(goalCreatedAt)
                t.column(goalCategory)
            })

            try db?.run(insights.create(ifNotExists: true) { t in
                t.column(insightId, primaryKey: true)
                t.column(insightType)
                t.column(insightTitle)
                t.column(insightMessage)
                t.column(insightActionLabel)
                t.column(insightActionData)
                t.column(insightCreatedAt)
                t.column(insightIsRead)
            })
        } catch {
            print("Create tables error: \(error)")
        }
    }

    // MARK: - Tasks CRUD

    func saveTask(_ task: Task) {
        do {
            let insert = tasks.insert(or: .replace,
                taskId <- task.id.uuidString,
                taskTitle <- task.title,
                taskNotes <- task.notes,
                taskEstimatedMinutes <- task.estimatedMinutes,
                taskPriority <- task.priority.rawValue,
                taskCategory <- task.category.rawValue,
                taskEnergyRequired <- task.energyRequired.rawValue,
                taskDueDate <- task.dueDate,
                taskRecurring <- task.recurring.flatMap { try? JSONEncoder().encode($0) }.flatMap { String(data: $0, encoding: .utf8) },
                taskStatus <- task.status.rawValue,
                taskCreatedAt <- task.createdAt,
                taskCompletedAt <- task.completedAt
            )
            try db?.run(insert)
        } catch {
            print("Save task error: \(error)")
        }
    }

    func getAllTasks() -> [Task] {
        var result: [Task] = []
        do {
            guard let rows = try db?.prepare(tasks) else { return result }
            for row in rows {
                if let task = taskFromRow(row) {
                    result.append(task)
                }
            }
        } catch {
            print("Get tasks error: \(error)")
        }
        return result
    }

    func getTask(by id: UUID) -> Task? {
        do {
            let query = tasks.filter(taskId == id.uuidString)
            if let row = try db?.pluck(query) {
                return taskFromRow(row)
            }
        } catch {
            print("Get task error: \(error)")
        }
        return nil
    }

    func deleteTask(_ task: Task) {
        do {
            let query = tasks.filter(taskId == task.id.uuidString)
            try db?.run(query.delete())
        } catch {
            print("Delete task error: \(error)")
        }
    }

    private func taskFromRow(_ row: Row) -> Task? {
        guard let id = UUID(uuidString: row[taskId]),
              let priority = Priority(rawValue: row[taskPriority]),
              let category = Category(rawValue: row[taskCategory]),
              let energyLevel = EnergyLevel(rawValue: row[taskEnergyRequired]),
              let status = TaskStatus(rawValue: row[taskStatus]) else {
            return nil
        }

        var recurring: RecurringRule?
        if let recurringStr = row[taskRecurring],
           let data = recurringStr.data(using: .utf8) {
            recurring = try? JSONDecoder().decode(RecurringRule.self, from: data)
        }

        return Task(
            id: id,
            title: row[taskTitle],
            notes: row[taskNotes],
            estimatedMinutes: row[taskEstimatedMinutes],
            priority: priority,
            category: category,
            energyRequired: energyLevel,
            dueDate: row[taskDueDate],
            recurring: recurring,
            status: status,
            createdAt: row[taskCreatedAt],
            completedAt: row[taskCompletedAt]
        )
    }

    // MARK: - Events CRUD

    func saveEvent(_ event: Event) {
        do {
            let insert = events.insert(or: .replace,
                eventId <- event.id.uuidString,
                eventTitle <- event.title,
                eventNotes <- event.notes,
                eventStartTime <- event.startTime,
                eventEndTime <- event.endTime,
                eventIsAllDay <- event.isAllDay,
                eventRepeatRule <- event.repeatRule.flatMap { try? JSONEncoder().encode($0) }.flatMap { String(data: $0, encoding: .utf8) },
                eventColor <- event.color.rawValue,
                eventLocation <- event.location,
                eventReminder <- event.reminder?.rawValue ?? EventReminder.fifteenMinutes.rawValue,
                eventIsPinned <- event.isPinned,
                eventCreatedAt <- event.createdAt
            )
            try db?.run(insert)
        } catch {
            print("Save event error: \(error)")
        }
    }

    func getEvents(for date: Date) -> [Event] {
        var result: [Event] = []
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        do {
            let query = events.filter(eventStartTime >= startOfDay && eventStartTime < endOfDay)
            guard let rows = try db?.prepare(query) else { return result }
            for row in rows {
                if let event = eventFromRow(row) {
                    result.append(event)
                }
            }
        } catch {
            print("Get events error: \(error)")
        }
        return result
    }

    func getAllEvents() -> [Event] {
        var result: [Event] = []
        do {
            guard let rows = try db?.prepare(events) else { return result }
            for row in rows {
                if let event = eventFromRow(row) {
                    result.append(event)
                }
            }
        } catch {
            print("Get events error: \(error)")
        }
        return result
    }

    func deleteEvent(_ event: Event) {
        do {
            let query = events.filter(eventId == event.id.uuidString)
            try db?.run(query.delete())
        } catch {
            print("Delete event error: \(error)")
        }
    }

    private func eventFromRow(_ row: Row) -> Event? {
        guard let id = UUID(uuidString: row[eventId]),
              let color = EventColor(rawValue: row[eventColor]),
              let reminder = EventReminder(rawValue: row[eventReminder]) else {
            return nil
        }

        var repeatRule: EventRepeatRule?
        if let ruleStr = row[eventRepeatRule],
           let data = ruleStr.data(using: .utf8) {
            repeatRule = try? JSONDecoder().decode(EventRepeatRule.self, from: data)
        }

        return Event(
            id: id,
            title: row[eventTitle],
            notes: row[eventNotes],
            startTime: row[eventStartTime],
            endTime: row[eventEndTime],
            isAllDay: row[eventIsAllDay],
            repeatRule: repeatRule,
            color: color,
            location: row[eventLocation],
            reminder: reminder,
            isPinned: row[eventIsPinned],
            createdAt: row[eventCreatedAt]
        )
    }

    // MARK: - Goals CRUD

    func saveGoal(_ goal: Goal) {
        do {
            let linkedIds = goal.linkedTaskIds.map { $0.uuidString }.joined(separator: ",")
            let insert = goals.insert(or: .replace,
                goalId <- goal.id.uuidString,
                goalTitle <- goal.title,
                goalTargetDate <- goal.targetDate,
                goalProgress <- goal.progress,
                goalLinkedTaskIds <- linkedIds,
                goalCreatedAt <- goal.createdAt,
                goalCategory <- goal.category.rawValue
            )
            try db?.run(insert)
        } catch {
            print("Save goal error: \(error)")
        }
    }

    func getAllGoals() -> [Goal] {
        var result: [Goal] = []
        do {
            guard let rows = try db?.prepare(goals) else { return result }
            for row in rows {
                if let goal = goalFromRow(row) {
                    result.append(goal)
                }
            }
        } catch {
            print("Get goals error: \(error)")
        }
        return result
    }

    func deleteGoal(_ goal: Goal) {
        do {
            let query = goals.filter(goalId == goal.id.uuidString)
            try db?.run(query.delete())
        } catch {
            print("Delete goal error: \(error)")
        }
    }

    private func goalFromRow(_ row: Row) -> Goal? {
        guard let id = UUID(uuidString: row[goalId]),
              let category = GoalCategory(rawValue: row[goalCategory]) else {
            return nil
        }

        let linkedIds = row[goalLinkedTaskIds]
            .split(separator: ",")
            .compactMap { UUID(uuidString: String($0)) }

        return Goal(
            id: id,
            title: row[goalTitle],
            targetDate: row[goalTargetDate],
            progress: row[goalProgress],
            linkedTaskIds: linkedIds,
            createdAt: row[goalCreatedAt],
            category: category
        )
    }

    // MARK: - AI Insights CRUD

    func saveInsight(_ insight: AIInsight) {
        do {
            let insert = insights.insert(or: .replace,
                insightId <- insight.id.uuidString,
                insightType <- insight.type.rawValue,
                insightTitle <- insight.title,
                insightMessage <- insight.message,
                insightActionLabel <- insight.actionLabel,
                insightActionData <- insight.actionData,
                insightCreatedAt <- insight.createdAt,
                insightIsRead <- insight.isRead
            )
            try db?.run(insert)
        } catch {
            print("Save insight error: \(error)")
        }
    }

    func getInsights() -> [AIInsight] {
        var result: [AIInsight] = []
        do {
            let query = insights.order(insightCreatedAt.desc)
            guard let rows = try db?.prepare(query) else { return result }
            for row in rows {
                if let insight = insightFromRow(row) {
                    result.append(insight)
                }
            }
        } catch {
            print("Get insights error: \(error)")
        }
        return result
    }

    func markInsightRead(_ insight: AIInsight) {
        var updated = insight
        updated.isRead = true
        saveInsight(updated)
    }

    private func insightFromRow(_ row: Row) -> AIInsight? {
        guard let id = UUID(uuidString: row[insightId]),
              let type = InsightType(rawValue: row[insightType]) else {
            return nil
        }

        return AIInsight(
            id: id,
            type: type,
            title: row[insightTitle],
            message: row[insightMessage],
            actionLabel: row[insightActionLabel],
            actionData: row[insightActionData],
            createdAt: row[insightCreatedAt],
            isRead: row[insightIsRead]
        )
    }

    // MARK: - User Settings

    func saveUserSettings(_ userSettings: UserSettings) {
        do {
            if let data = try? JSONEncoder().encode(userSettings) {
                let insert = settings.insert(or: .replace,
                    Expression<String>("key") <- "user_settings",
                    settingsData <- data
                )
                try db?.run(insert)
            }
        } catch {
            print("Save settings error: \(error)")
        }
    }

    func getUserSettings() -> UserSettings {
        do {
            let query = settings.filter(Expression<String>("key") == "user_settings")
            if let row = try db?.pluck(query) {
                let data = row[settingsData]
                return try JSONDecoder().decode(UserSettings.self, from: data)
            }
        } catch {
            print("Get settings error: \(error)")
        }
        return UserSettings()
    }

    // MARK: - Statistics

    func saveDailyStatistics(_ dailyStats: DailyStatistics) {
        let key = "stats_\(DailyStatistics.dateFormatter.string(from: dailyStats.date))"
        do {
            if let data = try? JSONEncoder().encode(dailyStats) {
                let insert = statistics.insert(or: .replace,
                    Expression<String>("key") <- key,
                    settingsData <- data
                )
                try db?.run(insert)
            }
        } catch {
            print("Save statistics error: \(error)")
        }
    }

    func getDailyStatistics(for date: Date) -> DailyStatistics? {
        let key = "stats_\(DailyStatistics.dateFormatter.string(from: date))"
        do {
            let query = statistics.filter(Expression<String>("key") == key)
            if let row = try db?.pluck(query) {
                return try JSONDecoder().decode(DailyStatistics.self, from: row[settingsData])
            }
        } catch {
            print("Get statistics error: \(error)")
        }
        return nil
    }

    func getWeekStatistics(startDate: Date) -> [DailyStatistics] {
        var result: [DailyStatistics] = []
        let calendar = Calendar.current
        for i in 0..<7 {
            if let date = calendar.date(byAdding: .day, value: i, to: startDate) {
                if let stats = getDailyStatistics(for: date) {
                    result.append(stats)
                }
            }
        }
        return result
    }
}

// MARK: - Date Formatter Extension

extension DailyStatistics {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}