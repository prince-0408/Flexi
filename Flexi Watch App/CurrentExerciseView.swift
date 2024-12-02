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
    
    var body: some View {
        VStack(spacing: 15) {
            // Exercise Image
            Image(systemName: routineType.exercises[currentIndex].icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .foregroundColor(.blue)
            
            // Exercise Details
            Text(routineType.exercises[currentIndex].name)
                .font(.headline)
            
            Text(routineType.exercises[currentIndex].description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            // Timer
            if isInProgress {
                Text("\(remainingTime) seconds")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(15)
    }
}
