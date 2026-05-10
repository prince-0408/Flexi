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
    let exercises: [StretchExercise]
    @Binding var remainingTime: Int
    let backgroundColor: Color?
    let accentColor: Color
    let primaryTextColor: Color
    
    var body: some View {
        HStack(spacing: 28) {
            // Previous Button
            ControlOrb(icon: "backward.fill", size: 38) {
                if currentExerciseIndex > 0 {
                    currentExerciseIndex -= 1
                    remainingTime = exercises[currentExerciseIndex].duration
                    HapticManager.shared.playImpact()
                }
            }
            
            // Play/Pause Button
            ControlOrb(icon: isInProgress ? "pause.fill" : "play.fill", size: 56, isPrimary: true) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isInProgress.toggle()
                    if isInProgress {
                        HapticManager.shared.playStart()
                    } else {
                        HapticManager.shared.playStop()
                    }
                }
            }
            
            // Next Button
            ControlOrb(icon: "forward.fill", size: 38) {
                if currentExerciseIndex < exercises.count - 1 {
                    currentExerciseIndex += 1
                    remainingTime = exercises[currentExerciseIndex].duration
                    HapticManager.shared.playImpact()
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct ControlOrb: View {
    let icon: String
    let size: CGFloat
    var isPrimary: Bool = false
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // The Orb Base - FIXED: No more square backgrounds
                Circle()
                    .fill(.white.opacity(isPrimary ? 0.15 : 0.08))
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [.white.opacity(0.5), .clear]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                
                // Pure Luminous Center Glow (only for primary)
                if isPrimary {
                    Circle()
                        .fill(RadialGradient(
                            gradient: Gradient(colors: [.blue.opacity(0.2), .clear]),
                            center: .center,
                            startRadius: 0,
                            endRadius: size / 2
                        ))
                        .blur(radius: 4)
                }
                
                // Icon - Cleaner White
                Image(systemName: icon)
                    .font(.system(size: size * (icon.contains("play") ? 0.45 : 0.4), weight: .black))
                    .foregroundColor(.white)
            }
            .frame(width: size, height: size)
            .scaleEffect(isPressed ? 0.85 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

struct StretchControlButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            StretchControlButtonsView(
                isInProgress: .constant(true),
                currentExerciseIndex: .constant(0),
                exercises: StretchRoutine.beginner.exercises,
                remainingTime: .constant(30),
                backgroundColor: .clear,
                accentColor: .blue,
                primaryTextColor: .white
            )
        }
    }
}
