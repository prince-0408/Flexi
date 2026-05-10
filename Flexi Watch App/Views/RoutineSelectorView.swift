//
//  RoutineSelectorView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct RoutineSelectorView: View {
    @Binding var selectedRoutine: StretchRoutine
    @State private var crownValue: Double = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Select Routine")
                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                    .foregroundColor(.white)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(StretchRoutine.allCases, id: \.self) { routine in
                                GeometryReader { geometry in
                                    let minX = geometry.frame(in: .global).minX
                                    let screenWidth = WKInterfaceDevice.current().screenBounds.width
                                    let centerX = screenWidth / 2
                                    let distanceFromCenter = abs(centerX - (minX + geometry.size.width / 2))
                                    let scale = max(0.8, 1.0 - (distanceFromCenter / screenWidth) * 0.4)
                                    let rotation = (minX + geometry.size.width / 2 - centerX) / screenWidth * -45
                                    
                                    Button(action: {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                            selectedRoutine = routine
                                            crownValue = Double(StretchRoutine.allCases.firstIndex(of: routine) ?? 0)
                                        }
                                    }) {
                                        VStack(alignment: .leading, spacing: 12) {
                                            // Icon and Status Badge
                                            HStack {
                                                ZStack {
                                                    Circle()
                                                        .fill(.white.opacity(0.15))
                                                        .frame(width: 32, height: 32)
                                                    Image(systemName: routine.exercises.first?.icon ?? "figure.stretch")
                                                        .font(.system(size: 16, weight: .bold))
                                                        .foregroundColor(.white)
                                                }
                                                Spacer()
                                                if selectedRoutine == routine {
                                                    Text("ACTIVE")
                                                        .font(.system(size: 8, weight: .black))
                                                        .padding(.horizontal, 6)
                                                        .padding(.vertical, 3)
                                                        .background(.white)
                                                        .foregroundColor(.black)
                                                        .cornerRadius(4)
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            // Title and Detail
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(routine.rawValue.capitalized)
                                                    .font(DesignSystem.primaryTitle)
                                                    .foregroundColor(.white)
                                                
                                                Text("\(routine.exercises.count) Exercises")
                                                    .font(DesignSystem.captionText)
                                                    .foregroundColor(.white.opacity(0.6))
                                            }
                                        }
                                        .padding(16)
                                        .frame(width: 140, height: 160)
                                        .background(
                                            ZStack {
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        routine.color.opacity(0.6),
                                                        routine.color.opacity(0.2)
                                                    ]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                                
                                                // Inner Luminous Ring
                                                RoundedRectangle(cornerRadius: 24)
                                                    .stroke(
                                                        LinearGradient(
                                                            gradient: Gradient(colors: [.white.opacity(0.5), .clear]),
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        ),
                                                        lineWidth: 1
                                                    )
                                            }
                                        )
                                        .cornerRadius(24)
                                        .shadow(color: routine.color.opacity(0.3), radius: 10, x: 0, y: 5)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .scaleEffect(scale)
                                    .rotation3DEffect(.degrees(Double(rotation)), axis: (x: 0, y: 1, z: 0))
                                    .opacity(selectedRoutine == routine ? 1.0 : 0.6)
                                }
                                .frame(width: 140, height: 160)
                            }
                        }
                        .padding(.horizontal, (WKInterfaceDevice.current().screenBounds.width - 140) / 2)
                    }
                    .frame(height: 180)
                    .focusable()
                    .digitalCrownRotation(
                        $crownValue,
                        from: 0,
                        through: Double(StretchRoutine.allCases.count - 1),
                        by: 1,
                        sensitivity: .medium,
                        isContinuous: false,
                        isHapticFeedbackEnabled: true
                    )
                    .onChange(of: crownValue) { newValue in
                        let index = Int(round(newValue))
                        let allCases = StretchRoutine.allCases
                        if index >= 0 && index < allCases.count {
                            let newRoutine = allCases[index]
                            if newRoutine != selectedRoutine {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedRoutine = newRoutine
                                    HapticManager.shared.playSelection()
                                }
                            }
                        }
                    }
            }
        }
        .onAppear {
            crownValue = Double(StretchRoutine.allCases.firstIndex(of: selectedRoutine) ?? 0)
        }
    }
}

extension StretchRoutine {
    var color: Color {
        switch self {
        case .beginner: return .green
        case .intermediate: return .blue
        case .advanced: return .purple
        case .seated: return .orange
        case .morning: return .yellow
        case .evening: return .indigo
        case .stressRelief: return .teal
        case .postWorkout: return .pink
        case .yogaFlow: return .mint
        }
    }
    
    var icon: String {
        switch self {
        case .beginner: return "figure.walk"
        case .intermediate: return "figure.run"
        case .advanced: return "figure.skiing.downhill"
        case .seated: return "figure.cooldown"
        case .morning: return "sun.max.fill"
        case .evening: return "moon.stars.fill"
        case .stressRelief: return "heart.fill"
        case .postWorkout: return "figure.run.square.stack"
        case .yogaFlow: return "figure.yoga"
        }
    }
}

struct RoutineCard: View {
    let routine: StretchRoutine
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                // Background glowing circle
                Circle()
                    .fill(isSelected ? routine.color : Color.clear)
                    .blur(radius: isSelected ? 4 : 0)
                    .matchedGeometryEffect(id: "backgroundGlow", in: namespace)
                
                // Icon
                Image(systemName: routine.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(width: 45, height: 45)
            
            Text(routine.rawValue)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(isSelected ? .white : .secondary)
            
            Spacer()
        }
        .padding(10)
        .background(
            Color.clear
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    isSelected ? routine.color.opacity(0.8) : Color.white.opacity(0.3),
                                    Color.clear
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: isSelected ? 2 : 1
                        )
                )
        )
        .shadow(color: isSelected ? routine.color.opacity(0.3) : .clear, radius: 10, x: 0, y: 5)
        .onTapGesture(perform: action)
    }
}

struct RoutineSelectorView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedRoutine = StretchRoutine.beginner
        
        var body: some View {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                RoutineSelectorView(selectedRoutine: $selectedRoutine)
            }
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
