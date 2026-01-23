//
//  LeftWidgets.swift
//  LeftWidgets
//
//  Created by Abhishek on 21/01/26.
//

import WidgetKit
import SwiftUI

// MARK: - App Group ID
private let appGroupId = "group.com.example.left"

// MARK: - Theme Colors (Purple theme)
struct WidgetTheme {
    /// Background color: #100E22
    static let background = Color(red: 16/255, green: 14/255, blue: 34/255)
    
    /// Active dot color: #9C82FF (purple)
    static let activeDot = Color(red: 156/255, green: 130/255, blue: 255/255)
    
    /// Inactive dot color: Same purple with 27% opacity (matching Flutter's withAlpha(69))
    static let inactiveDot = activeDot.opacity(Double(69) / 255.0)
    
    /// Text color for title
    static let titleText = Color.white
    
    /// Text color for subtitle
    static let subtitleText = Color.white.opacity(0.6)
}

// MARK: - Helper to read Int with actual default
private func readInt(from userDefaults: UserDefaults?, key: String, defaultValue: Int) -> Int {
    guard let userDefaults = userDefaults else { return defaultValue }
    // object(forKey:) returns nil if key doesn't exist
    if userDefaults.object(forKey: key) == nil {
        return defaultValue
    }
    return userDefaults.integer(forKey: key)
}

// MARK: - Widget Data Model
struct WidgetData {
    let title: String
    let subtitle: String
    let totalItems: Int
    let passedItems: Int
    
    /// Fetches monthly widget data from shared UserDefaults
    static func monthly() -> WidgetData {
        let userDefaults = UserDefaults(suiteName: appGroupId)
        
        // Calculate defaults based on current date
        let calendar = Calendar.current
        let now = Date()
        let defaultTotalDays = calendar.range(of: .day, in: .month, for: now)?.count ?? 31
        let defaultPassedDays = calendar.component(.day, from: now) - 1
        let defaultMonthName = now.formatted(.dateTime.month(.wide)).uppercased()
        
        let totalItems = readInt(from: userDefaults, key: "monthly_total_items", defaultValue: defaultTotalDays)
        let passedItems = readInt(from: userDefaults, key: "monthly_passed_items", defaultValue: defaultPassedDays)
        let daysLeft = totalItems - passedItems
        
        return WidgetData(
            title: userDefaults?.string(forKey: "monthly_title") ?? defaultMonthName,
            subtitle: "\(daysLeft) days left",
            totalItems: totalItems,
            passedItems: passedItems
        )
    }
    
    /// Fetches yearly widget data from shared UserDefaults
    static func yearly() -> WidgetData {
        let userDefaults = UserDefaults(suiteName: appGroupId)
        
        // Calculate defaults based on current date
        let calendar = Calendar.current
        let now = Date()
        let year = calendar.component(.year, from: now)
        let startOfYear = calendar.date(from: DateComponents(year: year, month: 1, day: 1))!
        let endOfYear = calendar.date(from: DateComponents(year: year, month: 12, day: 31))!
        let defaultTotalDays = calendar.dateComponents([.day], from: startOfYear, to: endOfYear).day! + 1
        let defaultPassedDays = calendar.ordinality(of: .day, in: .year, for: now)! - 1
        
        let totalItems = readInt(from: userDefaults, key: "yearly_total_items", defaultValue: defaultTotalDays)
        let passedItems = readInt(from: userDefaults, key: "yearly_passed_items", defaultValue: defaultPassedDays)
        let daysLeft = totalItems - passedItems
        
        return WidgetData(
            title: userDefaults?.string(forKey: "yearly_title") ?? String(year),
            subtitle: "\(daysLeft) days left",
            totalItems: totalItems,
            passedItems: passedItems
        )
    }
}

// MARK: - Timeline Entry
struct DotWidgetEntry: TimelineEntry {
    let date: Date
    let data: WidgetData
    let isYearly: Bool
}

// MARK: - Monthly Widget Provider
struct MonthlyProvider: TimelineProvider {
    func placeholder(in context: Context) -> DotWidgetEntry {
        DotWidgetEntry(date: Date(), data: WidgetData.monthly(), isYearly: false)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DotWidgetEntry) -> Void) {
        completion(DotWidgetEntry(date: Date(), data: WidgetData.monthly(), isYearly: false))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DotWidgetEntry>) -> Void) {
        let entry = DotWidgetEntry(date: Date(), data: WidgetData.monthly(), isYearly: false)
        // Update at midnight
        let nextUpdate = Calendar.current.startOfDay(for: Date()).addingTimeInterval(86400)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

// MARK: - Yearly Widget Provider
struct YearlyProvider: TimelineProvider {
    func placeholder(in context: Context) -> DotWidgetEntry {
        DotWidgetEntry(date: Date(), data: WidgetData.yearly(), isYearly: true)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (DotWidgetEntry) -> Void) {
        completion(DotWidgetEntry(date: Date(), data: WidgetData.yearly(), isYearly: true))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<DotWidgetEntry>) -> Void) {
        let entry = DotWidgetEntry(date: Date(), data: WidgetData.yearly(), isYearly: true)
        // Update at midnight
        let nextUpdate = Calendar.current.startOfDay(for: Date()).addingTimeInterval(86400)
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

// MARK: - Single Dot View
struct DotView: View {
    let isPassed: Bool
    let size: CGFloat
    
    var body: some View {
        Circle()
            .fill(isPassed ? WidgetTheme.inactiveDot : WidgetTheme.activeDot)
            .frame(width: size, height: size)
    }
}

// MARK: - Dots Grid View (Dynamic layout using GeometryReader)
struct DotsGridView: View {
    let totalItems: Int
    let passedItems: Int
    let dotSize: CGFloat
    let spacing: CGFloat
    
    /// Calculate columns based on available width
    private func columnsForWidth(_ width: CGFloat) -> Int {
        guard width > 0 else { return 10 } // Fallback if width is 0
        return max(1, Int((width + spacing) / (dotSize + spacing)))
    }
    
    /// Calculate rows based on columns
    private func rowsForColumns(_ columns: Int) -> Int {
        guard totalItems > 0, columns > 0 else { return 0 }
        return (totalItems + columns - 1) / columns
    }

    var body: some View {
        GeometryReader { geometry in
            let columns = columnsForWidth(geometry.size.width)
            let rows = rowsForColumns(columns)
            
            VStack(alignment: .center, spacing: spacing) {
                ForEach(0..<max(1, rows), id: \.self) { row in
                    HStack(spacing: spacing) {
                        ForEach(0..<columns, id: \.self) { col in
                            let index = row * columns + col
                            if index < totalItems {
                                DotView(isPassed: index < passedItems, size: dotSize)
                            } else {
                                // Empty space to maintain grid alignment
                                Color.clear
                                    .frame(width: dotSize, height: dotSize)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

// MARK: - Widget Entry View (Shared between Monthly and Yearly)
struct DotWidgetEntryView: View {
    var entry: DotWidgetEntry
    @Environment(\.widgetFamily) var family
    @Environment(\.colorScheme) var colorScheme
    
    /// Is this a small widget?
    var isSmall: Bool {
        family == .systemSmall
    }
    
    /// Is this a large widget?
    var isLarge: Bool {
        family == .systemLarge
    }
    
    /// Dot size based on widget type and size
    var dotSize: CGFloat {
        if entry.isYearly {
            // Yearly: larger dots for large widget
            return isLarge ? 7.6 : 4.5
        }
        return isSmall ? 12 : 16
    }
    
    /// Spacing between dots
    var spacing: CGFloat {
        if entry.isYearly {
            // Yearly: more spacing for large widget
            return isLarge ? 6 : 4
        }
        return isSmall ? 6 : 8
    }
    
    /// Font size for title
    var titleFontSize: CGFloat {
        if entry.isYearly && isLarge {
            return 22
        }
        return isSmall ? 13 : 16
    }

    var titleAndDotSpacing: CGFloat {
        if entry.isYearly && isLarge {
            return 24
        }
        return 16
    }
    
    /// Font size for subtitle
    var subtitleFontSize: CGFloat {
        if entry.isYearly && isLarge {
            return 14
        }
        return isSmall ? 10 : 12
    }
    
    /// Padding around content
    var contentPadding: CGFloat {
        if entry.isYearly {
            return isLarge ? 16 : 8
        }
        return isSmall ? 4 : 12
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer(minLength: 0)
            
            // Header Row: Title (left) + Days Left (right)
            HStack(alignment: .center) {
                Text(entry.data.title)
                    .font(.system(size: titleFontSize, weight: .bold))
                    .foregroundStyle(WidgetTheme.titleText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                
                Spacer()
                
                Text(entry.data.subtitle)
                    .font(.system(size: subtitleFontSize))
                    .foregroundStyle(WidgetTheme.subtitleText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .padding(.bottom, titleAndDotSpacing)
            
            // Dots Grid - dynamically adapts to available width
            DotsGridView(
                totalItems: entry.data.totalItems,
                passedItems: entry.data.passedItems,
                dotSize: dotSize,
                spacing: spacing
            )
            
            Spacer(minLength: 0)
        }
        .padding(contentPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(for: .widget){WidgetTheme.background}
        .unredacted() // Prevents placeholder gray bars
    }
}

// MARK: - Monthly Widget (Small & Medium only)
struct MonthlyWidget: Widget {
    let kind: String = "MonthlyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MonthlyProvider()) { entry in
            DotWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Monthly")
        .description("Track days passed in the current month")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Yearly Widget (Medium & Large)
struct YearlyWidget: Widget {
    let kind: String = "YearlyWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: YearlyProvider()) { entry in
            DotWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Yearly")
        .description("Track days passed in the current year")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

// MARK: - Previews
#Preview(as: .systemSmall) {
    MonthlyWidget()
} timeline: {
    DotWidgetEntry(date: .now, data: WidgetData.monthly(), isYearly: false)
}

#Preview(as: .systemMedium) {
    MonthlyWidget()
} timeline: {
    DotWidgetEntry(date: .now, data: WidgetData.monthly(), isYearly: false)
}

#Preview(as: .systemMedium) {
    YearlyWidget()
} timeline: {
    DotWidgetEntry(date: .now, data: WidgetData.yearly(), isYearly: true)
}

#Preview(as: .systemLarge) {
    YearlyWidget()
} timeline: {
    DotWidgetEntry(date: .now, data: WidgetData.yearly(), isYearly: true)
}
