//
//  PostureScoreWidget.swift
//  Flexi
//
//  Created by Prince Yadav on 11/05/26.
//
import WidgetKit
import SwiftUI

struct PostureEntry: TimelineEntry {
    let date: Date
    let score: Int
    let relevance: TimelineEntryRelevance?
}

struct PostureScoreWidgetView: View {
    var entry: PostureEntry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        switch family {
        case .accessoryCircular:
            CircularScoreView(score: entry.score)
        case .accessoryCorner:
            CornerScoreView(score: entry.score)
        default:
            CircularScoreView(score: entry.score)
        }
    }
}

struct CircularScoreView: View {
    let score: Int
    
    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            
            Gauge(value: Double(score), in: 0...100) {
                Text("POSTURE")
            } currentValueLabel: {
                Text("\(score)")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            }
            .gaugeStyle(.accessoryCircular)
            .tint(scoreGradient)
        }
    }
    
    var scoreGradient: Gradient {
        if score > 80 {
            return Gradient(colors: [.blue, .cyan])
        } else if score > 50 {
            return Gradient(colors: [.orange, .yellow])
        } else {
            return Gradient(colors: [.red, .orange])
        }
    }
}

struct CornerScoreView: View {
    let score: Int
    
    var body: some View {
        Image(systemName: "figure.stand")
            .font(.title.bold())
            .widgetAccentable()
            .widgetLabel {
                Text("POSTURE: \(score)%")
            }
    }
}
struct PostureScoreWidget: Widget {
    let kind: String = "PostureScoreWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PostureProvider()) { entry in
            PostureScoreWidgetView(entry: entry)
        }
        .configurationDisplayName("Posture Score")
        .description("Track your real-time posture health.")
        .supportedFamilies([.accessoryCircular, .accessoryCorner, .accessoryInline])
    }
}

struct PostureProvider: TimelineProvider {
    func placeholder(in context: Context) -> PostureEntry {
        PostureEntry(date: Date(), score: 85, relevance: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (PostureEntry) -> ()) {
        completion(PostureEntry(date: Date(), score: 85, relevance: nil) )
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<PostureEntry>) -> ()) {
        let sharedDefaults = UserDefaults(suiteName: "group.com.prince.Flexi")
        let score = sharedDefaults?.integer(forKey: "currentPostureScore") ?? 100
        
        let entries = [PostureEntry(date: Date(), score: score, relevance: nil)]
        completion(Timeline(entries: entries, policy: .atEnd))
    }
}
