import WidgetKit
import SwiftUI

let appGroup = "group.com.udhaya.internshipcountdown"

private func defaultEnd() -> Date {
    var c = DateComponents()
    c.year = 2026; c.month = 12; c.day = 15
    return Calendar.current.date(from: c) ?? Date()
}

struct CountdownEntry: TimelineEntry {
    let date: Date
    let daysLeft: Int
    let endDate: Date
    let label: String
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> CountdownEntry {
        make(ConfigurationAppIntent(), Date())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> CountdownEntry {
        make(configuration, Date())
    }

    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<CountdownEntry> {
        let now = Date()
        // Refresh just after midnight so the number drops by 1 each day
        let next = Calendar.current.nextDate(
            after: now, matching: DateComponents(hour: 0, minute: 1),
            matchingPolicy: .nextTime)!
        return Timeline(entries: [make(configuration, now)], policy: .after(next))
    }

    private func make(_ config: ConfigurationAppIntent, _ date: Date) -> CountdownEntry {
        var end = config.endDate
        var label = config.label
        if config.useAppSettings {
            let defaults = UserDefaults(suiteName: appGroup)
            end = defaults?.object(forKey: "endDate") as? Date ?? defaultEnd()
            label = defaults?.string(forKey: "label") ?? "Internship ends"
        }
        let cal = Calendar.current
        let days = cal.dateComponents([.day],
                                      from: cal.startOfDay(for: date),
                                      to: cal.startOfDay(for: end)).day ?? 0
        return CountdownEntry(date: date, daysLeft: max(days, 0), endDate: end, label: label)
    }
}

struct CountdownView: View {
    let entry: CountdownEntry
    @Environment(\.widgetFamily) private var family

    // Ring fills as the end date gets closer (scale: last 100 days)
    private var progress: Double {
        1 - min(Double(entry.daysLeft), 100) / 100
    }

    private var hasLabel: Bool {
        !entry.label.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private var ring: some View {
        ZStack {
            Circle().stroke(Color.orange.opacity(0.2), lineWidth: 5)
            Circle()
                .trim(from: 0, to: max(progress, 0.03))
                .stroke(Color.orange, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.9, dampingFraction: 0.75), value: progress)
        }
        .frame(width: 28, height: 28)
    }

    private var number: some View {
        Text("\(entry.daysLeft)")
            .font(.system(size: family == .systemMedium ? 110 : 92, weight: .semibold, design: .rounded))
            .minimumScaleFactor(0.5)
            .lineLimit(1)
            .contentTransition(.numericText(value: Double(entry.daysLeft)))
            .animation(.spring, value: entry.daysLeft)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                if hasLabel {
                    Text(entry.label.uppercased())
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.orange)
                        .lineLimit(2)
                }
                Spacer(minLength: 0)
                ring
            }
            Spacer(minLength: 0)
            number
            HStack(spacing: 4) {
                Text(entry.daysLeft == 1 ? "day left" : "days left")
                    .font(.system(size: 15, weight: .semibold))
                Text("· " + entry.endDate.formatted(.dateTime.month(.abbreviated).day()))
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.secondary)
            }
            .lineLimit(1)
            .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .containerBackground(.background, for: .widget)
    }
}

struct Countdown: Widget {
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: "InternshipCountdown",
                               intent: ConfigurationAppIntent.self,
                               provider: Provider()) { entry in
            CountdownView(entry: entry)
        }
        .configurationDisplayName("Countdown")
        .description("Days left until your date. Tap to edit in the app, or long-press to edit here.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
