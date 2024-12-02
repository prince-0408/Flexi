//
//  HeaderView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI
import SwiftUI

struct HeaderView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    // Custom color palette
    private var textColors: (primary: Color, secondary: Color) {
        switch colorScheme {
        case .dark:
            return (
                primary: Color(red: 0.95, green: 0.95, blue: 0.95), // Almost white
                secondary: Color(red: 0.7, green: 0.7, blue: 0.7)   // Light gray
            )
        case .light:
            return (
                primary: Color(red: 0.1, green: 0.1, blue: 0.1),    // Almost black
                secondary: Color(red: 0.3, green: 0.3, blue: 0.3)   // Dark gray
            )
        @unknown default:
            return (
                primary: .primary,
                secondary: .secondary
            )
        }
    }
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: currentTime)
        switch hour {
        case 5..<12: return "Good Morning"
        case 12..<17: return "Good Afternoon"
        case 17..<22: return "Good Evening"
        default: return "Good Night"
        }
    }
    
    private var gradientBackground: LinearGradient {
        let hour = Calendar.current.component(.hour, from: currentTime)
        
        switch hour {
        case 5..<12: // Morning
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.9, green: 0.95, blue: 1),
                    Color(red: 0.7, green: 0.85, blue: 1)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 12..<17: // Afternoon
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 1, green: 0.95, blue: 0.8),
                    Color(red: 1, green: 0.85, blue: 0.6)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 17..<22: // Evening
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.6, green: 0.7, blue: 1),
                    Color(red: 0.4, green: 0.5, blue: 0.9)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default: // Night
            return LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.2, green: 0.2, blue: 0.3),
                    Color(red: 0.1, green: 0.1, blue: 0.2)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var timeOfDayIcon: String {
        let hour = Calendar.current.component(.hour, from: currentTime)
        switch hour {
        case 5..<12: return "sunrise.fill"
        case 12..<17: return "sun.max.fill"
        case 17..<22: return "sunset.fill"
        default: return "moon.fill"
        }
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Image(systemName: timeOfDayIcon)
                        .foregroundColor(textColors.primary)
                        .font(.title3)
                    
                    Text(greeting)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(textColors.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .tracking(0.4)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .animation(.easeInOut(duration: 0.3), value: greeting)
                        .allowsTightening(true)
                        .dynamicTypeSize(.small)
                }
                
                Text(currentTime, style: .date)
                    .font(.caption)
                    .foregroundColor(textColors.secondary)
            }
            
            Spacer()
            
            Button(action: {
                // Interactive heart action
            }) {
                Image(systemName: "heart.fill")
                    .foregroundColor(textColors.primary)
                    .font(.title2)
                    .scaleEffect(1)
                    .animation(.spring(), value: currentTime)
            }
        }
        .padding()
        .background(
            gradientBackground
                .overlay(colorScheme == .dark ? Color.black.opacity(0.2) : Color.clear)
        )
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        .onReceive(timer) { input in
            currentTime = input
        }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HeaderView()
                .previewLayout(.sizeThatFits)
                .padding()
            
            HeaderView()
                .previewLayout(.sizeThatFits)
                .padding()
                .preferredColorScheme(.dark)
        }
    }
}
//struct HeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            HeaderView()
//                .previewLayout(.sizeThatFits)
//                .padding()
//            
//            HeaderView()
//                .previewLayout(.sizeThatFits)
//                .padding()
//                .preferredColorScheme(.dark)
//        }
//    }
//}

