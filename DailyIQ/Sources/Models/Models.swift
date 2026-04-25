import Foundation

// MARK: - Task Model

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var notes: String?
    var estimatedMinutes: Int
    var priority: Priority
    var category: Category
    var energyRequired: EnergyLevel
    var dueDate: Date?
    var recurring: RecurringRule?
    var status: TaskStatus
    var createdAt: Date
    var completedAt: Date?

    init(
        id: UUID = UUID(),
        title: String,
        notes: String? = nil,
        estimatedMinutes: Int = 30,
        priority: Priority = .p2,
        category: Category = .personal,
        energyRequired: EnergyLevel = .medium,
        dueDate: Date? = nil,
        recurring: RecurringRule? = nil,
        status: TaskStatus = .pending,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.estimatedMinutes = estimatedMinutes
        self.priority = priority
        self.category = category
        self.energyRequired = energyRequired
        self.dueDate = dueDate
        self.recurring = recurring
        self.status = status
        self.createdAt = createdAt
        self.completedAt = nil
    }
}

enum Priority: Int, Codable, CaseIterable {
    case p0 = 0 // Critical
    case p1 = 1 // High
    case p2 = 2 // Medium
    case p3 = 3 // Low

    var displayName: String {
        switch self {
        case .p0: return "P0"
        case .p1: return "P1"
        case .p2: return "P2"
        case .p3: return "P3"
        }
    }
}

enum Category: String, Codable, CaseIterable {
    case work
    case personal
    case health
    case learning
    case social

    var displayName: String {
        rawValue.capitalized
    }

    var iconName: String {
        switch self {
        case .work: return "briefcase.fill"
        case .personal: return "person.fill"
        case .health: return "heart.fill"
        case .learning: return "book.fill"
        case .social: return "person.2.fill"
        }
    }
}

enum EnergyLevel: Int, Codable, CaseIterable {
    case low = 1
    case medium = 2
    case high = 3

    var displayName: String {
        switch self {
        case .low: return "Low Energy"
        case .medium: return "Medium Energy"
        case .high: return "High Energy"
        }
    }
}

enum TaskStatus: String, Codable {
    case pending
    case completed
    case deferred
}

struct RecurringRule: Codable {
    var frequency: Frequency
    var interval: Int

    enum Frequency: String, Codable {
        case daily
        case weekly
        case monthly
    }
}

// MARK: - TaskBlock (Daily Schedule)

struct TaskBlock: Identifiable {
    let id: UUID
    var task: Task
    var startTime: Date
    var endTime: Date
    var energyLevel: Int // 0-100

    init(id: UUID = UUID(), task: Task, startTime: Date, endTime: Date, energyLevel: Int = 70) {
        self.id = id
        self.task = task
        self.startTime = startTime
        self.endTime = endTime
        self.energyLevel = energyLevel
    }
}

// MARK: - Daily Schedule

struct DailySchedule: Identifiable {
    let id: UUID
    let date: Date
    var taskBlocks: [TaskBlock]
    var energyLevel: Int
    var completedTasks: Int
    var totalTasks: Int

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        taskBlocks: [TaskBlock] = [],
        energyLevel: Int = 70,
        completedTasks: Int = 0,
        totalTasks: Int = 0
    ) {
        self.id = id
        self.date = date
        self.taskBlocks = taskBlocks
        self.energyLevel = energyLevel
        self.completedTasks = completedTasks
        self.totalTasks = totalTasks
    }

    var completionRate: Double {
        guard totalTasks > 0 else { return 0 }
        return Double(completedTasks) / Double(totalTasks)
    }
}

// MARK: - Goal Model

struct Goal: Identifiable, Codable {
    let id: UUID
    var title: String
    var targetDate: Date
    var progress: Double
    var linkedTaskIds: [UUID]
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        targetDate: Date,
        progress: Double = 0,
        linkedTaskIds: [UUID] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.targetDate = targetDate
        self.progress = progress
        self.linkedTaskIds = linkedTaskIds
        self.createdAt = createdAt
    }
}
