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
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20, height: 20)
                .aspectRatio(contentMode: .fit)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            Spacer()
            
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
        }
        .padding(.vertical, 4)
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
