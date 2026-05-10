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
            Button(action: {
                currentExerciseIndex = (currentExerciseIndex - 1 + routine.exercises.count) % routine.exercises.count
                remainingTime = routine.exercises[currentExerciseIndex].duration
            }) {
                Image(systemName: "backward.fill")
                    .foregroundColor(.blue)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(isInProgress)
            
            Button(action: {
                isInProgress.toggle()
                if isInProgress {
                    remainingTime = routine.exercises[currentExerciseIndex].duration
                }
            }) {
                Image(systemName: isInProgress ? "pause.fill" : "play.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding(15)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue.opacity(0.3), lineWidth: 1))
            }
            .buttonStyle(PlainButtonStyle())
            .applyPrimaryHandGesture()
            
            Button(action: {
                currentExerciseIndex = (currentExerciseIndex + 1) % routine.exercises.count
                remainingTime = routine.exercises[currentExerciseIndex].duration
            }) {
                Image(systemName: "forward.fill")
                    .foregroundColor(.blue)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(isInProgress)
        }
    }
}

@available(watchOS 11.0, *)
struct PrimaryGestureModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.handGestureShortcut(.primaryAction)
    }
}

extension View {
    @ViewBuilder
    func applyPrimaryHandGesture() -> some View {
        if #available(watchOS 11.0, *) {
            self.modifier(PrimaryGestureModifier())
        } else {
            self
        }
    }
}
