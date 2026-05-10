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
        HStack(spacing: 12) {
            // Left: Greeting and Date
            VStack(alignment: .leading, spacing: 2) {
                Text(greeting.uppercased())
                    .font(DesignSystem.captionText)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                
                Text("PRINCE")
                    .font(DesignSystem.primaryTitle)
                    .foregroundColor(textColors.primary)
            }
            
            Spacer()
            
            // Right: Time of Day Icon in a circular glass well
            ZStack {
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 36, height: 36)
                
                Image(systemName: timeOfDayIcon)
                    .foregroundColor(textColors.primary)
                    .font(.system(size: 18, weight: .semibold))
            }
        }
        .padding(12)
        .background(Color.clear)
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
