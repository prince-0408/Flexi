//
//  ProfileSettingsView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct ProfileSettingsView: View {
    @State private var age = 30
    @State private var weight = 70.0
    @State private var height = 170.0
    @State private var activityLevel: ActivityLevel = .moderate
    
    enum ActivityLevel: String, CaseIterable {
        case sedentary = "Sedentary"
        case light = "Light"
        case moderate = "Moderate"
        case active = "Active"
        case veryActive = "Very Active"
    }
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                Stepper("Age: \(age)", value: $age, in: 18...100)
                
                Picker("Activity Level", selection: $activityLevel) {
                    ForEach(ActivityLevel.allCases, id: \.self) { level in
                        Text(level.rawValue)
                    }
                }
                
                HStack {
                    Text("Weight")
                    Spacer()
                    Text("\(String(format: "%.1f", weight)) kg")
                }
                Slider(value: $weight, in: 40...150, step: 0.1)
                
                HStack {
                    Text("Height")
                    Spacer()
                    Text("\(String(format: "%.0f", height)) cm")
                }
                Slider(value: $height, in: 140...220, step: 1)
            }
        }
        .navigationTitle("Profile Settings")
    }
}
