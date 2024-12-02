//
//  PostureInsightsView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI
struct PostureInsightsView: View {
    @StateObject private var analysis = PostureAnalysisModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Detailed Posture Insights")
                .font(.headline)
            
            HStack {
                Image(systemName: analysis.overallPostureStatus == .good ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                    .foregroundColor(analysis.overallPostureStatus == .good ? .green : .red)
                
                Text(analysis.postureStatusDescription)
                    .font(.subheadline)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                InsightRowView(
                    icon: "arrow.up.and.down",
                    title: "Average Pitch",
                    value: String(format: "%.2f°", analysis.averagePitch)
                )
                
                InsightRowView(
                    icon: "rotate.3d",
                    title: "Average Roll",
                    value: String(format: "%.2f°", analysis.averageRoll)
                )
                
                InsightRowView(
                    icon: "timer",
                    title: "Poor Posture Duration",
                    value: analysis.poorPostureDuration
                )
            }
        }
        .onAppear {
            analysis.startContinuousTracking()
        }
        .onDisappear {
            analysis.stopTracking()
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}

#Preview {
    PostureInsightsView()
}
