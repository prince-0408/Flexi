//
//  ActivityChartView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//

import SwiftUI

struct ActivityLineChartView: View {
    @State private var isFlipped = false
    @Environment(\.colorScheme) private var colorScheme
    
    struct LineData {
        let date: Date
        let value: CGFloat
    }
    
    let lineData: [LineData] = [
        LineData(date: Date(), value: 50),
        LineData(date: Date().addingTimeInterval(86400), value: 70),
        LineData(date: Date().addingTimeInterval(172800), value: 65),
        LineData(date: Date().addingTimeInterval(259200), value: 60),
        LineData(date: Date().addingTimeInterval(345600), value: 70)
    ]
    
    var body: some View {
        ZStack {
            // Front View (Chart)
            frontView
                .opacity(isFlipped ? 0 : 1)
            
            // Back View (Details)
            backView
                .opacity(isFlipped ? 1 : 0)
        }
        .rotation3DEffect(
            Angle(degrees: isFlipped ? 180 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
        .onTapGesture {
            withAnimation(.spring()) {
                isFlipped.toggle()
            }
        }
    }
    
    private var frontView: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Minimal Header
            HStack {
                Text("Activity")
                    .font(.headline)
                
                Spacer()
                
                Text("\(Int(lineData.last?.value ?? 0))%")
                    .font(.subheadline)
                    .foregroundColor(accentColor)
            }
            
            // Simplified Chart
            GeometryReader { geometry in
                ZStack {
                    
                    // Main Line
                    ElegantCurveLineChartView(
                        data: lineData.map { $0.value },
                        frame: geometry.size,
                        colorScheme: colorScheme
                    )
                    
                    // Minimal Date Labels
                    VStack {
                        Spacer()
                        HStack(spacing: 0) {
                            ForEach(lineData.indices, id: \.self) { index in
                                Text(formatDate(lineData[index].date))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            .frame(height: 100)
        }
        .padding(10)
        .background(cardBackground)
        .rotation3DEffect(
            Angle(degrees: isFlipped ? 180 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
    }
    
    private var backView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Activity Details")
                .font(.headline)
            
            Divider()
            
            DetailRow(icon: "calendar", title: "Total Days", value: "5 Days")
            DetailRow(icon: "timer", title: "Average", value: "\(calculateAverage())%")
            DetailRow(icon: "chart.line.uptrend.xyaxis", title: "Highest", value: "\(findHighest())%")
            DetailRow(icon: "arrow.down", title: "Lowest", value: "\(findLowest())%")
        }
        .padding(10)
        .background(cardBackground)
        .rotation3DEffect(
            Angle(degrees: isFlipped ? 180 : 0),
            axis: (x: 0.0, y: 1.0, z: 0.0)
        )
    }
    
    private func DetailRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(accentColor)
                .frame(width: 25)
            
            Text(title)
                .font(.subheadline)
            
            Spacer()
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private func calculateAverage() -> Int {
        let total = lineData.reduce(0) { $0 + $1.value }
        return Int(total / CGFloat(lineData.count))
    }
    
    private func findHighest() -> Int {
        return Int(lineData.map { $0.value }.max() ?? 0)
    }
    
    private func findLowest() -> Int {
        return Int(lineData.map { $0.value }.min() ?? 0)
    }
    
    // Existing helper methods...
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
    
    private var accentColor: Color {
        colorScheme == .dark
            ? Color(hex: "4ECDC4")
            : Color(hex: "2ECC71")
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(backgroundColor)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private var backgroundColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.05)
            : Color.white
    }
}

// Preview for Elegant Curve Graph
struct ActivityLineChartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActivityLineChartView()
                .colorScheme(.dark)
            
            
            ActivityLineChartView()
                .colorScheme(.light)
        }
    }
}
