//
//  PostureAnalysisModel.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//

import Foundation
import CoreMotion
import UserNotifications


class PostureAnalysisModel: ObservableObject {
    private let motionManager = CMMotionManager()
    @Published var postureReadings: [PostureReading] = []
    @Published var currentPostureScore: Double = 0
    @Published var overallPostureStatus: PostureStatus = .good
    
    enum PostureStatus {
        case good, needsImprovement, poor
    }
    
    var postureStatusDescription: String {
        switch overallPostureStatus {
        case .good:
            return "Your posture looks great! Keep it up."
        case .needsImprovement:
            return "Minor posture adjustments recommended."
        case .poor:
            return "Significant posture issues detected. Take action!"
        }
    }
    
    var averagePitch: Double {
        guard !postureReadings.isEmpty else { return 0 }
        return postureReadings.map { abs($0.pitch) }.reduce(0, +) / Double(postureReadings.count)
    }
    
    var averageRoll: Double {
        guard !postureReadings.isEmpty else { return 0 }
        return postureReadings.map { abs($0.roll) }.reduce(0, +) / Double(postureReadings.count)
    }
    
    var poorPostureDuration: String {
        // Placeholder implementation
        return "15 minutes"
    }
    
    func startContinuousTracking() {
        guard motionManager.isDeviceMotionAvailable else { return }
        
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let motion = motion else { return }
            
            let reading = PostureReading(
                timestamp: Date(),
                pitch: motion.attitude.pitch,
                roll: motion.attitude.roll,
                yaw: motion.attitude.yaw
            )
            
            self?.processPostureReading(reading)
        }
    }
    
    private func processPostureReading(_ reading: PostureReading) {
        postureReadings.append(reading)
        
        // Limit stored readings to last 100
        if postureReadings.count > 100 {
            postureReadings.removeFirst()
        }
        
        // Advanced posture score calculation
        calculatePostureScore(reading)
    }
    
    private func calculatePostureScore(_ reading: PostureReading) {
        // More complex posture score algorithm
        let pitchFactor = abs(reading.pitch)
        let rollFactor = abs(reading.roll)
        
        let maxAcceptablePitch: Double = 0.5
        let maxAcceptableRoll: Double = 0.5
        
        // Calculate deviation from ideal posture
        let pitchDeviation = min(pitchFactor / maxAcceptablePitch * 100, 100)
        let rollDeviation = min(rollFactor / maxAcceptableRoll * 100, 100)
        
        // Combine factors with more weight on extreme deviations
        let baseScore = 100 - ((pitchDeviation + rollDeviation) / 2)
        
        // Apply non-linear scoring to emphasize bad posture
        currentPostureScore = max(0, pow(baseScore, 1.5))
        
        // Determine posture status
        if currentPostureScore > 80 {
            overallPostureStatus = .good
        } else if currentPostureScore > 50 {
            overallPostureStatus = .needsImprovement
        } else {
            overallPostureStatus = .poor
            triggerPostureAlert()
        }
    }
    
    private func triggerPostureAlert() {
        let content = UNMutableNotificationContent()
        content.title = "Posture Alert"
        content.body = "Time to adjust your position and stretch!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func stopTracking() {
        motionManager.stopDeviceMotionUpdates()
    }
}
