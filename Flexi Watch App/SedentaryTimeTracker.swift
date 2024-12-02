//
//  SedentaryTimeTracker.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//


import HealthKit

class SedentaryTimeTracker {
    private let healthStore = HKHealthStore()
    
    func requestHealthKitPermissions() {
        // Types of data you want to read
        let typesToRead: Set = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        ]
        
        // Types of data you want to write
        let typesToWrite: Set = [
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
        
        healthStore.requestAuthorization(toShare: typesToWrite, read: typesToRead) { (success, error) in
            if success {
                self.calculateSedentaryTime()
            }
        }
    }
    
    func calculateSedentaryTime() {
        // Create a predicate for today's date
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )
        
        // Query for exercise time
        let exerciseQuery = HKStatisticsQuery(
            quantityType: HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { (query, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                print("Could not calculate exercise time")
                return
            }
            
            let exerciseMinutes = sum.doubleValue(for: HKUnit.minute())
            let totalDayMinutes = 24 * 60
            let sedentaryMinutes = Double(totalDayMinutes) - exerciseMinutes

            print("Sedentary Time: \(sedentaryMinutes) minutes")
        }
        
        healthStore.execute(exerciseQuery)
    }
}
