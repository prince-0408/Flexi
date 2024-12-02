//
//  PostureReading.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//

// Define PostureReading as a separate struct outside the class

// PostureTypes.swift
import Foundation
import SwiftUI
import CoreMotion
import HealthKit

// Posture Reading Structure
struct PostureReading: Identifiable, Codable {
    let id: UUID
    let timestamp: Date
    let pitch: Double
    let roll: Double
    let yaw: Double
    let score: Double  // Add score property
    
    init(
        id: UUID = UUID(),
        timestamp: Date = Date(),
        pitch: Double,
        roll: Double,
        yaw: Double
    ) {
        self.id = id
        self.timestamp = timestamp
        self.pitch = pitch
        self.roll = roll
        self.yaw = yaw
        self.score = Self.calculatePostureScore(pitch: pitch, roll: roll)
    }
    
    // Static method to calculate posture score
    static func calculatePostureScore(pitch: Double, roll: Double) -> Double {
        let pitchFactor = abs(pitch)
        let rollFactor = abs(roll)
        
        let maxAcceptablePitch: Double = 0.5
        let maxAcceptableRoll: Double = 0.5
        
        let pitchDeviation = min(pitchFactor / maxAcceptablePitch * 100, 100)
        let rollDeviation = min(rollFactor / maxAcceptableRoll * 100, 100)
        
        let baseScore = 100 - ((pitchDeviation + rollDeviation) / 2)
        return max(0, pow(baseScore, 1.5))
    }
    
    var isGoodPosture: Bool {
        return abs(pitch) < 0.5 && abs(roll) < 0.5
    }
    
    var postureDeviation: Double {
        return sqrt(pitch * pitch + roll * roll)
    }
}


// Posture Status Enum
enum PostureStatus: String, Codable {
    case good
    case needsImprovement
    case poor
    
    var description: String {
        switch self {
        case .good: return "Good Posture"
        case .needsImprovement: return "Needs Improvement"
        case .poor: return "Poor Posture"
        }
    }
    
    var color: Color {
        switch self {
        case .good: return .green
        case .needsImprovement: return .yellow
        case .poor: return .red
        }
    }
}

// PostureAnalysisModel.swift
import Foundation
import CoreMotion
import UserNotifications
import HealthKit

class PostureAnalysisModel: ObservableObject {
    // Core Motion and Notification Managers
    private let motionManager = CMMotionManager()
    private let notificationCenter = UNUserNotificationCenter.current()
    private let healthStore = HKHealthStore()
    
    // Published Properties
    @Published var postureReadings: [PostureReading] = []
    @Published var currentPostureScore: Double = 100
    @Published var overallPostureStatus: PostureStatus = .needsImprovement
    @Published var postureStatusDescription: String = "Analyzing posture..."
    @Published var averagePitch: Double = 0.0
    @Published var averageRoll: Double = 0.0
    @Published var poorPostureDuration: String = "0 minutes"
    
    // Private Tracking Variables
    private var poorPostureStartTime: Date?
    private var totalPoorPostureDuration: TimeInterval = 0
    
    // Computed Properties
    var postureInsights: [String] {
        generatePostureInsights()
    }
    
    // Initialization
    init() {
        requestPermissions()
    }
    
    // Comprehensive Permission Request
    private func requestPermissions() {
        requestNotificationPermissions()
        requestHealthKitPermissions()
        requestMotionPermissions()
    }
    
    // Notification Permissions
    private func requestNotificationPermissions() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permissions granted")
            }
        }
    }
    
    // HealthKit Permissions
    private func requestHealthKitPermissions() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit not available")
            return
        }
        
        let typesToRead: Set = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if success {
                print("HealthKit permissions granted")
            }
        }
    }
    
    // Motion Permissions
    private func requestMotionPermissions() {
        // Implement any necessary motion tracking permissions
    }
    
    // Start Continuous Motion Tracking
    func startContinuousTracking() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion not available")
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let motion = motion else { return }
            
            let reading = PostureReading(
                pitch: motion.attitude.pitch,
                roll: motion.attitude.roll,
                yaw: motion.attitude.yaw
            )
            
            self?.processPostureReading(reading)
        }
    }
    
    // Process Individual Posture Reading
    private func processPostureReading(_ reading: PostureReading) {
        postureReadings.append(reading)
        updatePoorPostureDuration(reading)
        
        // Limit stored readings
        if postureReadings.count > 100 {
            postureReadings.removeFirst()
        }
        
        calculatePostureScore(reading)
    }
    
    // Update Poor Posture Duration
    private func updatePoorPostureDuration(_ reading: PostureReading) {
        let isPoorPosture = !reading.isGoodPosture
        
        if isPoorPosture && poorPostureStartTime == nil {
            poorPostureStartTime = reading.timestamp
        } else if !isPoorPosture && poorPostureStartTime != nil {
            if let startTime = poorPostureStartTime {
                totalPoorPostureDuration += reading.timestamp.timeIntervalSince(startTime)
                poorPostureStartTime = nil
            }
        }
        
        poorPostureDuration = "\(Int(totalPoorPostureDuration / 60)) minutes"
    }
    
    // Calculate Posture Score
    private func calculatePostureScore(_ reading: PostureReading) {
        let pitchFactor = abs(reading.pitch)
        let rollFactor = abs(reading.roll)
        
        let maxAcceptablePitch: Double = 0.5
        let maxAcceptableRoll: Double = 0.5
        
        let pitchDeviation = min(pitchFactor / maxAcceptablePitch * 100, 100)
        let rollDeviation = min(rollFactor / maxAcceptableRoll * 100, 100)
        
        let baseScore = 100 - ((pitchDeviation + rollDeviation) / 2)
        currentPostureScore = max(0, pow(baseScore, 1.5))
        
        updatePostureStatus()
    }
    
    // Update Posture Status
    private func updatePostureStatus() {
        if currentPostureScore > 80 {
            overallPostureStatus = .good
        } else if currentPostureScore > 50 {
            overallPostureStatus = .needsImprovement
        } else {
            overallPostureStatus = .poor
            triggerPostureAlert()
        }
        
        postureStatusDescription = generateStatusDescription()
    }
    
    // Generate Status Description
    private func generateStatusDescription() -> String {
        switch overallPostureStatus {
        case .good:
            return "Your posture looks great! Keep it up."
        case .needsImprovement:
            return "Minor posture adjustments recommended."
        case .poor:
            return "Significant posture issues detected. Take action!"
        }
    }
    
    // Trigger Posture Alert
    private func triggerPostureAlert() {
        let content = UNMutableNotificationContent()
        content.title = "Posture Alert"
        content.body = "Time to adjust your position and stretch!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        notificationCenter.add(request)
    }
    
    // Generate Posture Insights ```swift
    func generatePostureInsights() -> [String] {
        var insights: [String] = []
        
        if averagePitch > 0.7 {
            insights.append("Your head tends to tilt forward. Consider adjusting screen height.")
        }
        
        if averageRoll > 0.6 {
            insights.append("Uneven shoulder alignment detected. Check your sitting position.")
        }
        
        switch overallPostureStatus {
        case .good:
            insights.append("Excellent posture maintenance!")
        case .needsImprovement:
            insights.append("Minor adjustments can help improve your posture.")
        case .poor:
            insights.append("Significant posture issues require immediate attention.")
        }
        
        return insights
    }
    
    // Export Posture Data
    func exportPostureData() -> [String: Any] {
        return [
            "totalReadings": postureReadings.count,
            "averagePitch": averagePitch,
            "averageRoll": averageRoll,
            "currentPostureScore": currentPostureScore,
            "overallStatus": overallPostureStatus.description,
            "poorPostureDuration": poorPostureDuration
        ]
    }
    
    // Stop Tracking
    func stopTracking() {
        motionManager.stopDeviceMotionUpdates()
    }
    
    // Reset Tracking
    func resetTracking() {
        postureReadings.removeAll()
        currentPostureScore = 100
        overallPostureStatus = .needsImprovement
        totalPoorPostureDuration = 0
        poorPostureStartTime = nil
        postureStatusDescription = "Analyzing posture..."
    }
}

// PostureTracker.swift
class PostureTracker {
    private let analysisModel = PostureAnalysisModel()
    
    func startTracking() {
        analysisModel.startContinuousTracking()
    }
    
    func stopTracking() {
        analysisModel.stopTracking()
    }
    
    func getInsights() -> [String] {
        return analysisModel.generatePostureInsights()
    }
    
    func exportData() -> [String: Any] {
        return analysisModel.exportPostureData()
    }
    
    func reset() {
        analysisModel.resetTracking()
    }
}
