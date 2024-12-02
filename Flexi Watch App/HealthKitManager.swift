//
//  HealthKitManager.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//

//
//import HealthKit
//
//class HealthKitManager {
//    let healthStore = HKHealthStore()
//    
//    // Correct way to handle sedentary time tracking
//    func trackSedentaryTime() {
//        guard HKHealthStore.isHealthDataAvailable() else {
//            print("HealthKit is not available on this device")
//            return
//        }
//        
//        // Option 1: Use Active Energy Burned as a proxy for sedentary time
//        guard let activeEnergyBurnedType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
//            return
//        }
//        
//        // Option 2: Use Move Time as an alternative
//        guard let moveTimeType = HKQuantityType.quantityType(forIdentifier: .appleExerciseTime) else {
//            return
//        }
//    }
//}
