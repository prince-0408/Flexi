//
//  HealthManager.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//


import Foundation
import HealthKit
import CoreMotion
import UserNotifications

class HealthManager: ObservableObject {
    private let healthStore = HKHealthStore()
    private let motionManager = CMMotionManager()
    
    @Published var postureData: [PostureReading] = []
    @Published var dailyActivityStats: ActivityStats?
    
    init() {
        requestHealthKitAuthorization()
        setupMotionTracking()
    }
    
    private func requestHealthKitAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            // Add category type for sedentary time if needed
            HKObjectType.categoryType(forIdentifier: .appleStandHour)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if success {
                self.fetchDailyActivityStats()
            }
        }
    }
    
    private func setupMotionTracking() {
        guard motionManager.isDeviceMotionAvailable else { return }
        
        motionManager.deviceMotionUpdateInterval = 0.1
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let motion = motion else { return }
            
            let postureReading = PostureReading(
                timestamp: Date(),
                pitch: motion.attitude.pitch,
                roll: motion.attitude.roll,
                yaw: motion.attitude.yaw
            )
            
            self?.postureData.append(postureReading)
            self?.analyzePosture(postureReading)
        }
    }
    
    private func fetchDailyActivityStats() {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)

        let stepQuery = createStepCountQuery(startDate: startOfDay, endDate: now)
        let caloriesQuery = createActiveEnergyQuery(startDate: startOfDay, endDate: now)
        
        healthStore.execute(stepQuery)
        healthStore.execute(caloriesQuery)
    }
    
    private func createStepCountQuery(startDate: Date, endDate: Date) -> HKQuery {
        let type = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        return HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else { return }
            
            DispatchQueue.main.async {
                self.dailyActivityStats?.stepCount = sum.doubleValue(for: HKUnit.count())
            }
        }
    }
    
    private func createActiveEnergyQuery(startDate: Date, endDate: Date) -> HKQuery {
        let type = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        return HKStatisticsQuery(quantityType: type, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let result = result, let sum = result.sumQuantity() else { return }
            
            DispatchQueue.main.async {
                self.dailyActivityStats?.caloriesBurned = sum.doubleValue(for: HKUnit.kilocalorie())
            }
        }
    }
    
    private func analyzePosture(_ reading: PostureReading) {
        // Advanced posture analysis logic
        let isGoodPosture = abs(reading.pitch) < 0.5 && abs(reading.roll) < 0.5
        
        if !isGoodPosture {
            sendPostureAlertNotification()
        }
    }
    
    private func sendPostureAlertNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Posture Alert"
        content.body = "Time to straighten up and adjust your position!"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
