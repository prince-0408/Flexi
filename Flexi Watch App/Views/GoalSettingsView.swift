//
//  GoalSettingsView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//

import SwiftUICore
import SwiftUI


struct GoalSettingsView: View {
    @State private var dailyStepGoal = 10000
    @State private var weeklyStretchGoal = 3
    @State private var caloriesBurnGoal = 500
    
    var body: some View {
        List {
            Section {
                GoalStepper(
                    title: "Daily Steps",
                    value: $dailyStepGoal,
                    range: 5000...20000,
                    step: 1000
                )
                
                GoalStepper(
                    title: "Calories Burn",
                    value: $caloriesBurnGoal,
                    range: 300...1000,
                    step: 50
                )
            } header: {
                Text("Daily Goals")
                    .font(.caption)
            }
            
            Section {
                GoalStepper(
                    title: "Stretch Sessions",
                    value: $weeklyStretchGoal,
                    range: 1...7
                )
            } header: {
                Text("Weekly Goals")
                    .font(.caption)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Goals")
    }
}

// Custom Stepper for more compact watch UI
struct GoalStepper: View {
    let title: String
    @Binding var value: Int
    var range: ClosedRange<Int>
    var step: Int = 1
    
    var body: some View {
        HStack {
            Text(title)
                .font(.caption)
            
            Spacer()
            
            HStack(spacing: 10) {
                Button(action: decrease) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.blue)
                }
                .disabled(value == range.lowerBound)
                
                Text("\(value)")
                    .font(.caption)
                    .frame(minWidth: 40, alignment: .center)
                
                Button(action: increase) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                }
                .disabled(value == range.upperBound)
            }
        }
    }
    
    private func decrease() {
        value = max(range.lowerBound, value - step)
    }
    
    private func increase() {
        value = min(range.upperBound, value + step)
    }
}
