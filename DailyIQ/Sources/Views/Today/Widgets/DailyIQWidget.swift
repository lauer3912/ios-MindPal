import WidgetKit
import SwiftUI

// MARK: - Widget Entry

struct DailyIQEntry: TimelineEntry {
    let date: Date
    let energyLevel: Int
    let completedTasks: Int
    let totalTasks: Int
    let nextTaskTitle: String?
    let nextTaskTime: String?
    let streak: Int
}

// MARK: - Timeline Provider

struct DailyIQProvider: TimelineProvider {
    func placeholder(in context: Context) -> DailyIQEntry {
        DailyIQEntry(
            date: Date(),
            energyLevel: 75,
            completedTasks: 3,
            totalTasks: 8,
            nextTaskTitle: "Team standup",
            nextTaskTime: "9:00 AM",
            streak: 5
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (DailyIQEntry) -> Void) {
        let entry = placeholder(in: context)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DailyIQEntry>) -> Void) {
        let entry = loadCurrentData()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func loadCurrentData() -> DailyIQEntry {
        let sharedDefaults = UserDefaults(suiteName: "group.com.ggsheng.DailyIQ")

        let energyLevel = sharedDefaults?.integer(forKey: "widget_energy_level") ?? 70
        let completedTasks = sharedDefaults?.integer(forKey: "widget_completed_tasks") ?? 0
        let totalTasks = sharedDefaults?.integer(forKey: "widget_total_tasks") ?? 0
        let nextTaskTitle = sharedDefaults?.string(forKey: "widget_next_task_title")
        let nextTaskTime = sharedDefaults?.string(forKey: "widget_next_task_time")
        let streak = sharedDefaults?.integer(forKey: "widget_streak") ?? 0

        return DailyIQEntry(
            date: Date(),
            energyLevel: energyLevel,
            completedTasks: completedTasks,
            totalTasks: totalTasks,
            nextTaskTitle: nextTaskTitle,
            nextTaskTime: nextTaskTime,
            streak: streak
        )
    }
}

// MARK: - Widget Views

struct DailyIQWidgetEntryView: View {
    var entry: DailyIQEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(entry: entry)
        case .systemMedium:
            MediumWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

struct SmallWidgetView: View {
    let entry: DailyIQEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 6)
                    Circle()
                        .trim(from: 0, to: CGFloat(entry.energyLevel) / 100)
                        .stroke(Color.green, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Text("\(entry.energyLevel)%")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                .frame(width: 50, height: 50)

                Spacer()

                VStack(alignment: .trailing) {
                    Text("\(entry.streak)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                    Text("day streak")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            VStack(alignment: .leading, spacing: 4) {
                Text("Today's Progress")
                    .font(.caption)
                    .foregroundColor(.secondary)

                HStack {
                    Text("\(entry.completedTasks)/\(entry.totalTasks)")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Text("tasks")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                ProgressView(value: Double(entry.completedTasks), total: Double(max(entry.totalTasks, 1)))
                    .tint(.blue)
            }
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct MediumWidgetView: View {
    let entry: DailyIQEntry

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Energy")
                    .font(.caption)
                    .foregroundColor(.secondary)

                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                    Circle()
                        .trim(from: 0, to: CGFloat(entry.energyLevel) / 100)
                        .stroke(energyColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    VStack(spacing: 0) {
                        Text("\(entry.energyLevel)%")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                        Text("energy")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(width: 80, height: 80)

                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(entry.streak) day streak")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 8) {
                Text("Up Next")
                    .font(.caption)
                    .foregroundColor(.secondary)

                if let title = entry.nextTaskTitle, let time = entry.nextTaskTime {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .lineLimit(2)

                    HStack {
                        Image(systemName: "clock")
                            .font(.caption)
                        Text(time)
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                } else {
                    Text("No upcoming tasks")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Text("Progress: \(entry.completedTasks)/\(entry.totalTasks)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                ProgressView(value: Double(entry.completedTasks), total: Double(max(entry.totalTasks, 1)))
                    .tint(.blue)
            }

            Spacer()
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private var energyColor: Color {
        if entry.energyLevel >= 70 {
            return .green
        } else if entry.energyLevel >= 40 {
            return .yellow
        } else {
            return .red
        }
    }
}

// MARK: - Widget Configuration

struct DailyIQWidget: Widget {
    let kind: String = "DailyIQWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyIQProvider()) { entry in
            DailyIQWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("DailyIQ")
        .description("Track your daily productivity and energy.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Widget Bundle

@main
struct DailyIQWidgetBundle: WidgetBundle {
    var body: some Widget {
        DailyIQWidget()
    }
}

// MARK: - Previews

#if DEBUG
@available(iOS 17.0, *)
#Preview(as: .systemSmall) {
    DailyIQWidget()
} timeline: {
    DailyIQEntry(
        date: Date(),
        energyLevel: 75,
        completedTasks: 3,
        totalTasks: 8,
        nextTaskTitle: "Team standup",
        nextTaskTime: "9:00 AM",
        streak: 5
    )
}

@available(iOS 17.0, *)
#Preview(as: .systemMedium) {
    DailyIQWidget()
} timeline: {
    DailyIQEntry(
        date: Date(),
        energyLevel: 75,
        completedTasks: 3,
        totalTasks: 8,
        nextTaskTitle: "Team standup meeting",
        nextTaskTime: "9:00 AM",
        streak: 5
    )
}
#endif
