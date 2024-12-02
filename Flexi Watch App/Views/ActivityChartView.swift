//
//  ActivityChartView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//


import SwiftUI

struct ActivityLineChartView: View {
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
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Activity")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(Int(lineData.last?.value ?? 0))%")
                    .font(.caption)
                    .fontWeight(.bold)
            }
            
            GeometryReader { geometry in
                ZStack {
                    SimpleGridBackground()
                    
                    ElegantCurveLineChartView(
                        data: lineData.map { $0.value },
                        frame: geometry.size,
                        colorScheme: colorScheme
                    )
                }
            }
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark
                    ? Color.black.opacity(0.2)
                    : Color.gray.opacity(0.1)
                )
        )
    }
}

struct ElegantCurveLineChartView: View {
    let data: [CGFloat]
    let frame: CGSize
    let colorScheme: ColorScheme
    
    var body: some View {
        GeometryReader { geometry in
            let chartWidth = geometry.size.width
            let chartHeight = geometry.size.height
            
            // Prepare data points
            let normalizedData = normalizeData(data, in: chartHeight)
            
            // Main Curve Path
            Path { path in
                guard normalizedData.count > 1 else { return }
                
                path.move(to: normalizedData[0])
                
                // Create smooth Bézier curves
                for i in 1..<normalizedData.count {
                    let previousPoint = normalizedData[i-1]
                    let currentPoint = normalizedData[i]
                    
                    // Calculate control points for smooth curve
                    let controlPoint1 = CGPoint(
                        x: (previousPoint.x + currentPoint.x) / 2,
                        y: previousPoint.y
                    )
                    
                    let controlPoint2 = CGPoint(
                        x: (previousPoint.x + currentPoint.x) / 2,
                        y: currentPoint.y
                    )
                    
                    path.addCurve(
                        to: currentPoint,
                        control1: controlPoint1,
                        control2: controlPoint2
                    )
                }
            }
            .stroke(
                lineColor,
                style: StrokeStyle(
                    lineWidth: 3,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
            
            // Gradient Fill
            Path { path in
                guard normalizedData.count > 1 else { return }
                
                path.move(to: normalizedData[0])
                
                // Create smooth Bézier curves
                for i in 1..<normalizedData.count {
                    let previousPoint = normalizedData[i-1]
                    let currentPoint = normalizedData[i]
                    
                    // Calculate control points for smooth curve
                    let controlPoint1 = CGPoint(
                        x: (previousPoint.x + currentPoint.x) / 2,
                        y: previousPoint.y
                    )
                    
                    let controlPoint2 = CGPoint(
                        x: (previousPoint.x + currentPoint.x) / 2,
                        y: currentPoint.y
                    )
                    
                    path.addCurve(
                        to: currentPoint,
                        control1: controlPoint1,
                        control2: controlPoint2
                    )
                }
                
                // Close the path for gradient fill
                path.addLine(to: CGPoint(x: normalizedData.last!.x, y: chartHeight))
                path.addLine(to: CGPoint(x: normalizedData.first!.x, y: chartHeight))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        lineColor.opacity(0.3),
                        lineColor.opacity(0.1),
                        lineColor.opacity(0.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Data Points
            ForEach(normalizedData.indices, id: \.self) { index in
                Circle()
                    .fill(lineColor)
                    .frame(width: 6, height: 6)
                    .position(normalizedData[index])
            }
        }
    }
    
    // Normalize data to chart height
    private func normalizeData(_ data: [CGFloat], in height: CGFloat) -> [CGPoint] {
        guard !data.isEmpty else { return [] }
        
        let min = data.min() ?? 0
        let max = data.max() ?? 0
        let range = max - min
        
        return data.enumerated().map { (index, value) in
            CGPoint(
                x: CGFloat(index) * (frame.width / CGFloat(data.count - 1)),
                y: height - ((value - min) / range * height)
            )
        }
    }
    
    // Dynamic line color based on color scheme
    private var lineColor: Color {
        colorScheme == .dark
            ? Color(hex: "4ECDC4")
            : Color(hex: "2ECC71")
    }
}

// Simplified Grid Background
struct SimpleGridBackground: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                // Minimal vertical lines
                for i in 0...2 {
                    let x = CGFloat(i) * (geometry.size.width / 2)
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                
                // Minimal horizontal lines
                for i in 0...2 {
                    let y = CGFloat(i) * (geometry.size.height / 2)
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
            }
            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        }
    }
}



// Preview for Elegant Curve Graph
struct ActivityLineChartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActivityLineChartView()
                .preferredColorScheme(.light)
                .previewDevice("Apple Watch Series 6 - 44mm")
            
            ActivityLineChartView()
                .preferredColorScheme(.dark)
                .previewDevice("Apple Watch Series 6 - 44mm")
        }
    }
}
