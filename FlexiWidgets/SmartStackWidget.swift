//
//  SmartStackWidget.swift
//  Flexi
//
//  Created by Prince Yadav on 11/05/26.
//
import WidgetKit
import SwiftUI

struct SmartStackEntry: TimelineEntry {
    let date: Date
    let message: String
    let routine: String
    let relevance: TimelineEntryRelevance?
}

struct SmartStackWidgetView: View {
    var entry: SmartStackEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "figure.stretch")
                    .foregroundColor(.blue)
                Text("Flexi")
                    .font(.caption2.bold())
                    .foregroundColor(.blue)
                Spacer()
            }
            
            Text(entry.message)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .lineLimit(2)
            
            Text("Try: \(entry.routine)")
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary)
        }
        .containerBackground(.blue.gradient.opacity(0.1), for: .widget)
    }
}

struct FlexiSmartStackProvider: TimelineProvider {
    func placeholder(in context: Context) -> SmartStackEntry {
        SmartStackEntry(date: Date(), message: "Ready to stretch?", routine: "Desk Relief", relevance: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SmartStackEntry) -> ()) {
        let entry = SmartStackEntry(date: Date(), message: "Ready to stretch?", routine: "Desk Relief", relevance: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SmartStackEntry>) -> ()) {
        var entries: [SmartStackEntry] = []
        let currentDate = Date()
        
        // Add an entry for now
        entries.append(SmartStackEntry(
            date: currentDate,
            message: "Keep standing tall",
            routine: "Posture Fix",
            relevance: nil
        ))
        
        // Add a relevant entry for 1 hour from now (simulating sedentary detection)
        let relevantDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
        entries.append(SmartStackEntry(
            date: relevantDate,
            message: "Time to move!",
            routine: "2-min Stretch",
            relevance: TimelineEntryRelevance(score: 100) // HIGH RELEVANCE
        ))

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
struct SmartStackWidget: Widget {
    let kind: String = "SmartStackWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FlexiSmartStackProvider()) { entry in
            SmartStackWidgetView(entry: entry)
        }
        .configurationDisplayName("Flexi Suggestion")
        .description("Proactive stretches for your workday.")
        .supportedFamilies([.accessoryRectangular])
    }
}
