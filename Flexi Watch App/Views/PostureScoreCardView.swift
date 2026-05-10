//
//  PostureScoreCardView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//

import SwiftUI

struct PostureScoreCardView: View {
    let score: Double
    @State private var showDetails = false
    @State private var animationProgress: CGFloat = 0
    @State private var isPressed = false
    @State private var cardSize: CGSize = .zero
    
    // Dynamic sizing with auto-adjustment
    private func calculateCardWidth() -> CGFloat {
        let screenWidth = WKInterfaceDevice.current().screenBounds.width
        let screenHeight = WKInterfaceDevice.current().screenBounds.height
        
        // Base sizing logic with dynamic scaling
        let baseWidth = screenWidth * 0.9
        let baseHeight = screenHeight * 0.4
        
        // Device-specific adjustments
        switch (screenWidth, screenHeight) {
        case (184, 194):   // 40mm Watch
            return baseWidth * 0.85
        case (196, 206):   // 41mm Watch
            return baseWidth * 0.9
        case (209, 220):   // 42mm Watch
            return baseWidth
        case (221, 232):   // 45mm Watch
            return baseWidth * 1.05
        case (237, 250):   // 49mm Watch
            return baseWidth * 1.15
        default:
            return baseWidth
        }
    }
    
    // Adaptive gradient based on score
    private var scoreGradient: LinearGradient {
        switch score {
        case 70...100:
            return LinearGradient(
                gradient: Gradient(colors: [.green.opacity(0.7), .green]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 50..<70:
            return LinearGradient(
                gradient: Gradient(colors: [.orange.opacity(0.7), .orange]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                gradient: Gradient(colors: [.red.opacity(0.7), .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    // Adaptive score description
    private var scoreDescription: String {
        switch score {
        case 80...100: return "Excellent Posture"
        case 60..<80: return "Good Posture"
        case 40..<60: return "Needs Improvement"
        default: return "Poor Posture"
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text("CURRENT SCORE")
                        .font(DesignSystem.sectionHeader)
                        .foregroundColor(.white.opacity(0.6))
                    
                    Text(scoreDescription)
                        .font(DesignSystem.bodyText)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                Spacer()
                ZStack {
                    Circle()
                        .fill(scoreGradient.opacity(0.1))
                        .frame(width: 32, height: 32)
                    Image(systemName: score >= 70 ? "star.fill" : "exclamationmark.triangle.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(score >= 70 ? .green : .orange)
                }
            }
            
            ZStack {
                // Background Track
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 8)
                
                // Progress Track
                Circle()
                    .trim(from: 0, to: animationProgress * (score / 100))
                    .stroke(
                        scoreGradient,
                        style: StrokeStyle(lineWidth: 8, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                // Score Text
                VStack(spacing: -4) {
                    Text("\(Int(score))")
                        .font(DesignSystem.massiveMetric)
                        .foregroundColor(.white)
                    Text("%")
                        .font(DesignSystem.captionText)
                        .fontWeight(.black)
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            .frame(width: 100, height: 100)
            .padding(.vertical, 8)
        }
        .padding(16)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                animationProgress = 1.0
            }
        }
    }
}

// Preference Key for Size Tracking
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}
    
    struct PostureScoreCardView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                // 40mm Watch
                PostureScoreCardView(score: 75)
                    .previewDevice("Apple Watch Series 7 - 40mm")
                
                // 45mm Watch
                PostureScoreCardView(score: 85)
                    .previewDevice("Apple Watch Series 7 - 45mm")
                    .colorScheme(.dark)
                
                // 49mm Watch
                PostureScoreCardView(score: 65)
                    .previewDevice("Apple Watch Ultra")
                    .colorScheme(.light)
            }
        }
    }
    

