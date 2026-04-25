import Foundation

class TodayViewModel {

    var dailySchedule: DailySchedule

    init() {
        self.dailySchedule = DailySchedule()
    }

    func generateDailySchedule() {
        // AI-driven daily planning logic
        // For demo, create sample tasks
        let today = Date()
        let calendar = Calendar.current

        var tasks: [Task] = [
            Task(title: "Review morning emails", estimatedMinutes: 30, priority: .p2, category: .work, energyRequired: .low),
            Task(title: "Deep work: Project planning", estimatedMinutes: 120, priority: .p1, category: .work, energyRequired: .high),
            Task(title: "Team standup meeting", estimatedMinutes: 30, priority: .p1, category: .work, energyRequired: .medium),
            Task(title: "30-minute workout", estimatedMinutes: 30, priority: .p2, category: .health, energyRequired: .medium),
            Task(title: "Read 'Atomic Habits' chapter", estimatedMinutes: 45, priority: .p3, category: .learning, energyRequired: .low),
            Task(title: "Lunch break", estimatedMinutes: 60, priority: .p3, category: .personal, energyRequired: .low),
            Task(title: "Client call: Q1 review", estimatedMinutes: 60, priority: .p0, category: .work, energyRequired: .high),
            Task(title: "Weekly planning for next week", estimatedMinutes: 45, priority: .p2, category: .work, energyRequired: .medium),
        ]

        var blocks: [TaskBlock] = []
        var currentHour = 9

        for task in tasks {
            let startTime = calendar.date(bySettingHour: currentHour, minute: 0, second: 0, of: today)!
            let endMinute = task.estimatedMinutes
            let endTime = calendar.date(byAddingMinute: endMinute, to: startTime)!

            let block = TaskBlock(
                task: task,
                startTime: startTime,
                endTime: endTime,
                energyLevel: 70
            )
            blocks.append(block)

            currentHour += (endMinute / 60) + 1
            if currentHour >= 18 { break }
        }

        let completedCount = blocks.filter { $0.task.status == .completed }.count

        self.dailySchedule = DailySchedule(
            date: today,
            taskBlocks: blocks,
            energyLevel: 75,
            completedTasks: completedCount,
            totalTasks: blocks.count
        )
    }

    func completeTask(_ blockId: UUID) {
        if let index = dailySchedule.taskBlocks.firstIndex(where: { $0.id == blockId }) {
            dailySchedule.taskBlocks[index].task.status = .completed
            dailySchedule.completedTasks += 1
        }
    }

    func deferTask(_ blockId: UUID) {
        if let index = dailySchedule.taskBlocks.firstIndex(where: { $0.id == blockId }) {
            dailySchedule.taskBlocks[index].task.status = .deferred
        }
    }

    func regenerateSchedule() {
        generateDailySchedule()
    }
}
