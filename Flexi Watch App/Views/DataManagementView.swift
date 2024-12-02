//
//  DataManagementView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//

import SwiftUICore
import SwiftUI


struct DataManagementView: View {
    @State private var showingDataDeletionConfirmation = false
    
    var body: some View {
        List {
            Section {
                Button(role: .destructive) {
                    showingDataDeletionConfirmation = true
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete Health Data")
                    }
                }
            } header: {
                Text("Data Management")
                    .font(.caption)
            } footer: {
                Text("Caution: This will permanently remove all stored health information.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .listStyle(.plain)
        .navigationTitle("Data")
        .confirmationDialog("Delete All Data",
            isPresented: $showingDataDeletionConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete All Data", role: .destructive) {
                // Implement data deletion logic
            }
        } message: {
            Text("Are you sure you want to delete all your health data? This cannot be undone.")
        }
    }
}
