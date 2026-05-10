//
//  CurrentExerciseView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct CurrentExerciseView: View {
    let routineType: StretchRoutineType
        let currentIndex: Int
        let isInProgress: Bool
        let remainingTime: Int
        let backgroundColor: Color?
        let primaryTextColor: Color
        let secondaryTextColor: Color
        let accentColor: Color
        let progressColor: Color
    @State private var isBreathing = false

    var body: some View {
        VStack(spacing: 10) {
            // Exercise Image - Reduced size for watch
            Image(systemName: routineType.exercises[currentIndex].icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
            
            // Exercise Details - More compact typography
            Text(routineType.exercises[currentIndex].name)
                .font(.footnote)
                .fontWeight(.semibold)
            
            Text(routineType.exercises[currentIndex].description)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(3) // Prevent text overflow
            
            // Timer - Massive ADA Typography
            if isInProgress {
                Text("\(remainingTime)")
                    .font(.system(size: 60, weight: .heavy, design: .rounded))
                    .contentTransition(.numericText())
                    .foregroundColor(.blue)
                    .scaleEffect(isBreathing ? 1.1 : 0.95)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                            isBreathing = true
                        }
                    }
                    .onDisappear {
                        isBreathing = false
                    }
            }
        }
        .padding(8) // Reduced padding
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10) // Slightly smaller corner radius
        .frame(maxWidth: .infinity) // Ensure full width on watch
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(routineType.exercises[currentIndex].name)
        .accessibilityValue(isInProgress ? "\(remainingTime) seconds remaining. \(routineType.exercises[currentIndex].description)" : routineType.exercises[currentIndex].description)
    }
}
