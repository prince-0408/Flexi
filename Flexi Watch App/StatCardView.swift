//
//  StatCardView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct StatCardView: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
        .shadow(color: color.opacity(0.2), radius: 5)
        .rotation3DEffect(
            .degrees(5),
            axis: (x: 10.0, y: -10.0, z: 0.0)
        )
    }
}
