//
//  QuickStatsGridView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct QuickStatsView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 8),
            GridItem(.flexible(), spacing: 8)
        ], spacing: 8) {
            StatItemView(
                icon: "figure.walk",
                title: "Steps",
                value: "8.5K",
                color: AppColors.stepColor
            )
            .statsCardStyle(colorScheme: colorScheme)
            
            StatItemView(
                icon: "flame",
                title: "Calories",
                value: "420",
                color: AppColors.caloriesColor
            )
            .statsCardStyle(colorScheme: colorScheme)
            
            StatItemView(
                icon: "timer",
                title: "Active",
                value: "45m",
                color: AppColors.activeColor
            )
            .statsCardStyle(colorScheme: colorScheme)
            
            StatItemView(
                icon: "heart",
                title: "HR",
                value: "72",
                color: AppColors.heartRateColor
            )
            .statsCardStyle(colorScheme: colorScheme)
        }
        .padding(8)
        .background(colorScheme == .dark ? AppColors.darkBackground : AppColors.lightBackground)
        .cornerRadius(12)
    }
}


extension View {
    func statsCardStyle(colorScheme: ColorScheme) -> some View {
        self
            .background(colorScheme == .dark ? AppColors.darkCardBackground : AppColors.lightCardBackground)
            .cornerRadius(10)
            .shadow(color: colorScheme == .dark
                ? AppColors.darkShadow
                : AppColors.lightShadow,
                radius: 6, x: 0, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        colorScheme == .dark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                        lineWidth: 0.5
                    )
            )
            .padding(2)
    }
}
           

struct QuickStatsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            QuickStatsView()
                .preferredColorScheme(.light)
            
            QuickStatsView()
                .preferredColorScheme(.dark)
        }
    }
}
