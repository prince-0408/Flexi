//
//  RoutineSelectorView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

// Enum to represent different stretch routine types
enum StretchRoutine: String, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    case seated = "Seated"
 
        var exercises: [StretchExercise] {
                switch self {
                case .beginner:
                    return [
                        StretchExercise(
                            name: "Neck Stretch",
                            description: "Gently tilt head to sides",
                            duration: 30,
                            icon: "figure.roll"
                        ),
                        StretchExercise(
                            name: "Shoulder Rolls",
                            description: "Roll shoulders backward and forward",
                            duration: 30,
                            icon: "figure.arms.open"
                        ),
                        StretchExercise(
                            name: "Seated Twist",
                            description: "Rotate torso while seated",
                            duration: 30,
                            icon: "figure.flexibility"
                        )
                    ]
                case .intermediate:
                    return [
                        StretchExercise(
                            name: "Quad Stretch",
                            description: "Hold each leg and pull towards buttocks",
                            duration: 45,
                            icon: "figure.leg.stretch"
                        ),
                        StretchExercise(
                            name: "Hamstring Stretch",
                            description: "Bend forward with straight legs",
                            duration: 45,
                            icon: "figure.stand"
                        ),
                        StretchExercise(
                            name: "Chest Opener",
                            description: "Extend arms behind back",
                            duration: 30,
                            icon: "figure.arms.open"
                        )
                    ]
                case .advanced:
                    return [
                        StretchExercise(
                            name: "Deep Breathing",
                            description: "Slow, deep breaths",
                            duration: 60,
                            icon: "lungs"
                        ),
                        StretchExercise(
                            name: "Child's Pose",
                            description: "Gentle full-body stretch",
                            duration: 45,
                            icon: "person.crop.circle"
                        ),
                        StretchExercise(
                            name: "Neck Release",
                            description: "Slow neck rotations",
                            duration: 30,
                            icon: "figure.roll"
                        )
                    ]
                case .seated:
                    return [
                        StretchExercise(
                            name: "Seated Torso Twist",
                            description: "Gently twist your torso",
                            duration: 45,
                            icon: "figure.flexibility"
                        ),
                        StretchExercise(
                            name: "Shoulder Shrugs",
                            description: "Lift and lower shoulders",
                            duration: 30,
                            icon: "figure.arms.open"
                        ),
                        StretchExercise(
                            name: "Neck Release",
                            description: "Slow neck rotations",
                            duration: 30,
                            icon: "figure.roll"
                        )
                    ]
                }
            }
}
        
