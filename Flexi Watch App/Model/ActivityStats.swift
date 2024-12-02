//
//  ActivityStats.swift
//  Flexi
//
//  Created by Prince Yadav on 17/12/24.
//


import Foundation
import SwiftUI
import HealthKit

struct ActivityStats: Codable, Identifiable {
    let id: UUID
    var totalActiveMinutes: Int
    var caloriesBurned: Double
    var stepCount: Int
    var standHours: Int
    var timestamp: Date
    
    // Activity Level Enum
    enum ActivityLevel: String, Codable {
        case sedentary
        case light
        case moderate
        case high
        
        var description: String {
            switch self {
            case .sedentary: return "Sedentary"
            case .light: return "Light Activity"
            case .moderate: return "Moderate Activity"
            case .high: return "High Activity"
            }
        }
        
        var color: Color {
            switch self {
            case .sedentary: return .gray
            case .light: return .blue
            case .moderate: return .green
            case .high: return .red
            }
        }
    }
    
    // Initialize with default values
    init(
        id: UUID = UUID(),
        totalActiveMinutes: Int = 0,
        caloriesBurned: Double = 0.0,
        stepCount: Int = 0,
        standHours: Int = 0,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.totalActiveMinutes = totalActiveMinutes
        self.caloriesBurned = caloriesBurned
        self.stepCount = stepCount
        self.standHours = standHours
        self.timestamp = timestamp
    }
    
    // Compute activity level
    var activityLevel: ActivityLevel {
        switch totalActiveMinutes {
        case 0..<30:
            return .sedentary
        case 30..<60:
            return .light
        case 60..<120:
            return .moderate
        default:
            return .high
        }
    }
    
    // Compute daily goal progress
    func goalProgress(for metric: ActivityMetric) -> Double {
        switch metric {
        case .activeMinutes:
            return min(Double(totalActiveMinutes) / 60.0, 1.0)
        case .calories:
            return min(caloriesBurned / 500.0, 1.0)
        case .steps:
            return min(Double(stepCount) / 10000.0, 1.0)
        case .standHours:
            return min(Double(standHours) / 12.0, 1.0)
        }
    }
    
    // Update activity data
    mutating func update(
        activeMinutes: Int? = nil,
        calories: Double? = nil,
        steps: Int? = nil,
        standHours: Int? = nil
    ) {
        if let activeMinutes = activeMinutes {
            self.totalActiveMinutes += activeMinutes
        }
        
        if let calories = calories {
            self.caloriesBurned += calories
        }
        
        if let steps = steps {
            self.stepCount += steps
        }
        
        if let standHours = standHours {
            self.standHours += standHours
        }
    }
    
    // Health recommendations based on activity level
    func healthRecommendations() -> [String] {
        switch activityLevel {
        case .sedentary:
            return [
                "Increase daily movement",
                "Take regular walking breaks",
                "Consider standing desk or walking meetings"
            ]
        case .light:
            return [
                "Aim for more consistent activity",
                "Try short workout sessions",
                "Incorporate more walking into your routine"
            ]
        case .moderate:
            return [
                "Maintain current activity levels",
                "Add variety to your exercise routine",
                "Consider strength training"
            ]
        case .high:
            return [
                "Great job maintaining high activity!",
                "Focus on recovery and rest",
                "Ensure proper nutrition and hydration"
            ]
        }
    }
    
    // Estimated calorie needs
    var estimatedCalorieNeeds: Double {
        switch activityLevel {
        case .sedentary: return 1600
        case .light: return 1800
        case .moderate: return 2200
        case .high: return 2500
        }
    }
}

// Supporting Enum for Activity Metrics
enum ActivityMetric {
    case activeMinutes
    case calories
    case steps
    case standHours
    
    var title: String {
        switch self {
        case .activeMinutes: return "Active Minutes"
        case .calories: return "Calories Burned"
        case .steps: return "Steps"
        case .standHours: return "Stand Hours"
        }
    }
}

// Extension for additional functionality
extension ActivityStats {
    // Calculate total activity score
    var activityScore: Double {
        let activeMinutesScore = min(Double(totalActiveMinutes) / 60.0, 1.0) * 25
        let caloriesScore = min(caloriesBurned / 500.0, 1.0) * 25
        let stepsScore = min(Double(stepCount) / 10000.0, 1.0) * 25
        let standHoursScore = min(Double(standHours) / 12.0, 1.0) * 25
        
        return activeMinutesScore + caloriesScore + stepsScore + standHoursScore
    }
    
    // Comparative analysis
    func compareWith(_ previousStats: ActivityStats) -> [String] {
        var comparisons: [String] = []
        
        let activeMinutesDiff = totalActiveMinutes - previousStats.totalActiveMinutes
        let caloriesDiff = caloriesBurned - previousStats.caloriesBurned
        let stepsDiff = stepCount - previousStats.stepCount
        
        if activeMinutesDiff > 0 {
            comparisons.append("Increased active minutes by \(activeMinutesDiff)")
        }
        
        if caloriesDiff > 0 {
            comparisons.append("Burned \(String(format: "%.1f", caloriesDiff)) more calories")
        }
        
        if stepsDiff > 0 {
            comparisons.append("Walked \(stepsDiff) more steps")
        }
        
        return comparisons
    }
}