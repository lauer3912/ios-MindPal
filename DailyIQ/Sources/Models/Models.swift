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
    var category: GoalCategory

    init(
        id: UUID = UUID(),
        title: String,
        targetDate: Date,
        progress: Double = 0,
        linkedTaskIds: [UUID] = [],
        createdAt: Date = Date(),
        category: GoalCategory = .personal
    ) {
        self.id = id
        self.title = title
        self.targetDate = targetDate
        self.progress = progress
        self.linkedTaskIds = linkedTaskIds
        self.createdAt = createdAt
        self.category = category
    }
}

enum GoalCategory: String, Codable, CaseIterable {
    case work
    case health
    case personal
    case learning
    case financial
    case creative

    var displayName: String {
        rawValue.capitalized
    }

    var iconName: String {
        switch self {
        case .work: return "briefcase.fill"
        case .health: return "heart.fill"
        case .personal: return "person.fill"
        case .learning: return "book.fill"
        case .financial: return "dollarsign.circle.fill"
        case .creative: return "paintbrush.fill"
        }
    }
}

// MARK: - Event Model (Calendar)

struct Event: Identifiable, Codable {
    let id: UUID
    var title: String
    var notes: String?
    var startTime: Date
    var endTime: Date
    var isAllDay: Bool
    var repeatRule: EventRepeatRule?
    var color: EventColor
    var location: String?
    var reminder: EventReminder?
    var isPinned: Bool
    var createdAt: Date

    init(
        id: UUID = UUID(),
        title: String,
        notes: String? = nil,
        startTime: Date,
        endTime: Date,
        isAllDay: Bool = false,
        repeatRule: EventRepeatRule? = nil,
        color: EventColor = .violet,
        location: String? = nil,
        reminder: EventReminder? = .fifteenMinutes,
        isPinned: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.notes = notes
        self.startTime = startTime
        self.endTime = endTime
        self.isAllDay = isAllDay
        self.repeatRule = repeatRule
        self.color = color
        self.location = location
        self.reminder = reminder
        self.isPinned = isPinned
        self.createdAt = createdAt
    }

    var durationMinutes: Int {
        Int(endTime.timeIntervalSince(startTime) / 60)
    }
}

enum EventColor: String, Codable, CaseIterable {
    case violet, mint, amber, red, blue, orange, pink, teal

    var uiColor: String {
        switch self {
        case .violet: return "#9B8FE8"
        case .mint: return "#6EE7B7"
        case .amber: return "#FCD34D"
        case .red: return "#EF4444"
        case .blue: return "#3B82F6"
        case .orange: return "#F97316"
        case .pink: return "#EC4899"
        case .teal: return "#14B8A6"
        }
    }
}

enum EventRepeatRule: Codable {
    case daily(interval: Int)
    case weekly(interval: Int, weekdays: [Int]?)
    case monthly(interval: Int, dayOfMonth: Int?)
    case custom(days: [Date])

    var displayName: String {
        switch self {
        case .daily(let interval):
            return interval == 1 ? "Every day" : "Every \(interval) days"
        case .weekly(let interval, _):
            return interval == 1 ? "Every week" : "Every \(interval) weeks"
        case .monthly(let interval, _):
            return interval == 1 ? "Every month" : "Every \(interval) months"
        case .custom:
            return "Custom"
        }
    }
}

enum EventReminder: Int, Codable, CaseIterable {
    case none = 0
    case oneMinute = 1
    case fiveMinutes = 5
    case fifteenMinutes = 15
    case thirtyMinutes = 30
    case oneHour = 60
    case oneDay = 1440

    var displayName: String {
        switch self {
        case .none: return "None"
        case .oneMinute: return "At time of event"
        case .fiveMinutes: return "5 minutes before"
        case .fifteenMinutes: return "15 minutes before"
        case .thirtyMinutes: return "30 minutes before"
        case .oneHour: return "1 hour before"
        case .oneDay: return "1 day before"
        }
    }
}

// MARK: - AI Insight Model

struct AIInsight: Identifiable, Codable {
    let id: UUID
    var type: InsightType
    var title: String
    var message: String
    var actionLabel: String?
    var actionData: String?
    var createdAt: Date
    var isRead: Bool

    init(
        id: UUID = UUID(),
        type: InsightType,
        title: String,
        message: String,
        actionLabel: String? = nil,
        actionData: String? = nil,
        createdAt: Date = Date(),
        isRead: Bool = false
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.message = message
        self.actionLabel = actionLabel
        self.actionData = actionData
        self.createdAt = createdAt
        self.isRead = isRead
    }
}

enum InsightType: String, Codable {
    case scheduleOptimization
    case bestTimeSlot
    case busyPrediction
    case dailyReport
    case taskBreakdown
    case focusSuggestion
    case conflictAlert
    case productivityTip

    var iconName: String {
        switch self {
        case .scheduleOptimization: return "wand.and.stars"
        case .bestTimeSlot: return "clock.fill"
        case .busyPrediction: return "chart.line.uptrend.xyaxis"
        case .dailyReport: return "doc.text.fill"
        case .taskBreakdown: return "list.bullet.rectangle"
        case .focusSuggestion: return "brain.head.profile"
        case .conflictAlert: return "exclamationmark.triangle.fill"
        case .productivityTip: return "lightbulb.fill"
        }
    }
}

// MARK: - User Settings Model

struct UserSettings: Codable {
    var theme: AppTheme
    var language: AppLanguage
    var workdayStartHour: Int
    var workdayEndHour: Int
    var workDays: [Int]  // 1=Monday, 7=Sunday
    var defaultReminder: EventReminder
    var focusModeEnabled: Bool
    var doNotDisturbEnabled: Bool
    var hapticFeedbackEnabled: Bool
    var soundEffectsEnabled: Bool
    var biometricEnabled: Bool
    var iCloudSyncEnabled: Bool
    var widgetSize: WidgetSize
    var accentColor: AccentColorOption
    var notificationsEnabled: Bool
    var morningBriefingHour: Int
    var morningBriefingMinute: Int
    var eveningReviewHour: Int
    var eveningReviewMinute: Int

    init(
        theme: AppTheme = .system,
        language: AppLanguage = .english,
        workdayStartHour: Int = 9,
        workdayEndHour: Int = 18,
        workDays: [Int] = [1, 2, 3, 4, 5],
        defaultReminder: EventReminder = .fifteenMinutes,
        focusModeEnabled: Bool = false,
        doNotDisturbEnabled: Bool = false,
        hapticFeedbackEnabled: Bool = true,
        soundEffectsEnabled: Bool = true,
        biometricEnabled: Bool = false,
        iCloudSyncEnabled: Bool = false,
        widgetSize: WidgetSize = .medium,
        accentColor: AccentColorOption = .violet,
        notificationsEnabled: Bool = true,
        morningBriefingHour: Int = 8,
        morningBriefingMinute: Int = 0,
        eveningReviewHour: Int = 21,
        eveningReviewMinute: Int = 0
    ) {
        self.theme = theme
        self.language = language
        self.workdayStartHour = workdayStartHour
        self.workdayEndHour = workdayEndHour
        self.workDays = workDays
        self.defaultReminder = defaultReminder
        self.focusModeEnabled = focusModeEnabled
        self.doNotDisturbEnabled = doNotDisturbEnabled
        self.hapticFeedbackEnabled = hapticFeedbackEnabled
        self.soundEffectsEnabled = soundEffectsEnabled
        self.biometricEnabled = biometricEnabled
        self.iCloudSyncEnabled = iCloudSyncEnabled
        self.widgetSize = widgetSize
        self.accentColor = accentColor
        self.notificationsEnabled = notificationsEnabled
        self.morningBriefingHour = morningBriefingHour
        self.morningBriefingMinute = morningBriefingMinute
        self.eveningReviewHour = eveningReviewHour
        self.eveningReviewMinute = eveningReviewMinute
    }
}

enum AppTheme: String, Codable, CaseIterable {
    case light
    case dark
    case system

    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "System"
        }
    }
}

enum AppLanguage: String, Codable, CaseIterable {
    case english
    case chinese

    var displayName: String {
        switch self {
        case .english: return "English"
        case .chinese: return "中文"
        }
    }
}

enum WidgetSize: String, Codable, CaseIterable {
    case small
    case medium
    case large

    var displayName: String {
        rawValue.capitalized
    }

    var widgetKind: String {
        switch self {
        case .small: return "DailyIQSmallWidget"
        case .medium: return "DailyIQWidget"
        case .large: return "DailyIQLargeWidget"
        }
    }
}

enum AccentColorOption: String, Codable, CaseIterable {
    case violet
    case mint
    case amber
    case blue

    var displayName: String {
        rawValue.capitalized
    }

    var hexColor: String {
        switch self {
        case .violet: return "#9B8FE8"
        case .mint: return "#6EE7B7"
        case .amber: return "#FCD34D"
        case .blue: return "#3B82F6"
        }
    }
}

// MARK: - Statistics Model

struct DailyStatistics: Codable {
    let date: Date
    var tasksCompleted: Int
    var tasksTotal: Int
    var focusMinutes: Int
    var energyLevel: Int
    var peakHour: Int?
    var completionRate: Double

    var taskCompletionRate: Double {
        guard tasksTotal > 0 else { return 0 }
        return Double(tasksCompleted) / Double(tasksTotal)
    }
}

struct WeeklyReport: Identifiable, Codable {
    let id: UUID
    let weekStartDate: Date
    var dailyStats: [DailyStatistics]
    var totalTasksCompleted: Int
    var totalFocusMinutes: Int
    var averageEnergyLevel: Int
    var weeklyScore: Int  // 0-100
    var topCategory: Category?
    var streakDays: Int
    var aiInsights: [String]

    init(
        id: UUID = UUID(),
        weekStartDate: Date,
        dailyStats: [DailyStatistics] = [],
        totalTasksCompleted: Int = 0,
        totalFocusMinutes: Int = 0,
        averageEnergyLevel: Int = 70,
        weeklyScore: Int = 0,
        topCategory: Category? = nil,
        streakDays: Int = 0,
        aiInsights: [String] = []
    ) {
        self.id = id
        self.weekStartDate = weekStartDate
        self.dailyStats = dailyStats
        self.totalTasksCompleted = totalTasksCompleted
        self.totalFocusMinutes = totalFocusMinutes
        self.averageEnergyLevel = averageEnergyLevel
        self.weeklyScore = weeklyScore
        self.topCategory = topCategory
        self.streakDays = streakDays
        self.aiInsights = aiInsights
    }
}

// MARK: - Achievement Model

struct Achievement: Identifiable, Codable {
    let id: UUID
    var type: AchievementType
    var title: String
    var description: String
    var unlockedAt: Date?
    var progress: Double

    init(
        id: UUID = UUID(),
        type: AchievementType,
        title: String,
        description: String,
        unlockedAt: Date? = nil,
        progress: Double = 0
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.description = description
        self.unlockedAt = unlockedAt
        self.progress = progress
    }

    var isUnlocked: Bool {
        unlockedAt != nil
    }
}

enum AchievementType: String, Codable {
    case firstTask
    case streak3Days
    case streak7Days
    case streak30Days
    case perfectDay
    case earlyBird
    case nightOwl
    case focusMaster
    case taskMaster
    case plannerPro

    var iconName: String {
        switch self {
        case .firstTask: return "star.fill"
        case .streak3Days: return "flame.fill"
        case .streak7Days: return "flame.fill"
        case .streak30Days: return "flame.fill"
        case .perfectDay: return "checkmark.seal.fill"
        case .earlyBird: return "sunrise.fill"
        case .nightOwl: return "moon.stars.fill"
        case .focusMaster: return "brain.head.profile"
        case .taskMaster: return "list.bullet.clipboard"
        case .plannerPro: return "calendar.badge.checkmark"
        }
    }
}

// MARK: - Widget Data Model

struct WidgetData: Codable {
    var date: Date
    var greeting: String
    var focusTimeRemaining: Int?
    var tasksToday: Int
    var tasksCompleted: Int
    var nextEvent: Event?
    var dailyScore: Int

    init(
        date: Date = Date(),
        greeting: String = "Good morning",
        focusTimeRemaining: Int? = nil,
        tasksToday: Int = 0,
        tasksCompleted: Int = 0,
        nextEvent: Event? = nil,
        dailyScore: Int = 0
    ) {
        self.date = date
        self.greeting = greeting
        self.focusTimeRemaining = focusTimeRemaining
        self.tasksToday = tasksToday
        self.tasksCompleted = tasksCompleted
        self.nextEvent = nextEvent
        self.dailyScore = dailyScore
    }
}
