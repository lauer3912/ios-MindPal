import Foundation
import SQLite

class TaskService {
    static let shared = TaskService()

    private var db: Connection?
    private let tasksTable = Table("tasks")

    // Column definitions
    private let id = Expression<String>("id")
    private let title = Expression<String>("title")
    private let notes = Expression<String?>("notes")
    private let estimatedMinutes = Expression<Int>("estimated_minutes")
    private let priority = Expression<Int>("priority")
    private let category = Expression<String>("category")
    private let energyRequired = Expression<Int>("energy_required")
    private let dueDate = Expression<Double?>("due_date")
    private let recurringFrequency = Expression<String?>("recurring_frequency")
    private let recurringInterval = Expression<Int?>("recurring_interval")
    private let status = Expression<String>("status")
    private let createdAt = Expression<Double>("created_at")
    private let completedAt = Expression<Double?>("completed_at")

    private init() {
        setupDatabase()
    }

    private func setupDatabase() {
        do {
            let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let dbPath = documentsPath.appendingPathComponent("dailyiq.sqlite3").path
            db = try Connection(dbPath)

            try db?.run(tasksTable.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(title)
                t.column(notes)
                t.column(estimatedMinutes)
                t.column(priority)
                t.column(category)
                t.column(energyRequired)
                t.column(dueDate)
                t.column(recurringFrequency)
                t.column(recurringInterval)
                t.column(status)
                t.column(createdAt)
                t.column(completedAt)
            })
        } catch {
            print("Database setup error: \(error)")
        }
    }

    // MARK: - CRUD Operations

    func createTask(_ task: Task) {
        do {
            let insert = tasksTable.insert(
                id <- task.id.uuidString,
                title <- task.title,
                notes <- task.notes,
                estimatedMinutes <- task.estimatedMinutes,
                priority <- task.priority.rawValue,
                category <- task.category.rawValue,
                energyRequired <- task.energyRequired.rawValue,
                dueDate <- task.dueDate?.timeIntervalSince1970,
                recurringFrequency <- task.recurring?.frequency.rawValue,
                recurringInterval <- task.recurring?.interval,
                status <- task.status.rawValue,
                createdAt <- task.createdAt.timeIntervalSince1970,
                completedAt <- task.completedAt?.timeIntervalSince1970
            )
            try db?.run(insert)
        } catch {
            print("Insert task error: \(error)")
        }
    }

    func getAllTasks() -> [Task] {
        var tasks: [Task] = []
        do {
            guard let db = db else { return [] }
            for row in try db.prepare(tasksTable.order(createdAt.desc)) {
                let task = rowToTask(row)
                tasks.append(task)
            }
        } catch {
            print("Fetch tasks error: \(error)")
        }
        return tasks
    }

    func getPendingTasks() -> [Task] {
        return getAllTasks().filter { $0.status == .pending }
    }

    func getTasksForDate(_ date: Date) -> [Task] {
        let calendar = Calendar.current
        return getAllTasks().filter { task in
            guard let dueDate = task.dueDate else { return false }
            return calendar.isDate(dueDate, inSameDayAs: date)
        }
    }

    func updateTask(_ task: Task) {
        do {
            let taskRow = tasksTable.filter(id == task.id.uuidString)
            try db?.run(taskRow.update(
                title <- task.title,
                notes <- task.notes,
                estimatedMinutes <- task.estimatedMinutes,
                priority <- task.priority.rawValue,
                category <- task.category.rawValue,
                energyRequired <- task.energyRequired.rawValue,
                dueDate <- task.dueDate?.timeIntervalSince1970,
                recurringFrequency <- task.recurring?.frequency.rawValue,
                recurringInterval <- task.recurring?.interval,
                status <- task.status.rawValue,
                completedAt <- task.completedAt?.timeIntervalSince1970
            ))
        } catch {
            print("Update task error: \(error)")
        }
    }

    func deleteTask(_ taskId: UUID) {
        do {
            let taskRow = tasksTable.filter(id == taskId.uuidString)
            try db?.run(taskRow.delete())
        } catch {
            print("Delete task error: \(error)")
        }
    }

    func completeTask(_ taskId: UUID) {
        guard var task = getTaskById(taskId) else { return }
        task.status = .completed
        task.completedAt = Date()
        updateTask(task)
    }

    func deferTask(_ taskId: UUID, to date: Date) {
        guard var task = getTaskById(taskId) else { return }
        task.status = .deferred
        task.dueDate = date
        updateTask(task)
    }

    func getTaskById(_ taskId: UUID) -> Task? {
        do {
            guard let db = db else { return nil }
            let query = tasksTable.filter(id == taskId.uuidString)
            if let row = try db.pluck(query) {
                return rowToTask(row)
            }
        } catch {
            print("Get task by ID error: \(error)")
        }
        return nil
    }

    private func rowToTask(_ row: Row) -> Task {
        let priorityVal = Priority(rawValue: row[priority]) ?? .p2
        let categoryVal = Category(rawValue: row[category]) ?? .personal
        let energyVal = EnergyLevel(rawValue: row[energyRequired]) ?? .medium
        let statusVal = TaskStatus(rawValue: row[status]) ?? .pending

        var recurringRule: RecurringRule?
        if let freqStr = row[recurringFrequency],
           let freq = RecurringRule.Frequency(rawValue: freqStr),
           let interval = row[recurringInterval] {
            recurringRule = RecurringRule(frequency: freq, interval: interval)
        }

        return Task(
            id: UUID(uuidString: row[id]) ?? UUID(),
            title: row[title],
            notes: row[notes],
            estimatedMinutes: row[estimatedMinutes],
            priority: priorityVal,
            category: categoryVal,
            energyRequired: energyVal,
            dueDate: row[dueDate].map { Date(timeIntervalSince1970: $0) },
            recurring: recurringRule,
            status: statusVal,
            createdAt: Date(timeIntervalSince1970: row[createdAt])
        )
    }

    // MARK: - Statistics

    func getCompletedTasksCount(for date: Date) -> Int {
        let calendar = Calendar.current
        return getAllTasks().filter { task in
            guard let completedAt = task.completedAt else { return false }
            return task.status == .completed && calendar.isDate(completedAt, inSameDayAs: date)
        }.count
    }

    func getTotalFocusMinutes(for date: Date) -> Int {
        // This would be calculated from task blocks
        return 0
    }

    func getStreak() -> Int {
        // Calculate consecutive days with completed tasks
        let calendar = Calendar.current
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())

        while true {
            let completedCount = getCompletedTasksCount(for: currentDate)
            if completedCount > 0 {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break
            }
        }
        return streak
    }
}
