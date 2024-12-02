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
        Form {
            Section(header: Text("Daily Goals")) {
                Stepper("Daily Steps: \(dailyStepGoal)", value: $dailyStepGoal, in: 5000...20000, step: 1000)
                
                Stepper("Calories to Burn: \(caloriesBurnGoal)", value: $caloriesBurnGoal, in: 300...1000, step: 50)
            }
            
            Section(header: Text("Weekly Goals")) {
                Stepper("Stretch Sessions: \(weeklyStretchGoal)", value: $weeklyStretchGoal, in: 1...7)
            }
        }
        .navigationTitle("Health Goals")
    }
}
