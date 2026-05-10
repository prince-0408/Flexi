//
//  CurrentExerciseView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct CurrentExerciseView: View {
    let exercises: [StretchExercise]
    let currentIndex: Int
    let isInProgress: Bool
    let remainingTime: Int
    let backgroundColor: Color?
    let primaryTextColor: Color
    let secondaryTextColor: Color
    let accentColor: Color
    let progressColor: Color
    
    @State private var animationPhase: CGFloat = 0

    var body: some View {
        VStack(spacing: 16) {
            // Hero Visual Section
            ZStack {
                // Outer Volumetric Glow
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [.blue.opacity(0.3), .clear]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 60
                        )
                    )
                    .scaleEffect(1.0 + (animationPhase * 0.2))
                
                // Progress Ring
                Circle()
                    .stroke(Color.white.opacity(0.1), lineWidth: 6)
                    .frame(width: 110, height: 110)
                
                Circle()
                    .trim(from: 0, to: CGFloat(remainingTime) / 30.0) // Assuming 30s base for visualization
                    .stroke(
                        LinearGradient(gradient: Gradient(colors: [.blue, .cyan]), startPoint: .top, endPoint: .bottom),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 110, height: 110)
                    .rotationEffect(.degrees(-90))
                
                // Exercise Icon (Floating)
                if !exercises.isEmpty {
                    Image(systemName: exercises[currentIndex].icon)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .offset(y: -50)
                        .shadow(color: .blue.opacity(0.5), radius: 10)
                }
                
                // Massive Timer
                VStack(spacing: -4) {
                    Text("\(remainingTime)")
                        .font(DesignSystem.massiveMetric)
                        .foregroundColor(.white)
                        .contentTransition(.numericText())
                    
                    Text("SECONDS")
                        .font(DesignSystem.captionText)
                        .fontWeight(.black)
                        .foregroundColor(.white.opacity(0.4))
                }
            }
            .padding(.top, 20)
            
            // Info Section
            if !exercises.isEmpty {
                VStack(spacing: 4) {
                    Text(exercises[currentIndex].name.uppercased())
                        .font(DesignSystem.sectionHeader)
                        .foregroundColor(.white)
                    
                    Text(exercises[currentIndex].description)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                animationPhase = 1
            }
        }
    }
}

struct CurrentExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            CurrentExerciseView(
                exercises: StretchRoutine.beginner.exercises,
                currentIndex: 0,
                isInProgress: true,
                remainingTime: 25,
                backgroundColor: .clear,
                primaryTextColor: .white,
                secondaryTextColor: .gray,
                accentColor: .blue,
                progressColor: .blue
            )
        }
    }
}
