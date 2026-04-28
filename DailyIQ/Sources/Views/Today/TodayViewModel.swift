import Foundation

class TodayViewModel {

    var dailySchedule: DailySchedule
    private let taskService = TaskService.shared
    private let aiSchedulingService = AISchedulingService.shared

    init() {
        self.dailySchedule = DailySchedule()
    }

    func generateDailySchedule() {
        // Get pending tasks from database
        let pendingTasks = taskService.getPendingTasks()

        // Use AI scheduling service to generate optimized schedule
        let scheduleDate = Date()
        var blocks = aiSchedulingService.generateDailySchedule(for: scheduleDate, tasks: pendingTasks)

        // If no tasks, create sample data for demo purposes
        if blocks.isEmpty {
            blocks = createSampleSchedule()
        }

        // Calculate completion stats
        let completedTasks = blocks.filter { $0.task.status == .completed }.count
        let totalTasks = blocks.count

        // Calculate current energy level (average of scheduled blocks)
        let avgEnergy = blocks.isEmpty ? 70 : blocks.reduce(0) { $0 + $1.energyLevel } / blocks.count

        self.dailySchedule = DailySchedule(
            date: scheduleDate,
            taskBlocks: blocks,
            energyLevel: avgEnergy,
            completedTasks: completedTasks,
            totalTasks: totalTasks
        )
    }

    func completeTask(_ blockId: UUID) {
        // Update in database
        if let block = dailySchedule.taskBlocks.first(where: { $0.id == blockId }) {
            taskService.completeTask(block.task.id)
        }

        // Update local state
        if let index = dailySchedule.taskBlocks.firstIndex(where: { $0.id == blockId }) {
            dailySchedule.taskBlocks[index].task.status = .completed
            dailySchedule.completedTasks += 1
        }
    }

    func deferTask(_ blockId: UUID) {
        // Update in database
        if let block = dailySchedule.taskBlocks.first(where: { $0.id == blockId }) {
            let tomorrow = Date().adding(days: 1)
            taskService.deferTask(block.task.id, to: tomorrow)
        }

        // Update local state
        if let index = dailySchedule.taskBlocks.firstIndex(where: { $0.id == blockId }) {
            dailySchedule.taskBlocks[index].task.status = .deferred
            // Remove from today's schedule
            dailySchedule.taskBlocks.remove(at: index)
            dailySchedule.totalTasks -= 1
        }
    }

    func rescheduleTask(_ blockId: UUID, to newStart: Date) {
        if let index = dailySchedule.taskBlocks.firstIndex(where: { $0.id == blockId }) {
            let oldBlock = dailySchedule.taskBlocks[index]
            let newBlock = aiSchedulingService.rescheduleTask(oldBlock, to: newStart)
            dailySchedule.taskBlocks[index] = newBlock
        }
    }

    func regenerateSchedule() {
        generateDailySchedule()
    }

    func getMorningBriefing() -> String {
        return aiSchedulingService.generateMorningBriefing(
            schedule: dailySchedule.taskBlocks,
            energyLevel: dailySchedule.energyLevel
        )
    }

    func getEveningReview() -> String {
        let completedMinutes = dailySchedule.taskBlocks
            .filter { $0.task.status == .completed }
            .reduce(0) { total, block in
                let minutes = Calendar.current.dateComponents([.minute], from: block.startTime, to: block.endTime).minute ?? 0
                return total + minutes
            }

        return aiSchedulingService.generateEveningReview(
            completedTasks: dailySchedule.completedTasks,
            totalTasks: dailySchedule.totalTasks,
            focusMinutes: completedMinutes
        )
    }

    // MARK: - Sample Data for Demo

    private func createSampleSchedule() -> [TaskBlock] {
        let today = Date()
        let calendar = Calendar.current

        let sampleTasks: [(String, Int, Priority, Category, EnergyLevel)] = [
            ("Review morning emails", 30, .p2, .work, .low),
            ("Deep work: Project planning", 120, .p1, .work, .high),
            ("Team standup meeting", 30, .p1, .work, .medium),
            ("30-minute workout", 30, .p2, .health, .medium),
            ("Read book chapter", 45, .p3, .learning, .low),
            ("Client call: Q1 review", 60, .p0, .work, .high),
            ("Weekly planning", 45, .p2, .work, .medium),
        ]

        var blocks: [TaskBlock] = []
        var currentHour = 9

        for (title, minutes, priority, category, energy) in sampleTasks {
            let startTime = calendar.date(bySettingHour: currentHour, minute: 0, second: 0, of: today)!
            let endTime = calendar.date(byAdding: .minute, value: minutes, to: startTime)!

            let task = Task(
                title: title,
                estimatedMinutes: minutes,
                priority: priority,
                category: category,
                energyRequired: energy,
                status: .pending
            )

            let block = TaskBlock(
                task: task,
                startTime: startTime,
                endTime: endTime,
                energyLevel: 70
            )
            blocks.append(block)

            currentHour += (minutes / 60) + 1
            if currentHour >= 18 { break }
        }

        return blocks
    }
}
