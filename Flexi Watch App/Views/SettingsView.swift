//
//  SettingsView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//


import SwiftUI
import HealthKit

struct SettingsView: View {
    private let healthStore = HKHealthStore()
    
    // App Storage for settings
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("postureAlertFrequency") private var postureAlertFrequency = 30
    @AppStorage("stretchReminders") private var stretchReminders = true
    @AppStorage("selectedAppearance") private var selectedAppearance = AppAppearance.system
    
    // State variables
    @State private var healthKitPermission = false
    @State private var showHealthKitError = false
    @Environment(\.colorScheme) private var colorScheme
    
    // Enum for app appearance
    enum AppAppearance: String, CaseIterable {
        case light = "Light"
        case dark = "Dark"
        case system = "System"
        
        var colorScheme: ColorScheme? {
            switch self {
            case .light: return .light
            case .dark: return .dark
            case .system: return nil
            }
        }
    }
    
    // Custom Color Palette
    struct AppColors {
        static let lightBackground = Color(red: 0.95, green: 0.96, blue: 0.98)
        static let darkBackground = Color(red: 0.1, green: 0.1, blue: 0.13)
        
        static let lightPrimary = Color(red: 0.2, green: 0.45, blue: 0.85)
        static let darkPrimary = Color(red: 0.4, green: 0.65, blue: 1.0)
        
        static let lightAccent = Color(red: 0.3, green: 0.7, blue: 0.5)
        static let darkAccent = Color(red: 0.5, green: 0.9, blue: 0.7)
        
        // Gradient Colors
        static func primaryGradient(for colorScheme: ColorScheme) -> LinearGradient {
            let colors = colorScheme == .dark
                ? [darkPrimary.opacity(0.7), darkPrimary.opacity(0.9)]
                : [lightPrimary.opacity(0.7), lightPrimary.opacity(0.9)]
            
            return LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        
        static func backgroundGradient(for colorScheme: ColorScheme) -> LinearGradient {
            let colors = colorScheme == .dark
                ? [darkBackground, darkBackground.opacity(0.9)]
                : [lightBackground, lightBackground.opacity(0.95)]
            
            return LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                AppColors.backgroundGradient(for: colorScheme)
                    .edgesIgnoringSafeArea(.all)
                
                Form {
                    // Appearance Section
                    Section(header: Text("Appearance")
                        .foregroundColor(colorScheme == .dark ? AppColors.darkPrimary : AppColors.lightPrimary)) {
                        Picker("App Theme", selection: $selectedAppearance) {
                            ForEach(AppAppearance.allCases, id: \.self) { appearance in
                                Text(appearance.rawValue)
                                    .tag(appearance)
                                    .foregroundColor(colorScheme == .dark ? AppColors.darkAccent : AppColors.lightAccent)
                            }
                        }
                    }
                    
                    // Notification Settings Section
                    Section(header: Text("Notifications")
                        .foregroundColor(colorScheme == .dark ? AppColors.darkPrimary : AppColors.lightPrimary)) {
                        Toggle("Enable Notifications", isOn: $notificationsEnabled)
                            .toggleStyle(SwitchToggleStyle(tint: colorScheme == .dark ? AppColors.darkAccent : AppColors.lightAccent))
                        
                        if notificationsEnabled {
                            Picker("Posture Alert", selection: $postureAlertFrequency) {
                                ForEach([15, 30, 45, 60], id: \.self) { minutes in
                                    Text("\(minutes) min")
                                }
                            }
                            .accentColor(colorScheme == .dark ? AppColors.darkPrimary : AppColors.lightPrimary)
                            
                            Toggle("Stretch Reminders", isOn: $stretchReminders)
                                .toggleStyle(SwitchToggleStyle(tint: colorScheme == .dark ? AppColors.darkAccent : AppColors.lightAccent))
                        }
                    }
                    
                    // Health Integration Section
                    Section(header: Text("Health")
                        .foregroundColor(colorScheme == .dark ? AppColors.darkPrimary : AppColors.lightPrimary)) {
                        Button(action: requestHealthKitPermission) {
                            HStack {
                                Image(systemName: "heart.text.square")
                                    .foregroundColor(colorScheme == .dark ? AppColors.darkAccent : AppColors.lightAccent)
                                Text("Connect HealthKit")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                        }
                        
                        if healthKitPermission {
                            Text("HealthKit Connected")
                                .foregroundColor(colorScheme == .dark ? AppColors.darkAccent : AppColors.lightAccent)
                        }
                    }
                    
                    // Advanced Settings Section
                    Section(header: Text("Advanced")
                        .foregroundColor(colorScheme == .dark ? AppColors.darkPrimary : AppColors.lightPrimary)) {
                        NavigationLink(destination: ProfileSettingsView()) {
                            HStack {
                                Image(systemName: "person.crop.circle")
                                    .foregroundColor(colorScheme == .dark ? AppColors.darkAccent : AppColors.lightAccent)
                                Text("Profile")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                        }
                        
                        NavigationLink(destination: GoalSettingsView()) {
                            HStack {
                                Image(systemName: "flag.checkered")
                                    .foregroundColor(colorScheme == .dark ? AppColors.darkAccent : AppColors.lightAccent)
                                Text("Goals")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                        }
                    }
                }
                .navigationTitle("Settings")
                .foregroundColor(colorScheme == .dark ? .white : .black)
            }
        }
        // Apply the selected appearance to the entire view
        .preferredColorScheme(selectedAppearance.colorScheme)
        .alert(isPresented: $showHealthKitError) {
            Alert(
                title: Text("HealthKit Error"),
                message: Text("Unable to access HealthKit. Please check permissions."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func requestHealthKitPermission() {
        guard HKHealthStore.isHealthDataAvailable() else {
            showHealthKitError = true
            return
        }
        
        let typesToShare: Set = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
        
        let typesToRead: Set = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.workoutType()
        ]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
            DispatchQueue.main.async {
                if success {
                    self.healthKitPermission = true
                } else {
                    self.showHealthKitError = true
                }
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
