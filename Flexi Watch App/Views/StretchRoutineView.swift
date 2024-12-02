//
//  StretchRoutineView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//

import SwiftUI

struct StretchRoutineView: View {
    @State public var selectedRoutine: StretchRoutine
    @State private var currentExerciseIndex = 0
    @State private var isExerciseInProgress = false
    @State private var remainingTime = 0
    @Environment(\.colorScheme) private var colorScheme
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Advanced Color Theme with Gradients
    struct ColorTheme {
        let backgroundGradient: LinearGradient
        let cardBackgroundGradient: LinearGradient
        let primaryTextColor: Color
        let secondaryTextColor: Color
        let accentColor: Color
        let progressColor: Color
        let shadowColor: Color
        
        static func theme(for colorScheme: ColorScheme) -> ColorTheme {
            switch colorScheme {
            case .dark:
                return ColorTheme(
                    backgroundGradient: LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.1, green: 0.1, blue: 0.15),
                            Color(red: 0.15, green: 0.15, blue: 0.2)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    cardBackgroundGradient: LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.2, green: 0.2, blue: 0.25),
                            Color(red: 0.18, green: 0.18, blue: 0.22)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    primaryTextColor: .white,
                    secondaryTextColor: Color.white.opacity(0.7),
                    accentColor: Color.blue.opacity(0.8),
                    progressColor: Color.green.opacity(0.8),
                    shadowColor: .clear
                )
            case .light:
                return ColorTheme(
                    backgroundGradient: LinearGradient(
                        gradient: Gradient(colors: [
                            Color(red: 0.95, green: 0.95, blue: 0.97),
                            Color(red: 0.98, green: 0.98, blue: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    cardBackgroundGradient: LinearGradient(
                        gradient: Gradient(colors: [
                            .white,
                            Color(red: 0.98, green: 0.98, blue: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    primaryTextColor: Color(red: 0.2, green: 0.2, blue: 0.2),
                    secondaryTextColor: Color(red: 0.4, green: 0.4, blue: 0.4),
                    accentColor: Color.blue,
                    progressColor: Color.green,
                    shadowColor: .gray.opacity(0.2)
                )
            @unknown default:
                return theme(for: .light)
            }
        }
    }
    
    // Computed color theme
    private var colorTheme: ColorTheme {
        ColorTheme.theme(for: colorScheme)
    }
    
    var body: some View {
        ZStack {
            // Background Gradient
            colorTheme.backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    // Routine Selector
                    RoutineSelectorView(
                        selectedRoutine: $selectedRoutine,
                        backgroundColor: .clear,
                        textColor: colorTheme.primaryTextColor
                    )                   .background(colorTheme.cardBackgroundGradient)
                    .cornerRadius(20)
                    .shadow(color: colorTheme.shadowColor, radius: 10, x: 0, y: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(colorTheme.accentColor.opacity(0.3), lineWidth: 1)
                    )
                    
                    // Current Exercise Display
                    CurrentExerciseView(
                        routineType: mapToStretchRoutineType(selectedRoutine),
                        currentIndex: currentExerciseIndex,
                        isInProgress: isExerciseInProgress,
                        remainingTime: remainingTime,
                        backgroundColor: Color.clear,
                        primaryTextColor: colorTheme.primaryTextColor,
                        secondaryTextColor: colorTheme.secondaryTextColor,
                        accentColor: colorTheme.accentColor,
                        progressColor: colorTheme.progressColor
                    )
                    .background(colorTheme.cardBackgroundGradient)
                    .cornerRadius(20)
                    .shadow(color: colorTheme.shadowColor, radius: 10, x: 0, y: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(colorTheme.accentColor.opacity(0.3), lineWidth: 1)
                    )
                    
                    // Control Buttons
                    StretchControlButtonsView(
                        isInProgress: $isExerciseInProgress,
                        currentExerciseIndex: $currentExerciseIndex,
                        routine: selectedRoutine,
                        remainingTime: $remainingTime,
                        backgroundColor: Color.clear,
                        accentColor: colorTheme.accentColor,
                        primaryTextColor: colorTheme.primaryTextColor
                    )
                    .background(colorTheme.cardBackgroundGradient)
                    .cornerRadius(20)
                    .shadow(color: colorTheme.shadowColor, radius: 10, x: 0, y: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(colorTheme.accentColor.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding()
                .navigationTitle("Stretch Routines")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onReceive(timer) { _ in
            updateExerciseTimer()
        }
    }
    
    // Existing methods remain the same
    private func mapToStretchRoutineType(_ routine: StretchRoutine) -> StretchRoutineType {
        switch routine {
        case .beginner: return .beginner
        case .intermediate: return .intermediate
        case .advanced: return .advanced
        }
    }
    
    private func updateExerciseTimer() {
        guard isExerciseInProgress else { return }
        
        if remainingTime > 0 {
            remainingTime -= 1
        } else {
            moveToNextExercise()
        }
    }
    
    private func moveToNextExercise() {
        let exerciseCount = selectedRoutine.exercises.count
        currentExerciseIndex = (currentExerciseIndex + 1) % exerciseCount
        remainingTime = selectedRoutine.exercises[currentExerciseIndex].duration
    }
}

extension LinearGradient {
    static var clear: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.clear, Color.clear]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// Previews
#Preview("Light Mode") {
    NavigationView {
        StretchRoutineView(selectedRoutine: .beginner)
            .environment(\.colorScheme, .light)
    }
}

#Preview("Dark Mode") {
    NavigationView {
        StretchRoutineView(selectedRoutine: .beginner)
            .environment(\.colorScheme, .dark)
    }
}
