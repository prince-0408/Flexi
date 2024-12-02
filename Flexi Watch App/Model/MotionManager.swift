//
//  MotionManager.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//


import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    private let motionManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    
    @Published var stepCount: Int = 0
    @Published var currentActivity: String = "Unknown"
    @Published var isActivityTracking = false
    
    init() {
        checkMotionPermission()
    }
    
    private func checkMotionPermission() {
        guard CMMotionActivityManager.isActivityAvailable() else {
            print("Motion activity tracking is not available on this device")
            return
        }
        
        // Note: There's no direct method to check authorization status for motion activities
        let activityManager = CMMotionActivityManager()
        let motionActivityQueue = OperationQueue()
        
        activityManager.startActivityUpdates(to: motionActivityQueue) { activity in
            if activity != nil {
                DispatchQueue.main.async {
                    self.startTracking()
                }
                activityManager.stopActivityUpdates()
            }
        }
    }
    
    private func requestMotionPermission() {
        motionManager.queryActivityStarting(from: Date(), to: Date(), to: .main) { _, error in
            if let error = error {
                print("Error requesting motion permission: \(error.localizedDescription)")
            }
        }
    }
    
    func startTracking() {
        guard CMMotionActivityManager.isActivityAvailable() && 
              CMPedometer.isStepCountingAvailable() else {
            print("Motion tracking is not available")
            return
        }
        
        // Track current activity
        motionManager.startActivityUpdates(to: .main) { [weak self] activity in
            guard let activity = activity else { return }
            
            self?.currentActivity = self?.determineActivity(from: activity) ?? "Unknown"
        }
        
        // Track step count
        pedometer.startUpdates(from: Date()) { [weak self] pedometerData, error in
            if let error = error {
                print("Pedometer error: \(error.localizedDescription)")
                return
            }
            
            if let steps = pedometerData?.numberOfSteps {
                self?.stepCount = steps.intValue
            }
        }
        
        isActivityTracking = true
    }
    
    func stopTracking() {
        motionManager.stopActivityUpdates()
        pedometer.stopUpdates()
        isActivityTracking = false
    }
    
    private func determineActivity(from activity: CMMotionActivity) -> String {
        switch true {
        case activity.walking:
            return "Walking"
        case activity.running:
            return "Running"
        case activity.cycling:
            return "Cycling"
        case activity.stationary:
            return "Stationary"
        case activity.automotive:
            return "Driving"
        default:
            return "Unknown"
        }
    }
    
    deinit {
        stopTracking()
    }
}
