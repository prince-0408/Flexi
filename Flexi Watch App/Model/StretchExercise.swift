//
//  StretchExercise.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import Foundation
import SwiftUI

struct StretchExercise: Identifiable, Decodable {
    var id = UUID()
    let name: String
    let description: String
    let duration: Int
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case name, description, duration, icon
    }
}

struct ExerciseData: Decodable {
    let beginner: [StretchExercise]
    let intermediate: [StretchExercise]
    let advanced: [StretchExercise]
    let seated: [StretchExercise]
    let morning: [StretchExercise]
    let evening: [StretchExercise]
    let stressRelief: [StretchExercise]
    let postWorkout: [StretchExercise]
    let yogaFlow: [StretchExercise]
}

extension StretchRoutine {
    var exercises: [StretchExercise] {
        return ExerciseLoader.shared.getExercises(for: self)
    }
}

class ExerciseLoader {
    static let shared = ExerciseLoader()
    private var data: ExerciseData?
    
    private init() {
        loadData()
    }
    
    private func loadData() {
        guard let url = Bundle.main.url(forResource: "StretchExercises", withExtension: "json") else {
            print("❌ StretchExercises.json not found")
            return
        }
        
        do {
            let jsonData = try Data(contentsOf: url)
            self.data = try JSONDecoder().decode(ExerciseData.self, from: jsonData)
        } catch {
            print("❌ Error decoding StretchExercises.json: \(error)")
        }
    }
    
    func getExercises(for type: StretchRoutine) -> [StretchExercise] {
        guard let data = data else { return [] }
        switch type {
        case .beginner: return data.beginner
        case .intermediate: return data.intermediate
        case .advanced: return data.advanced
        case .seated: return data.seated
        case .morning: return data.morning
        case .evening: return data.evening
        case .stressRelief: return data.stressRelief
        case .postWorkout: return data.postWorkout
        case .yogaFlow: return data.yogaFlow
        }
    }
}
