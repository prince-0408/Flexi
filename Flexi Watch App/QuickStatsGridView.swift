//
//  QuickStatsGridView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct QuickStatsGridView: View {
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
            StatCardView(
                icon: "figure.walk",
                title: "Steps",
                value: "8,500",
                color: .green
            )
            
            StatCardView(
                icon: "flame",
                title: "Calories",
                value: "420",
                color: .orange
            )
            
            StatCardView(
                icon: "timer",
                title: "Active Time",
                value: "45 min",
                color: .purple
            )
            
            StatCardView(
                icon: "bed.double",
                title: "Rest",
                value: "8 hrs",
                color: .blue
            )
        }
    }
}
