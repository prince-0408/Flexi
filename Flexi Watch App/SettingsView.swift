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
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    @AppStorage("postureAlertFrequency") private var postureAlertFrequency = 30
    @AppStorage("stretchReminders") private var stretchReminders = true
    
    @State private var healthKitPermission = false
    @State private var showHealthKitError = false
    
    var body: some View {
        NavigationView {
            Form {
                // Notification Settings Section
                Section(header: Text("Notifications")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    
                    if notificationsEnabled {
                        Picker("Posture Alert Frequency", selection: $postureAlertFrequency) {
                            ForEach([15, 30, 45, 60], id: \.self) { minutes in
                                Text("\(minutes) minutes")
                            }
                        }
                        
                        Toggle("Stretch Reminders", isOn: $stretchReminders)
                    }
                }
                
                // Health Integration Section
                Section(header: Text("Health Integration")) {
                    Button(action: requestHealthKitPermission) {
                        HStack {
                            Image(systemName: "heart.text.square")
                            Text("Connect HealthKit")
                        }
                    }
                    
                    if healthKitPermission {
                        Text("HealthKit Connected")
                            .foregroundColor(.green)
                    }
                }
                
                // Personalization Section
                Section(header: Text("Personalization")) {
                    NavigationLink(destination: ProfileSettingsView()) {
                        HStack {
                            Image(systemName: "person.crop.circle")
                            Text("Profile Settings")
                        }
                    }
                    
                    NavigationLink(destination: GoalSettingsView()) {
                        HStack {
                            Image(systemName: "flag.checkered")
                            Text("Health Goals")
                        }
                    }
                }
                
                // Advanced Settings Section
                Section(header: Text("Advanced")) {
                    NavigationLink(destination: DataManagementView()) {
                        HStack {
                            Image(systemName: "doc.text.magnifyingglass")
                            Text("Data Management")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .alert(isPresented: $showHealthKitError) {
                Alert(
                    title: Text("HealthKit Error"),
                    message: Text("Unable to access HealthKit. Please check permissions."),
                    dismissButton: .default(Text("OK"))
                )
            }
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
