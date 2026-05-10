//
//  PostureTrendChartView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//


import SwiftUI
import Charts

struct PostureTrendChartView: View {
    let postureData: [PostureReading]
    @State private var selectedTimePeriod: TimePeriod = .weekly

    enum TimePeriod: String, CaseIterable {
        case weekly = "Week"
        case monthly = "Month"
        case yearly = "Year"
    }
    
    private var filteredPostureData: [PostureReading] {
        let now = Date()
        switch selectedTimePeriod {
        case .weekly:
            return postureData.filter { $0.timestamp.timeIntervalSince(now) >= -7 * 24 * 60 * 60 }
        case .monthly:
            return postureData.filter { $0.timestamp.timeIntervalSince(now) >= -30 * 24 * 60 * 60 }
        case .yearly:
            return postureData.filter { $0.timestamp.timeIntervalSince(now) >= -365 * 24 * 60 * 60 }
        }
    }
    
    private func scoreColor(_ score: Double) -> Color {
        switch score {
        case 80...100: return .green
        case 50...79: return .yellow
        default: return .red
        }
    }
    
    private var summaryStatistics: (bestReading: PostureReading?,
                                    worstReading: PostureReading?,
                                    averageScore: Double) {
        guard !filteredPostureData.isEmpty else {
            return (nil, nil, 0)
        }
        
        let bestReading = filteredPostureData.max(by: { $0.score < $1.score })
        let worstReading = filteredPostureData.min(by: { $0.score < $1.score })
        let averageScore = filteredPostureData.reduce(0) { $0 + $1.score } / Double(filteredPostureData.count)
        
        return (bestReading, worstReading, averageScore)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("TREND ANALYSIS")
                        .font(DesignSystem.sectionHeader)
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text("Posture Performance")
                        .font(DesignSystem.primaryTitle)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Time Period Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(TimePeriod.allCases, id: \.self) { period in
                            Button(action: {
                                withAnimation(.spring()) {
                                    selectedTimePeriod = period
                                }
                            }) {
                                Text(period.rawValue)
                                    .font(DesignSystem.captionText)
                                    .fontWeight(.bold)
                                    .foregroundColor(selectedTimePeriod == period ? .white : .white.opacity(0.4))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedTimePeriod == period ? .blue : .white.opacity(0.1))
                                    .cornerRadius(20)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Floating Trend Chart
                VStack {
                    Chart(filteredPostureData) { reading in
                        LineMark(
                            x: .value("Date", reading.timestamp),
                            y: .value("Score", reading.score)
                        )
                        .interpolationMethod(.cardinal)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    scoreColor(reading.score),
                                    scoreColor(reading.score).opacity(0.2)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    }
                    .frame(height: 100)
                }
                .padding(12)
                .glassyCard()
                .padding(.horizontal)
                
                // Performance Metrics
                HStack(spacing: 8) {
                    MetricCard(
                        title: "Best",
                        value: Int(summaryStatistics.bestReading?.score ?? 0),
                        color: .green
                    )
                    
                    MetricCard(
                        title: "Avg",
                        value: Int(summaryStatistics.averageScore),
                        color: .blue
                    )
                    
                    MetricCard(
                        title: "Worst",
                        value: Int(summaryStatistics.worstReading?.score ?? 0),
                        color: .red
                    )
                }
                .padding(.horizontal)
            }
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title.uppercased())
                .font(DesignSystem.captionText)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.4))
            
            Text("\(value)")
                .font(DesignSystem.bodyText)
                .fontWeight(.heavy)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(.white.opacity(0.05))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
    }
}


struct PostureTrendChartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Good Posture Scenario
            PostureTrendChartView(postureData: goodPostureData)
                .previewDisplayName("Good Posture")
            
            // Poor Posture Scenario
            PostureTrendChartView(postureData: poorPostureData)
                .previewDisplayName("Poor Posture")
            
            // Mixed Posture Scenario
            PostureTrendChartView(postureData: mixedPostureData)
                .previewDisplayName("Mixed Posture")
        }
    }
}

var goodPostureData: [PostureReading] {
    (0..<7).map { index in
        PostureReading(
            id: UUID(),
            timestamp: Date().addingTimeInterval(Double(-index) * 24 * 60 * 60),
            pitch: Double.random(in: 0.01...0.1),
            roll: Double.random(in: 0.01...0.1),
            yaw: Double.random(in: 0.01...0.1)
        )
    }
}

var poorPostureData: [PostureReading] {
    (0..<7).map { index in
        PostureReading(
            id: UUID(),
            timestamp: Date().addingTimeInterval(Double(-index) * 24 * 60 * 60),
            pitch: Double.random(in: 0.5...1.0),
            roll: Double.random(in: 0.5...1.0),
            yaw: Double.random(in: 0.5...1.0)
        )
    }
}

var mixedPostureData: [PostureReading] {
    (0..<7).map { index in
        PostureReading(
            id: UUID(),
            timestamp: Date().addingTimeInterval(Double(-index) * 24 * 60 * 60),
            pitch: Double.random(in: 0.1...0.8),
            roll: Double.random(in: 0.1...0.8),
            yaw: Double.random(in: 0.1...0.8)
        )
    }
}

