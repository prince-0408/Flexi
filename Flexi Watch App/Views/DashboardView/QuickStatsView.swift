//
//  QuickStatsView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct QuickStatsView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    // Sample health data
    struct HealthStats {
        let steps: Int
        let calories: Int
        let activeTime: Int
        let heartRate: Int
    }
    
    private let stats = HealthStats(
        steps: 8500,
        calories: 420,
        activeTime: 45,
        heartRate: 72
    )
    
    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            statsCell(icon: "figure.walk", value: formatSteps(stats.steps), label: "STEPS", color: .green)
            statsCell(icon: "flame.fill", value: "\(stats.calories)", label: "KCAL", color: .orange)
            statsCell(icon: "timer", value: "\(stats.activeTime)", label: "MINS", color: .cyan)
            statsCell(icon: "heart.fill", value: "\(stats.heartRate)", label: "BPM", color: .pink)
        }
        .padding(8)
    }
    
    private func statsCell(icon: String, value: String, label: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 22, height: 22)
                    
                    Image(systemName: icon)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(color)
                }
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(value)
                    .font(DesignSystem.bodyText)
                    .fontWeight(.bold)
                    .foregroundColor(.white) // Explicit white for contrast
                
                Text(label)
                    .font(DesignSystem.captionText)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.6)) // High contrast secondary
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(Color.white.opacity(0.06))
        .cornerRadius(12)
    }
    
    private func formatSteps(_ steps: Int) -> String {
        steps >= 1000
            ? String(format: "%.1fK", Double(steps) / 1000)
            : "\(steps)"
    }
}

struct QuickStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            QuickStatsView()
                .glassyCard()
                .padding()
        }
    }
}
