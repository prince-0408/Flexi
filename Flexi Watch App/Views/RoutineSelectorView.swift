//
//  RoutineSelectorView 2.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct RoutineSelectorView: View {
    @Binding var selectedRoutine: StretchRoutine
    @Namespace private var animation
    var backgroundColor: LinearGradient?
    var textColor: Color?
    
    var body: some View {
//        ZStack {
//                    colorTheme.backgroundGradient
//                        .edgesIgnoringSafeArea(.all)
//                }
        ScrollView {
            VStack(spacing: 10) {
                Text("Stretch Routine")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // Use a vertical stack for better use of watch screen
                VStack(spacing: 10) {
                    ForEach(StretchRoutine.allCases, id: \.self) { routine in
                        RoutineCard(
                            routine: routine,
                            isSelected: selectedRoutine == routine,
                            namespace: animation
                        ) {
                            withAnimation(.easeInOut) {
                                selectedRoutine = routine
                            }
                        }
                    }
                }
                .padding(.horizontal, 5)
            }
            .padding()
            .background(
                Color.secondary.opacity(0.1)
                    .cornerRadius(15)
            )
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
        }
    }
}

struct RoutineCard: View {
    let routine: StretchRoutine
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                // Background circle
                Circle()
                    .fill(isSelected ? routineColor : Color.clear)
                    .matchedGeometryEffect(id: "background", in: namespace)
                
                // Icon
                Image(systemName: iconForRoutine(routine))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(isSelected ? .white : .primary)
                    .frame(width: 30, height: 30)
            }
            .frame(width: 50, height: 50)
            
            Text(routine.rawValue)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? routineColor : .primary)
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? routineColor : Color.gray.opacity(0.3), lineWidth: 1.5)
        )
        .onTapGesture(perform: action)
    }
    
    var routineColor: Color {
        switch routine {
        case .beginner: return .green
        case .intermediate: return .blue
        case .advanced: return .red
        }
    }
    
    func iconForRoutine(_ routine: StretchRoutine) -> String {
        switch routine {
        case .beginner: return "figure.walk.circle.fill"
        case .intermediate: return "figure.run.circle.fill"
        case .advanced: return "figure.skiing.downhill.circle.fill"
        }
    }
}

struct RoutineSelectorView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedRoutine = StretchRoutine.beginner
        
        var body: some View {
            VStack {
                RoutineSelectorView(selectedRoutine: $selectedRoutine)
                Text("Selected: \(selectedRoutine.rawValue)")
                    .padding()
            }
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.light)
        
        PreviewWrapper()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
