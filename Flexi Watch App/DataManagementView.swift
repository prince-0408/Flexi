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
        Form {
            Section(header: Text("Data Management")) {
                Button(action: {
                    showingDataDeletionConfirmation = true
                }) {
                    HStack {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                        Text("Delete All Health Data")
                            .foregroundColor(.red)
                    }
                }
                .alert(isPresented: $showingDataDeletionConfirmation) {
                    Alert(
                        title: Text("Delete All Data"),
                        message: Text("Are you sure you want to delete all your health data? This cannot be undone."),
                        primaryButton: .destructive(Text("Delete")) {
                            // Implement data deletion logic
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .navigationTitle("Data Management")
    }
}
