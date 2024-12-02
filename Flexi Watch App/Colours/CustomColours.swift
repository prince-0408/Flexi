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
    // Primary Color Gradients
    static let primaryColorLight = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "3498DB"),
            Color(hex: "2980B9"),
            Color(hex: "1A5F7A")
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let primaryColorDark = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "4ECDC4"),
            Color(hex: "45B39D"),
            Color(hex: "2C8C6C")
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Background Colors
    static let lightBackground = Color(
        light: Color(hex: "FFFFFF"),
        dark: Color(hex: "1A1A2E")
    )
    
    static let cardBackground = Color(
        light: Color(hex: "F0F4F8"),
        dark: Color(hex: "16213E")
    )
    
    // Text Colors
    static let primaryTextColor = Color(
        light: Color(hex: "34495E"),
        dark: Color(hex: "E0E6EE")
    )
    
    static let secondaryTextColor = Color(
        light: Color(hex: "2C3E50"),
        dark: Color(hex: "F0F4F8")
    )
    
    // Accent Colors
    static let accentColor = LinearGradient(
        gradient: Gradient(colors: [
            Color(
                light: Color(hex: "E74C3C"),
                dark: Color(hex: "FF6B6B")
            ),
            Color(
                light: Color(hex: "C0392B"),
                dark: Color(hex: "FF4757")
            )
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Interactive Elements
    static let interactiveColor = LinearGradient(
        gradient: Gradient(colors: [
            Color(
                light: Color(hex: "2ECC71"),
                dark: Color(hex: "48C774")
            ),
            Color(
                light: Color(hex: "27AE60"),
                dark: Color(hex: "3BA55D")
            )
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Stat Colors
    static let stepColor = Color(hex: "4CAF50")
    static let caloriesColor = Color(hex: "FF9800")
    static let activeColor = Color(hex: "9C27B0")
    static let heartRateColor = Color(hex: "F44336")
    
    // Shadow and Border Colors
    static let shadowColor = Color(
        light: Color.black.opacity(0.1),
        dark: Color.white.opacity(0.1)
    )
    
    static let borderColor = Color(
        light: Color.black.opacity(0.05),
        dark: Color.white.opacity(0.1)
    )
}


