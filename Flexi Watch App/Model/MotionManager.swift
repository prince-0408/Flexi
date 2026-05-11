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
    private let headphoneMotionManager = CMHeadphoneMotionManager()
    
    @Published var stepCount: Int = 0
    @Published var currentActivity: String = "Unknown"
    @Published var isActivityTracking = false
    
    // Posture & AirPods Metrics
    @Published var headPitch: Double = 0
    @Published var headRoll: Double = 0
    @Published var isAirPodsConnected = false
    @Published var techNeckWarning = false
    
    init() {
        // Permissions moved to Onboarding flow to prevent launch crash
    }
    
    func setupHeadphoneMotion() {
        guard headphoneMotionManager.isDeviceMotionAvailable else { return }
        
        headphoneMotionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let motion = motion else {
                self?.isAirPodsConnected = false
                return
            }
            
            self?.isAirPodsConnected = true
            
            // Convert to degrees
            let pitch = motion.attitude.pitch * 180 / .pi
            let roll = motion.attitude.roll * 180 / .pi
            
            self?.headPitch = pitch
            self?.headRoll = roll
            
            // Tech Neck Logic: Forward tilt > 20 degrees is bad
            if pitch > 20 {
                if self?.techNeckWarning == false {
                    self?.techNeckWarning = true
                    HapticManager.shared.playWarning()
                }
            } else {
                self?.techNeckWarning = false
            }
        }
    }
    
    func checkMotionPermission() {
        guard CMMotionActivityManager.isActivityAvailable() else {
            print("Motion activity tracking is not available on this device")
            return
        }
        
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
    
    func startTracking() {
        guard CMMotionActivityManager.isActivityAvailable() && 
              CMPedometer.isStepCountingAvailable() else {
            return
        }
        
        motionManager.startActivityUpdates(to: .main) { [weak self] activity in
            guard let activity = activity else { return }
            self?.currentActivity = self?.determineActivity(from: activity) ?? "Unknown"
        }
        
        pedometer.startUpdates(from: Date()) { [weak self] pedometerData, error in
            if let steps = pedometerData?.numberOfSteps {
                self?.stepCount = steps.intValue
            }
        }
        
        isActivityTracking = true
    }
    
    func stopTracking() {
        motionManager.stopActivityUpdates()
        pedometer.stopUpdates()
        headphoneMotionManager.stopDeviceMotionUpdates()
        isActivityTracking = false
    }
    
    private func determineActivity(from activity: CMMotionActivity) -> String {
        switch true {
        case activity.walking: return "Walking"
        case activity.running: return "Running"
        case activity.cycling: return "Cycling"
        case activity.stationary: return "Stationary"
        case activity.automotive: return "Driving"
        default: return "Unknown"
        }
    }
    
    deinit {
        stopTracking()
    }
}
