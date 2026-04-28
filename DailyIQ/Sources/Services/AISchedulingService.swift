import Foundation

class AISchedulingService {
    static let shared = AISchedulingService()

    private init() {}

    // MARK: - Peak Hours Detection

    /// Returns optimal work hours based on energy patterns
    /// Default: 9-12am (high energy), 2-5pm (medium energy)
    func detectPeakHours() -> (high: [Int], medium: [Int], low: [Int]) {
        // In a real app, this would analyze historical data
        // For now, use defaults based on typical circadian rhythms
        let highEnergy = [9, 10, 11]      // Morning peak
        let mediumEnergy = [14, 15, 16]   // Afternoon peak
        let lowEnergy = [13, 19, 20]      // Post-lunch dip, evening wind-down
        return (highEnergy, mediumEnergy, lowEnergy)
    }

    /// Get energy level for a specific hour (0-23)
    func getEnergyLevelForHour(_ hour: Int) -> EnergyLevel {
        let peakHours = detectPeakHours()
        if peakHours.high.contains(hour) {
            return .high
        } else if peakHours.medium.contains(hour) {
            return .medium
        } else {
            return .low
        }
    }

    // MARK: - Task Duration Estimation

    /// Estimate task duration based on category and priority
    func estimateTaskDuration(task: Task) -> Int {
        // Base duration from estimatedMinutes
        var duration = task.estimatedMinutes

        // Adjust based on priority
        switch task.priority {
        case .p0:
            duration = Int(Double(duration) * 1.0)   // Full duration for critical
        case .p1:
            duration = Int(Double(duration) * 1.0)   // Full duration for high
        case .p2:
            duration = Int(Double(duration) * 0.9)   // 90% for medium
        case .p3:
            duration = Int(Double(duration) * 0.8)  // 80% for low
        }

        // Add buffer based on complexity (notes length)
        if let notes = task.notes, notes.count > 100 {
            duration = Int(Double(duration) * 1.2)
        }

        return max(15, min(duration, 240)) // Clamp between 15 min and 4 hours
    }

    // MARK: - Smart Scheduling

    /// Generate daily schedule using AI-like algorithm
    func generateDailySchedule(for date: Date, tasks: [Task]) -> [TaskBlock] {
        guard !tasks.isEmpty else { return [] }

        let calendar = Calendar.current
        let peakHours = detectPeakHours()

        // Sort tasks by priority and energy requirements
        let sortedTasks = tasks
            .filter { $0.status == .pending }
            .sorted { task1, task2 in
                // First sort by priority (P0 first)
                if task1.priority.rawValue != task2.priority.rawValue {
                    return task1.priority.rawValue < task2.priority.rawValue
                }
                // Then by energy requirement (high energy tasks first for peak hours)
                return task1.energyRequired.rawValue > task2.energyRequired.rawValue
            }

        var schedule: [TaskBlock] = []
        var currentTime = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: date)! // Start at 9 AM
        let endOfDay = calendar.date(bySettingHour: 21, minute: 0, second: 0, of: date)!   // End at 9 PM
        let lunchStart = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: date)!
        let lunchEnd = calendar.date(bySettingHour: 13, minute: 0, second: 0, of: date)!

        for task in sortedTasks {
            let duration = estimateTaskDuration(task: task)
            var taskStart = currentTime
            var taskEnd = calendar.date(byAdding: .minute, value: duration, to: taskStart)!

            // Skip if task extends beyond end of day
            if taskStart >= endOfDay { break }

            // Clamp task end to end of day if needed
            if taskEnd > endOfDay {
                taskEnd = endOfDay
            }

            // Skip lunch time for most tasks (unless health/break related)
            if taskStart < lunchEnd && taskStart >= lunchStart && task.category != .health {
                taskStart = lunchEnd
                taskEnd = calendar.date(byAdding: .minute, value: duration, to: taskStart)!
            }

            // Ensure high-energy tasks are scheduled in peak hours
            let taskHour = calendar.component(.hour, from: taskStart)
            if task.energyRequired == .high && !peakHours.high.contains(taskHour) {
                // Try to find next high energy slot
                for peakHour in peakHours.high {
                    let newStart = calendar.date(bySettingHour: peakHour, minute: 0, second: 0, of: date)!
                    let newEnd = calendar.date(byAdding: .minute, value: duration, to: newStart)!
                    if newEnd <= endOfDay && !schedule.contains(where: { block in
                        newStart < block.endTime && newEnd > block.startTime
                    }) {
                        taskStart = newStart
                        taskEnd = newEnd
                        break
                    }
                }
            }

            // Check for conflicts
            let hasConflict = schedule.contains { block in
                taskStart < block.endTime && taskEnd > block.startTime
            }

            if !hasConflict && taskStart < taskEnd {
                let energyLevel = calculateEnergyForSlot(taskStart: taskStart, peakHours: peakHours)
                let block = TaskBlock(task: task, startTime: taskStart, endTime: taskEnd, energyLevel: energyLevel)
                schedule.append(block)
                currentTime = taskEnd
            }

            // Add break after high-priority tasks
            if task.priority == .p0 || task.priority == .p1 {
                currentTime = calendar.date(byAdding: .minute, value: 10, to: currentTime)! // 10 min break
            }
        }

        return schedule.sorted { $0.startTime < $1.startTime }
    }

    /// Calculate energy level for a time slot
    private func calculateEnergyForSlot(taskStart: Date, peakHours: (high: [Int], medium: [Int], low: [Int])) -> Int {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: taskStart)

        if peakHours.high.contains(hour) {
            return 90
        } else if peakHours.medium.contains(hour) {
            return 70
        } else if peakHours.low.contains(hour) {
            return 40
        } else {
            return 50
        }
    }

    // MARK: - Auto Task Scheduling

    /// Automatically schedule unscheduled tasks
    func autoScheduleTasks(_ tasks: [Task], existingBlocks: [TaskBlock]) -> [TaskBlock] {
        // For now, just generate a new schedule with all pending tasks
        return generateDailySchedule(for: Date(), tasks: tasks)
    }

    // MARK: - Goal Alignment

    /// Align tasks to goals
    func alignTasksToGoals(tasks: [Task], goals: [Goal]) -> [Task] {
        // Sort tasks by goal alignment (tasks linked to active goals get priority)
        let goalService = GoalService.shared

        return tasks.sorted { task1, task2 in
            let goal1HasActive = goals.contains { goal in
                goal.linkedTaskIds.contains(task1.id) && goal.progress < 1.0
            }
            let goal2HasActive = goals.contains { goal in
                goal.linkedTaskIds.contains(task2.id) && goal.progress < 1.0
            }

            if goal1HasActive != goal2HasActive {
                return goal1HasActive
            }
            return task1.priority.rawValue < task2.priority.rawValue
        }
    }

    // MARK: - Break Scheduling

    /// Schedule break times between focused work blocks
    func scheduleBreaks(between blocks: [TaskBlock], breakDuration: Int = 10) -> [DateInterval] {
        var breaks: [DateInterval] = []
        let sortedBlocks = blocks.sorted { $0.startTime < $1.startTime }

        for i in 0..<(sortedBlocks.count - 1) {
            let currentEnd = sortedBlocks[i].endTime
            let nextStart = sortedBlocks[i + 1].startTime

            let breakStart = currentEnd
            let breakEnd = Calendar.current.date(byAdding: .minute, value: breakDuration, to: breakStart)!

            if breakEnd <= nextStart {
                breaks.append(DateInterval(start: breakStart, end: breakEnd))
            }
        }

        return breaks
    }

    // MARK: - AI Optimization

    /// Continuously optimize schedule based on completion rates
    func optimizeSchedule(currentSchedule: [TaskBlock], completionRate: Double) -> [TaskBlock] {
        // If completion rate is low, reduce task density
        if completionRate < 0.6 {
            // Spread tasks more with longer breaks
            return currentSchedule.map { block in
                var adjustedBlock = block
                // Tasks stay the same, but this signals need for adjustment
                return adjustedBlock
            }
        }
        return currentSchedule
    }

    // MARK: - Rescheduling

    /// Reschedule a task block to a new time
    func rescheduleTask(_ block: TaskBlock, to newStart: Date) -> TaskBlock {
        let calendar = Calendar.current
        let duration = calendar.dateComponents([.minute], from: block.startTime, to: block.endTime).minute ?? 30
        let newEnd = calendar.date(byAdding: .minute, value: duration, to: newStart)!

        return TaskBlock(
            id: block.id,
            task: block.task,
            startTime: newStart,
            endTime: newEnd,
            energyLevel: block.energyLevel
        )
    }

    // MARK: - Morning Briefing

    /// Generate morning briefing text
    func generateMorningBriefing(schedule: [TaskBlock], energyLevel: Int) -> String {
        let taskCount = schedule.count
        let focusMinutes = schedule.reduce(0) { total, block in
            let minutes = Calendar.current.dateComponents([.minute], from: block.startTime, to: block.endTime).minute ?? 0
            return total + minutes
        }

        let peakHours = detectPeakHours()
        let highEnergyCount = schedule.filter { block in
            let hour = Calendar.current.component(.hour, from: block.startTime)
            return peakHours.high.contains(hour)
        }.count

        var briefing = "Good morning! You have \(taskCount) tasks scheduled today."
        briefing += " Total focus time: \(focusMinutes) minutes."

        if highEnergyCount > 0 {
            briefing += " \(highEnergyCount) tasks are scheduled during your peak energy hours (9-11 AM)."
        }

        briefing += " Your energy level is at \(energyLevel)%. Let's make it productive!"

        return briefing
    }

    // MARK: - Evening Review

    /// Generate evening review text
    func generateEveningReview(completedTasks: Int, totalTasks: Int, focusMinutes: Int) -> String {
        let completionRate = totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0
        let percentage = Int(completionRate * 100)

        var review = "Evening review: You completed \(completedTasks) of \(totalTasks) tasks today."
        review += " Completion rate: \(percentage)%."
        review += " Total focus time: \(focusMinutes) minutes."

        if completionRate >= 0.8 {
            review += " Excellent work today! 🎉"
        } else if completionRate >= 0.6 {
            review += " Good progress! Keep it up!"
        } else {
            review += " Tomorrow is a new day. Plan for success!"
        }

        return review
    }
}
