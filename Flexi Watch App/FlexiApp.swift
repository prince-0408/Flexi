//
//  FlexiApp.swift
//  Flexi Watch App
//
//  Created by Prince Yadav on 02/12/24.
//

import SwiftUI
import HealthKit
import CoreMotion

@main
struct FlexiApp: App {
    @StateObject private var healthManager = HealthManager()
    @StateObject private var motionManager = MotionManager()
    @AppStorage("OnboardingCompleted") private var onboardingCompleted = false
    
    var body: some Scene {
        WindowGroup {
            if onboardingCompleted {
                MainNavigationView()
                    .environmentObject(healthManager)
                    .environmentObject(motionManager)
            } else {
                OnboardingView()
                    .environmentObject(healthManager)
                    .environmentObject(motionManager)
            }
        }
    }
}
