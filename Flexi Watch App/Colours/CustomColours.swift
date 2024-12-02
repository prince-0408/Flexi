//
//  CustomColours.swift
//  Flexi
//
//  Created by Prince Yadav on 03/12/24.
//

import SwiftUICore
import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    // Color scheme aware color initializer
    init(light: Color, dark: Color) {
        self.init(dynamicColor: { colorScheme in
            switch colorScheme {
            case .dark:
                return dark
            default:
                return light
            }
        })
    }
}

// Dynamic Color Extension
extension Color {
    init(dynamicColor: @escaping (ColorScheme) -> Color) {
        self = dynamicColor(.light)  // Default to light mode
    }
}

struct AppColors {
    // Light Mode Colors
    static let lightBackground = Color(hex: "F0F4F8")
    static let lightCardBackground = Color.white
    static let lightShadow = Color.black.opacity(0.1)
    static let lightBorder = Color.black.opacity(0.05)
    
    // Dark Mode Colors
    static let darkBackground = Color(hex: "1A2232")
    static let darkCardBackground = Color(hex: "263345")
    static let darkShadow = Color.white.opacity(0.1)
    static let darkBorder = Color.white.opacity(0.1)
    
    // Stat Colors
    static let stepColor = Color(hex: "4CAF50")
    static let caloriesColor = Color(hex: "FF9800")
    static let activeColor = Color(hex: "9C27B0")
    static let heartRateColor = Color(hex: "F44336")
    
    // Color scheme aware colors
    static let primaryTextColor = Color(
        light: Color(red: 0.2, green: 0.2, blue: 0.2),
        dark: Color(red: 1, green: 1, blue: 1)
    )
    
    static let secondaryTextColor = Color(
        light: Color(red: 0.4, green: 0.4, blue: 0.4),
        dark: Color(red: 0.7, green: 0.7, blue: 0.7)
    )
    
    // Heart Icon Colors
    static let heartIconColor = Color(
        light: .red,
        dark: Color(red: 1, green: 0.2, blue: 0.2)
    )
    
    // Background Colors
    static let backgroundColor = Color(
        light: Color(red: 0.95, green: 0.95, blue: 0.97),
        dark: Color(red: 0.11, green: 0.11, blue: 0.12)
    )
}
