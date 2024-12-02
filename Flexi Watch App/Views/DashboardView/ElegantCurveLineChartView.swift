//
//  ElegantCurveLineChartView.swift
//  Flexi
//
//  Created by Prince Yadav on 06/12/24.
//

import SwiftUI

struct ElegantCurveLineChartView: View {
    let data: [CGFloat]
    let frame: CGSize
    let colorScheme: ColorScheme
    @State private var animationProgress: CGFloat = 0
    @State private var floatingOffset: CGFloat = 0
    
    private var lineColor: Color {
        colorScheme == .dark
            ? Color(hex: "4ECDC4")
            : Color(hex: "2ECC71")
    }
    
    private func createCurvePath(with normalizedData: [CGPoint]) -> Path {
        Path { path in
            guard normalizedData.count > 1 else { return }
            
            path.move(to: normalizedData[0])
            
            for i in 1..<normalizedData.count {
                let previousPoint = normalizedData[i-1]
                let currentPoint = normalizedData[i]
                
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
    }
    
    var body: some View {
        GeometryReader { geometry in
            let chartHeight = geometry.size.height
            let normalizedData = normalizeData(data, in: chartHeight)
            
            ZStack {
                // Background Gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        lineColor.opacity(0.05),
                        Color.clear
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Floating Line Effect
                createCurvePath(with: normalizedData)
                    .trim(from: 0, to: animationProgress)
                    .stroke(
                        lineColor.opacity(0.1),
                        style: StrokeStyle(
                            lineWidth: 6,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .blur(radius: 4)
                    .offset(x: floatingOffset, y: floatingOffset)
                    .animation(
                        Animation.easeInOut(duration: 2)
                            .repeatForever(autoreverses: true)
                    )
                
                // Background Shadow Curve
                createCurvePath(with: normalizedData)
                    .trim(from: 0, to: animationProgress)
                    .stroke(
                        lineColor.opacity(0.1),
                        style: StrokeStyle(
                            lineWidth: 5,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
                    .blur(radius: 3)
                    .offset(x: 2, y: 2)
                
                // Main Chart Line
                Group {
                    // Shadow Effect
                    createCurvePath(with: normalizedData)
                        .trim(from: 0, to: animationProgress)
                        .stroke(
                            lineColor.opacity(0.2),
                            style: StrokeStyle(
                                lineWidth: 3,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                        .blur(radius: 2)
                        .offset(x: 1, y: 1)
                    
                    // Main Line
                    createCurvePath(with: normalizedData)
                        .trim(from: 0, to: animationProgress)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    lineColor.opacity(0.8),
                                    lineColor
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(
                                lineWidth: 2.5,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.2)) {
                animationProgress = 1.0
                floatingOffset = 2
            }
        }
    }
    
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
}

struct ElegantCurveLineChartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Light Mode Preview
            ElegantCurveLineChartView(
                data: [45, 60, 35, 80, 55, 70, 90],
                frame: CGSize(width: 300, height: 200),
                colorScheme: .light
            )
            .frame(height: 200)
            .padding()
            .previewDisplayName("Light Mode")
            
            // Dark Mode Preview
            ElegantCurveLineChartView(
                data: [45, 60, 35, 80, 55, 70, 90],
                frame: CGSize(width: 300, height: 200),
                colorScheme: .dark
            )
            .frame(height: 200)
            .padding()
            .previewDisplayName("Dark Mode")
            .preferredColorScheme(.dark)
            
            // Different Data Set Preview
            ElegantCurveLineChartView(
                data: [10, 30, 50, 40, 60, 20, 70, 90, 45],
                frame: CGSize(width: 300, height: 200),
                colorScheme: .light
            )
            .frame(height: 200)
            .padding()
            .previewDisplayName("Varied Data")
        }
        .previewLayout(.sizeThatFits)
    }
}
