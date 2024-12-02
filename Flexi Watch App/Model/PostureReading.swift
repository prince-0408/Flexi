//
//  PostureReading.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//

import Foundation


struct PostureReading {
    let timestamp: Date
    let pitch: Double
    let roll: Double
    let yaw: Double
}

struct ActivityStats {
    var stepCount: Double = 0
    var caloriesBurned: Double = 0
}
