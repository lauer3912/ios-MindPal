import Foundation
import SQLite

class GoalService {
    static let shared = GoalService()

    private var db: Connection?
    private let goalsTable = Table("goals")

    // Column definitions
    private let id = Expression<String>("id")
    private let title = Expression<String>("title")
    private let targetDate = Expression<Double>("target_date")
    private let progress = Expression<Double>("progress")
    private let linkedTaskIds = Expression<String>("linked_task_ids")
    private let createdAt = Expression<Double>("created_at")
    private let category = Expression<String>("category")

    private init() {
        setupDatabase()
    }

    private func setupDatabase() {
        do {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dbPath = documentsPath.appendingPathComponent("dailyiq.sqlite3").path
            db = try Connection(dbPath)

            try db?.run(goalsTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(title)
                t.column(targetDate)
                t.column(progress)
                t.column(linkedTaskIds)
                t.column(createdAt)
                t.column(category)
            })
        } catch {
            print("Goals database setup error: \(error)")
        }
    }

    // MARK: - CRUD Operations

    func createGoal(_ goal: Goal) {
        do {
            let linkedIds = goal.linkedTaskIds.map { $0.uuidString }.joined(separator: ",")
            let insert = goalsTable.insert(
                id <- goal.id.uuidString,
                title <- goal.title,
                targetDate <- goal.targetDate.timeIntervalSince1970,
                progress <- goal.progress,
                linkedTaskIds <- linkedIds,
                createdAt <- goal.createdAt.timeIntervalSince1970,
                category <- goal.category.rawValue
            )
            try db?.run(insert)
        } catch {
            print("Insert goal error: \(error)")
        }
    }

    func getAllGoals() -> [Goal] {
        var goals: [Goal] = []
        do {
            guard let db = db else { return [] }
            for row in try db.prepare(goalsTable.order(createdAt.desc)) {
                let goal = rowToGoal(row)
                goals.append(goal)
            }
        } catch {
            print("Fetch goals error: \(error)")
        }
        return goals
    }

    func getActiveGoals() -> [Goal] {
        return getAllGoals().filter { $0.progress < 1.0 }
    }

    func updateGoal(_ goal: Goal) {
        do {
            let goalRow = goalsTable.filter(id == goal.id.uuidString)
            let linkedIds = goal.linkedTaskIds.map { $0.uuidString }.joined(separator: ",")
            try db?.run(goalRow.update(
                title <- goal.title,
                targetDate <- goal.targetDate.timeIntervalSince1970,
                progress <- goal.progress,
                linkedTaskIds <- linkedIds,
                category <- goal.category.rawValue
            ))
        } catch {
            print("Update goal error: \(error)")
        }
    }

    func deleteGoal(_ goalId: UUID) {
        do {
            let goalRow = goalsTable.filter(id == goalId.uuidString)
            try db?.run(goalRow.delete())
        } catch {
            print("Delete goal error: \(error)")
        }
    }

    func updateGoalProgress(_ goalId: UUID, progress: Double) {
        guard var goal = getGoalById(goalId) else { return }
        goal.progress = min(1.0, max(0.0, progress))
        updateGoal(goal)
    }

    func linkTaskToGoal(_ goalId: UUID, taskId: UUID) {
        guard var goal = getGoalById(goalId) else { return }
        if !goal.linkedTaskIds.contains(taskId) {
            goal.linkedTaskIds.append(taskId)
            updateGoal(goal)
        }
    }

    func getGoalById(_ goalId: UUID) -> Goal? {
        do {
            guard let db = db else { return nil }
            let query = goalsTable.filter(id == goalId.uuidString)
            if let row = try db.pluck(query) {
                return rowToGoal(row)
            }
        } catch {
            print("Get goal by ID error: \(error)")
        }
        return nil
    }

    private func rowToGoal(_ row: Row) -> Goal {
        let linkedIdsString = row[linkedTaskIds]
        let linkedIds = linkedIdsString.split(separator: ",").compactMap { UUID(uuidString: String($0)) }
        let goalCategory = GoalCategory(rawValue: row[category]) ?? .personal

        return Goal(
            id: UUID(uuidString: row[id]) ?? UUID(),
            title: row[title],
            targetDate: Date(timeIntervalSince1970: row[targetDate]),
            progress: row[progress],
            linkedTaskIds: linkedIds,
            createdAt: Date(timeIntervalSince1970: row[createdAt]),
            category: goalCategory
        )
    }

    // MARK: - Progress Calculation

    func calculateGoalProgress(_ goalId: UUID) -> Double {
        guard let goal = getGoalById(goalId) else { return 0 }

        if goal.linkedTaskIds.isEmpty {
            return goal.progress
        }

        let taskService = TaskService.shared
        var completedCount = 0

        for taskId in goal.linkedTaskIds {
            if let task = taskService.getTaskById(taskId), task.status == .completed {
                completedCount += 1
            }
        }

        let progress = Double(completedCount) / Double(goal.linkedTaskIds.count)
        updateGoalProgress(goalId, progress: progress)
        return progress
    }

    // MARK: - Weekly/Monthly Planning

    func getGoalsForWeek() -> [Goal] {
        let calendar = Calendar.current
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        let weekEnd = calendar.date(byAdding: .day, value: 7, to: weekStart)!

        return getAllGoals().filter { goal in
            goal.targetDate >= weekStart && goal.targetDate < weekEnd
        }
    }

    func getGoalsForMonth() -> [Goal] {
        let calendar = Calendar.current
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let monthEnd = calendar.date(byAdding: .month, value: 1, to: monthStart)!

        return getAllGoals().filter { goal in
            goal.targetDate >= monthStart && goal.targetDate < monthEnd
        }
    }
}
