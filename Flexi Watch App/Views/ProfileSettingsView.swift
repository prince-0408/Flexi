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
        ScrollView {
            VStack(spacing: 12) {
                // Personal Info Section Header
                HStack {
                    Text("PERSONAL INFORMATION")
                        .font(DesignSystem.sectionHeader)
                        .foregroundColor(.white.opacity(0.6))
                    Spacer()
                }
                .padding(.horizontal, 4)
                
                // Age Setting (Glass Well)
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(.blue)
                        Text("Age")
                            .font(DesignSystem.bodyText)
                        Spacer()
                        Text("\(age)")
                            .font(DesignSystem.primaryTitle)
                            .foregroundColor(.white)
                    }
                    
                    Stepper(value: $age, in: 18...100) {
                        EmptyView()
                    }
                    .labelsHidden()
                }
                .padding(12)
                .glassyCard()
                
                // Weight & Height (Compact Grid)
                HStack(spacing: 8) {
                    MetricAdjuster(title: "Weight", value: "\(Int(weight))", unit: "KG", icon: "scalemass.fill")
                    MetricAdjuster(title: "Height", value: "\(Int(height))", unit: "CM", icon: "ruler.fill")
                }
                
                // Activity Level Picker
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                        Text("Activity Level")
                            .font(DesignSystem.bodyText)
                        Spacer()
                    }
                    
                    Picker("", selection: $activityLevel) {
                        ForEach(ActivityLevel.allCases, id: \.self) { level in
                            Text(level.rawValue).tag(level)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 50)
                }
                .padding(12)
                .glassyCard()
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 20)
        }
        .navigationTitle("Profile")
    }
}

struct MetricAdjuster: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.blue)
            
            Text(title.uppercased())
                .font(.system(size: 8, weight: .bold))
                .foregroundColor(.white.opacity(0.5))
            
            HStack(alignment: .firstTextBaseline, spacing: 1) {
                Text(value)
                    .font(DesignSystem.primaryTitle)
                    .foregroundColor(.white)
                Text(unit)
                    .font(.system(size: 8, weight: .black))
                    .foregroundColor(.white.opacity(0.4))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .glassyCard()
    }
}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                ProfileSettingsView()
            }
        }
    }
}
