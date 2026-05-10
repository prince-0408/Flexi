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
    @State private var showExerciseList = false
    @State private var routineExercises: [StretchExercise] = []
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var healthManager: HealthManager
    
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
            return ColorTheme(
                backgroundGradient: LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black,
                        Color.black
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                ),
                cardBackgroundGradient: LinearGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.1),
                        Color.white.opacity(0.05)
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
        }
    }
    
    // Computed color theme
    private var colorTheme: ColorTheme {
        ColorTheme.theme(for: colorScheme)
    }
    
    var body: some View {
        ZStack {
            // Background Gradient
            Color.clear
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 28) {
                    // Routine Selector (3D Cover Flow)
                    RoutineSelectorView(
                        selectedRoutine: $selectedRoutine
                    )
                    
                    // Immersive Active Session
                    CurrentExerciseView(
                        exercises: routineExercises,
                        currentIndex: currentExerciseIndex,
                        isInProgress: isExerciseInProgress,
                        remainingTime: remainingTime,
                        backgroundColor: Color.clear,
                        primaryTextColor: colorTheme.primaryTextColor,
                        secondaryTextColor: colorTheme.secondaryTextColor,
                        accentColor: colorTheme.accentColor,
                        progressColor: colorTheme.progressColor
                    )
                    
                    // Control Orbs
                    VStack(spacing: 12) {
                        StretchControlButtonsView(
                            isInProgress: $isExerciseInProgress,
                            currentExerciseIndex: $currentExerciseIndex,
                            exercises: routineExercises,
                            remainingTime: $remainingTime,
                            backgroundColor: Color.clear,
                            accentColor: colorTheme.accentColor,
                            primaryTextColor: colorTheme.primaryTextColor
                        )
                        
                        // Auxiliary Actions
                        HStack(spacing: 16) {
                            Button(action: {
                                withAnimation(.spring()) {
                                    routineExercises.shuffle()
                                    currentExerciseIndex = 0
                                    remainingTime = routineExercises[0].duration
                                }
                            }) {
                                Image(systemName: "shuffle")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white.opacity(0.6))
                                    .padding(8)
                                    .background(.white.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                showExerciseList = true
                            }) {
                                Image(systemName: "list.bullet")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white.opacity(0.6))
                                    .padding(8)
                                    .background(.white.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showExerciseList) {
            VStack {
                Text("Exercises")
                    .font(DesignSystem.sectionHeader)
                    .padding(.top)
                
                List {
                    ForEach(routineExercises.indices, id: \.self) { index in
                        Button(action: {
                            currentExerciseIndex = index
                            remainingTime = routineExercises[index].duration
                            showExerciseList = false
                        }) {
                            HStack {
                                Image(systemName: routineExercises[index].icon)
                                    .foregroundColor(.blue)
                                Text(routineExercises[index].name)
                                    .font(DesignSystem.bodyText)
                                Spacer()
                                if currentExerciseIndex == index {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            routineExercises = selectedRoutine.exercises
            remainingTime = routineExercises[0].duration
        }
        .onChange(of: selectedRoutine) { newRoutine in
            routineExercises = newRoutine.exercises
            currentExerciseIndex = 0
            remainingTime = routineExercises[0].duration
        }
        .onReceive(timer) { _ in
            updateExerciseTimer()
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
        let exerciseCount = routineExercises.count
        
        // Check if we just finished the last exercise
        if currentExerciseIndex == exerciseCount - 1 {
            // Routine finished
            isExerciseInProgress = false
            currentExerciseIndex = 0
            remainingTime = routineExercises[0].duration
            
            // Calculate total duration
            let totalDuration = routineExercises.reduce(0) { $0 + $1.duration }
            healthManager.saveStretchWorkout(duration: TimeInterval(totalDuration))
        } else {
            currentExerciseIndex += 1
            remainingTime = routineExercises[currentExerciseIndex].duration
        }
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

