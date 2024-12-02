//
//  StretchRoutineView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//

import SwiftUI

struct StretchRoutineView: View {
    @State private var selectedRoutine: StretchRoutine
    @State private var currentExerciseIndex = 0
    @State private var isExerciseInProgress = false
    @State private var remainingTime = 0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Routine Selector
                RoutineSelectorView(selectedRoutine: $selectedRoutine)
                
                // Current Exercise Display
                CurrentExerciseView(
                    routineType: mapToStretchRoutineType(selectedRoutine),
                    currentIndex: currentExerciseIndex,
                    isInProgress: isExerciseInProgress,
                    remainingTime: remainingTime
                )
                
                // Control Buttons
                StretchControlButtonsView(
                    isInProgress: $isExerciseInProgress,
                    currentExerciseIndex: $currentExerciseIndex,
                    routine: selectedRoutine,
                    remainingTime: $remainingTime
                )
            }
            .padding()
            .navigationTitle("Stretch Routines")
        }
        .onReceive(timer) { _ in
            updateExerciseTimer()
        }
    }
    
    // Add this function inside the struct
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
            // Move to next exercise
            moveToNextExercise()
        }
    }
    
    private func moveToNextExercise() {
        let exerciseCount = selectedRoutine.exercises.count
        currentExerciseIndex = (currentExerciseIndex + 1) % exerciseCount
        remainingTime = selectedRoutine.exercises[currentExerciseIndex].duration
    }
}
