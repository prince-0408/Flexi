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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("POSTURE INSIGHTS")
                    .font(DesignSystem.sectionHeader)
                    .foregroundColor(.white.opacity(0.6))
                Spacer()
                Image(systemName: analysis.overallPostureStatus == .good ? "checkmark.seal.fill" : "exclamationmark.shield.fill")
                    .foregroundColor(analysis.overallPostureStatus == .good ? .green : .orange)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                insightRow(
                    icon: "arrow.up.and.down",
                    title: "Avg Pitch",
                    value: String(format: "%.1f°", analysis.averagePitch),
                    color: .blue
                )
                
                insightRow(
                    icon: "rotate.3d",
                    title: "Avg Roll",
                    value: String(format: "%.1f°", analysis.averageRoll),
                    color: .purple
                )
                
                insightRow(
                    icon: "timer",
                    title: "Poor Time",
                    value: analysis.poorPostureDuration,
                    color: .orange
                )
            }
        }
        .padding(12)
        .background(.white.opacity(0.02))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.1), lineWidth: 1))
    }
    
    private struct MetricCard: View {
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
    
    private func insightRow(icon: String, title: String, value: String, color: Color) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 28, height: 28)
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(DesignSystem.captionText)
                    .foregroundColor(.white.opacity(0.5))
                Text(value)
                    .font(DesignSystem.bodyText)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding(8)
        .background(.white.opacity(0.04))
        .cornerRadius(12)
    }
}

#Preview {
    PostureInsightsView()
}
