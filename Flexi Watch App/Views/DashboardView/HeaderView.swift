//
//  HeaderView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct HeaderView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentTime = Date()
    
    let watchSize: WatchSize
    
    // Text color adaptation
    private var textColors: (primary: Color, secondary: Color) {
        colorScheme == .dark
        ? (primary: Color.white, secondary: Color.gray)
        : (primary: Color.black, secondary: Color.gray)
    }
    
    // Greeting based on time
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: currentTime)
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<22: return "Good Evening"
        default: return "Good Night"
        }
    }
    
    // Watch Size Enum
    enum WatchSize {
        case small, medium, large
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 16
            case .medium: return 20
            case .large: return 24
            }
        }
        
        var greetingFontSize: CGFloat {
            switch self {
            case .small: return 14
            case .medium: return 16
            case .large: return 18
            }
        }
        
        var dateFontSize: CGFloat {
            switch self {
            case .small: return 10
            case .medium: return 12
            case .large: return 14
            }
        }
        
        var padding: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 12
            case .large: return 16
            }
        }
    }
    
    init(watchSize: WatchSize = .medium) {
        self.watchSize = watchSize
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    // Time of Day Icon
                    Image(systemName: timeOfDayIcon)
                        .foregroundColor(textColors.primary)
                        .font(.system(size: watchSize.iconSize))
                    
                    Text(greeting)
                        .font(.system(size: watchSize.greetingFontSize, weight: .medium, design: .rounded))
                        .foregroundColor(textColors.primary)
                        .lineLimit(1)
                }
                
                Text(currentTime, style: .date)
                    .font(.system(size: watchSize.dateFontSize))
                    .foregroundColor(textColors.secondary)
            }
            
            Spacer()
            
            // Health Icon
            Image(systemName: "heart.fill")
                .foregroundColor(Color.red)
                .font(.system(size: watchSize.iconSize))
        }
        .padding(watchSize.padding)
        .background(
            backgroundColor
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
    
    // Time of Day Icon
    private var timeOfDayIcon: String {
        let hour = Calendar.current.component(.hour, from: currentTime)
        switch hour {
        case 5..<12: return "sunrise.fill"
        case 12..<17: return "sun.max.fill"
        case 17..<22: return "sunset.fill"
        default: return "moon.fill"
        }
    }
    
    // Background Color
    private var backgroundColor: Color {
        colorScheme == .dark
        ? Color.white.opacity(0.05)
        : Color.white
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HeaderView(watchSize: .small)
                .previewLayout(.sizeThatFits)
                .padding()
                .preferredColorScheme(.light)
            
            HeaderView(watchSize: .small)
                .previewLayout(.sizeThatFits)
                .padding()
                .preferredColorScheme(.dark)
            
                    }
                }
            }
