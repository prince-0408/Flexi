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
            VStack(spacing: 12) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text("Posture Insights")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Your Posture Performance")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Time Period Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(TimePeriod.allCases, id: \.self) { period in
                            Button(action: {
                                withAnimation(.smooth) {
                                    selectedTimePeriod = period
                                }
                            }) {
                                Text(period.rawValue)
                                    .font(.caption)
                                    .foregroundColor(selectedTimePeriod == period ? .white : .gray)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedTimePeriod == period
                                        ? LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.blue.opacity(0.7),
                                                Color.blue.opacity(0.5)
                                            ]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                        : LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.gray.opacity(0.2),
                                                Color.gray.opacity(0.1)
                                            ]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .cornerRadius(20)
                                    .shadow(color: selectedTimePeriod == period ? .blue.opacity(0.3) : .clear, radius: 5, x: 0, y: 2)
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
                                    scoreColor(reading.score).opacity(0.7),
                                    scoreColor(reading.score).opacity(0.3)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        
                        PointMark(
                            x: .value("Date", reading.timestamp),
                            y: .value("Score", reading.score)
                        )
                        .foregroundStyle(scoreColor(reading.score))
                    }
                    .frame(height: 120)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.gray.opacity(0.1),
                                    Color.gray.opacity(0.05)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                )
                .padding(.horizontal)
                
                // Performance Metrics
                HStack(spacing: 10) {
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
                
                // Motivational Message
                Text(motivationalText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .background(Color.black)
    }
    
    private var motivationalText: String {
        let avgScore = summaryStatistics.averageScore
        switch avgScore {
        case 80...100:
            return "Excellent posture! Keep up the great work! 🏆"
        case 50...79:
            return "You're improving. Small steps make big differences! 💪"
        default:
            return "Let's focus on your posture and make progress! 🌟"
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: Int
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption2)
                .foregroundColor(.gray)
            
            Text("\(value)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            color.opacity(0.1),
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .cornerRadius(10)
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

