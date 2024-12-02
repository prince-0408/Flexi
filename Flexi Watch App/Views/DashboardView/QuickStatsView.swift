//
//  QuickStatsGridView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct QuickStatsView: View {
    @Environment(\.colorScheme) private var colorScheme
    let watchSize: WatchSize
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.95, green: 0.95, blue: 0.97)
    }
    
    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : .black.opacity(0.8)
    }
    
    // Enum to define different watch sizes
    enum WatchSize {
        case small, medium, large
        
        var gridColumns: [GridItem] {
            [
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8)
            ]
        }
        
        var padding: CGFloat {
            switch self {
            case .small: return 4
            case .medium: return 6
            case .large: return 8
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .small: return 10
            case .medium: return 12
            case .large: return 14
            }
        }
    }
    
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
    
    init(watchSize: WatchSize = .medium) {
        self.watchSize = watchSize
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CustomBackgroundView(geometry: geometry, colorScheme: colorScheme)
                .edgesIgnoringSafeArea(.all)

                content
            }
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 1)
        }
    }
    
    private var content: some View {
        LazyVGrid(columns: watchSize.gridColumns, spacing: 8) {
            statsItem(
                icon: "figure.walk",
                title: "Steps",
                value: formatSteps(stats.steps),
                color: .green
            )
            
            statsItem(
                icon: "flame",
                title: "Calories",
                value: "\(stats.calories)",
                color: .red
            )
            
            statsItem(
                icon: "timer",
                title: "Active",
                value: "\(stats.activeTime)m",
                color: .blue
            )
            
            statsItem(
                icon: "heart",
                title: "HR",
                value: "\(stats.heartRate)",
                color: .pink
            )
        }
        .padding(8)
    }
    
    private func statsItem(
        icon: String,
        title: String,
        value: String,
        color: Color
    ) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: watchSize.fontSize + 2, weight: .semibold))
            
            Text(value)
                .font(.system(size: watchSize.fontSize, weight: .bold))
                .foregroundColor(.primary)
            
            Text(title)
                .font(.system(size: watchSize.fontSize - 2, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(colorScheme == .dark
                      ? Color.white.opacity(0.05)
                      : Color.black.opacity(0.05))
        )
        .cornerRadius(10)
    }
    
    private func formatSteps(_ steps: Int) -> String {
        steps >= 1000
            ? String(format: "%.1fK", Double(steps) / 1000)
            : "\(steps)"
    }
}


    
    struct QuickStatsView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                
                QuickStatsView(watchSize: .medium)
                    .preferredColorScheme(.light)
                    .previewDisplayName("Medium - Light")
                
                // Dark mode previews
                
                QuickStatsView(watchSize: .medium)
                    .preferredColorScheme(.dark)
                    .previewDisplayName("Medium - Dark")
                
            }
            .previewLayout(.sizeThatFits)
        }
    }

