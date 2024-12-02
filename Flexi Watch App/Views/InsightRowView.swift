//
//  InsightRowView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct InsightRowView: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            Text(title)
                .font(.caption)
            
            Spacer()
            
            Text(value)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    VStack {
        InsightRowView(icon: "flame", title: "Calories Burned", value: "320")
        InsightRowView(icon: "figure.walk", title: "Steps", value: "6,542")
        InsightRowView(icon: "heart", title: "Heart Rate", value: "72 bpm")
    }
    .previewLayout(.sizeThatFits)
    .padding()
}
