//
//  RoutineSelector.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI
import AppIntents

enum StretchRoutine: String, CaseIterable, AppEnum {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case seated = "Seated"
    case morning = "Morning"
    case evening = "Evening"
    case stressRelief = "Stress Relief"
    case postWorkout = "Post-Workout"
    case yogaFlow = "Yoga Flow"
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Stretch Routine"
    
    static var caseDisplayRepresentations: [StretchRoutine: DisplayRepresentation] = [
        .beginner: "Beginner",
        .intermediate: "Intermediate",
        .advanced: "Advanced",
        .seated: "Seated",
        .morning: "Morning",
        .evening: "Evening",
        .stressRelief: "Stress Relief",
        .postWorkout: "Post-Workout",
        .yogaFlow: "Yoga Flow"
    ]
}
