//
//  StretchControlButtonsView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct StretchControlButtonsView: View {
    @Binding var isInProgress: Bool
       @Binding var currentExerciseIndex: Int
       let routine: StretchRoutine
       @Binding var remainingTime: Int
       let backgroundColor: Color?
       let accentColor: Color
       let primaryTextColor: Color
    
    var body: some View {
        HStack(spacing: 20) {
            // Previous Exercise Button
            Button(action: {
                currentExerciseIndex = (currentExerciseIndex - 1 + routine.exercises.count) % routine.exercises.count
                remainingTime = routine.exercises[currentExerciseIndex].duration
            }) {
                Image(systemName: "backward.fill")
                    .foregroundColor(.blue)
            }
            .disabled(isInProgress)
            
            // Start/Pause Button
            Button(action: {
                isInProgress.toggle()
                if isInProgress {
                    remainingTime = routine.exercises[currentExerciseIndex].duration
                }
            }) {
                Image(systemName: isInProgress ? "pause.fill" : "play.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Circle())
            }
            
            // Next Exercise Button
            Button(action: {
                currentExerciseIndex = (currentExerciseIndex + 1) % routine.exercises.count
                remainingTime = routine.exercises[currentExerciseIndex].duration
            }) {
                Image(systemName: "forward.fill")
                    .foregroundColor(.blue)
            }
            .disabled(isInProgress)
        }
    }
}
