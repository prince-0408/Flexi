//
//  StartRoutineIntent.swift
//  Flexi
//
//  Created by Prince Yadav on 11/05/26.
//
import AppIntents
import SwiftUI

struct StartRoutineIntent: AppIntent {
    static var title: LocalizedStringResource = "Start Flexi Routine"
    static var description = IntentDescription("Start a specific stretching routine in Flexi.")

    @Parameter(title: "Routine Type")
    var routine: StretchRoutine

    func perform() async throws -> some IntentResult & ProvidesDialog {
        // In a real app, this would trigger the UI via a deep link or shared state
        return .result(dialog: "Starting your \(routine.rawValue) routine on Flexi. Stand tall!")
    }
}

struct FlexiShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartRoutineIntent(),
            phrases: [
                "Start my \(\.$routine) routine in \(.applicationName)",
                "Begin \(\.$routine) stretch in \(.applicationName)"
            ],
            shortTitle: "Start Routine",
            systemImageName: "figure.stretch"
        )
    }
}
