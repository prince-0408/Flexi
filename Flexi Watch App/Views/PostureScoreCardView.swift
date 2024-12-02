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
        GeometryReader { geometry in
            ZStack {
                // Auto-adjusting background
                RoundedRectangle(cornerRadius: geometry.size.width * 0.1)
                    .fill(Color.gray.opacity(0.05))
                    .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
                
                // Content
                VStack(spacing: calculateSpacing(for: geometry.size.width)) {
                    // Header Section
                    headerSection
                    
                    // Circular Score Visualization
                    scoreVisualization
                }
                .padding(calculatePadding(for: geometry.size.width))
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                GeometryReader { innerGeo in
                    Color.clear.preference(key: SizePreferenceKey.self, value: innerGeo.size)
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) { size in
                self.cardSize = size
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(), value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        withAnimation {
                            isPressed = true
                        }
                    }
                    .onEnded { _ in
                        withAnimation {
                            isPressed = false
                            showDetails = true
                        }
                    }
            )
            .sheet(isPresented: $showDetails) {
                PostureDetailView(score: score)
                    .presentationDetents([.medium, .large])
            }
        }
        .frame(width: calculateCardWidth(), height: calculateCardWidth() * 1.1)
        .onAppear(perform: startAnimation)
    }
    
    // Adaptive sizing methods
    private func calculateSpacing(for width: CGFloat) -> CGFloat {
        return width * 0.06
    }
    
    private func calculatePadding(for width: CGFloat) -> CGFloat {
        return width * 0.08
    }
    
    private func calculateFontSize(baseSize: CGFloat) -> CGFloat {
        let scaleFactor = cardSize.width / 180 // Normalize against a base width
        return baseSize * scaleFactor
    }
    
    private func calculateLineWidth() -> CGFloat {
        return cardSize.width * 0.067
    }
    
    private func calculateCircleSize() -> CGFloat {
        return cardSize.width * 0.9
    }
    
    // Animation and interaction methods
    private func startAnimation() {
        withAnimation(.easeInOut(duration: 1.2)) {
            animationProgress = 1.0
        }
    }
    
    // Header Section with Adaptive Design
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Posture Health")
                    .font(.system(size: calculateFontSize(baseSize: 14)))
                    .fontWeight(.semibold)
                
                Text(scoreDescription)
                    .font(.system(size: calculateFontSize(baseSize: 12)))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button {
                showDetails = true
            } label: {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(scoreGradient)
                    .font(.system(size: calculateFontSize(baseSize: 20)))
                    .scaleEffect(isPressed ? 0.8 : 1.0)
                    .animation(.spring(), value: isPressed)
            }
        }
    }
    
    // Score Visualization with Adaptive Design
    private var scoreVisualization: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(scoreGradient.opacity(0.2), lineWidth: calculateLineWidth())
            
            // Progress Circle
            Circle()
                .trim(from: 0, to: CGFloat(animationProgress * min(score / 100, 1.0)))
                .stroke(
                    scoreGradient,
                    style: StrokeStyle(lineWidth: calculateLineWidth(), lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.2), value: animationProgress)
            
            // Score Text
            VStack(spacing: 2) {
                Text("\(Int(score))")
                    .font(.system(size: calculateFontSize(baseSize: 28), weight: .bold))
                    .foregroundStyle(scoreGradient)
                    .scaleEffect(animationProgress)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6), value: animationProgress)
                
                Text("SCORE")
                    .font(.system(size: calculateFontSize(baseSize: 10)))
                    .foregroundColor(.secondary)
                    .opacity(animationProgress)
                    .animation(.easeInOut(duration: 1.2), value: animationProgress)
            }
        }
        .frame(width: calculateCircleSize(), height: calculateCircleSize())
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
    

