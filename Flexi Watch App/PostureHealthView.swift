//
//  PostureHealthView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct PostureHealthView: View {
    var body: some View {
        VStack {
            Text("Posture Health")
                .font(.headline)
            
            HStack {
                Image(systemName: "figure.stand")
                    .foregroundColor(.green)
                
                VStack(alignment: .leading) {
                    Text("Good Posture")
                        .font(.subheadline)
                    Text("Keep it up!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(10)
        }
    }
}
