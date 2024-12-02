//
//  Feature.swift
//  Flexi
//
//  Created by Prince Yadav on 13/12/24.
//

import SwiftUI

import SwiftUI

struct FeaturesCarouselView: View {
    @Environment(\.colorScheme) private var colorScheme

    let features: [Feature] = [
        Feature(icon: "figure.walk", title: "Activity", description: "Movement Insights", color: .blue),
        Feature(icon: "heart.fill", title: "Health", description: "Vital Metrics", color: .red),
        Feature(icon: "bolt.fill", title: "Performance", description: "Wellness Goals", color: .green)
    ]
    
    @State private var currentIndex = 0
        
    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : .black.opacity(0.8)
    }
        
    private var secondaryTextColor: Color {
        colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.6)
    }
        
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.95, green: 0.95, blue: 0.97)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Text("Features")
                    .fontWeight(.bold)
                    .foregroundColor(primaryTextColor)
                    .padding(.leading)
                
                ZStack {
                    ForEach(features.indices, id: \.self) { index in
                        FeatureCarouselCard(
                            feature: features[index],
                            primaryTextColor: primaryTextColor,
                            secondaryTextColor: secondaryTextColor,
                            colorScheme: colorScheme
                        )
                        .offset(x: calculateOffset(for: index, in: geometry))
                        .scaleEffect(calculateScale(for: index))
                        .opacity(calculateOpacity(for: index))
                        .zIndex(calculateZIndex(for: index))
                        .animation(.smooth, value: currentIndex)
                    }
                }
                .frame(maxHeight: .infinity)
                .gesture(
                    DragGesture()
                        .onEnded { value in
                            handleSwipeGesture(translation: value.translation)
                        }
                )
                .padding(.bottom, 90)
            }
            .background(backgroundColor)
        }
    }
    
    private func handleSwipeGesture(translation: CGSize) {
        withAnimation {
            if translation.width < -50 {
                // Swipe Left
                currentIndex = min(currentIndex + 1, features.count - 1)
            } else if translation.width > 50 {
                // Swipe Right
                currentIndex = max(currentIndex - 1, 0)
            }
        }
    }
    
    private func calculateOffset(for index: Int, in geometry: GeometryProxy) -> CGFloat {
        let offset = CGFloat(index - currentIndex) * geometry.size.width
        return offset
    }
    
    private func calculateScale(for index: Int) -> CGFloat {
        let diff = abs(index - currentIndex)
        return diff == 0 ? 1.0 : (1.0 - CGFloat(diff) * 0.1)
    }
    
    private func calculateOpacity(for index: Int) -> Double {
        let diff = abs(index - currentIndex)
        return diff == 0 ? 1.0 : (1.0 - Double(diff) * 0.4)
    }
    
    private func calculateZIndex(for index: Int) -> Double {
        return Double(features.count - abs(index - currentIndex))
    }
}

struct FeatureCarouselCard: View {
    let feature: Feature
    let primaryTextColor: Color
    let secondaryTextColor: Color
    let colorScheme: ColorScheme
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack {
                    CustomBackgroundView(
                        geometry: geometry,
                        colorScheme: colorScheme
                    )
                    .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        // Title Section
                        HStack {
                            Text(feature.title)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(primaryTextColor)
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                            
                            Spacer()
                        }
                        .background(feature.color.opacity(0.1))
                        
                        // Card Content
                        VStack(spacing: 10) {
                            // Icon
                            Image(systemName: feature.icon)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(feature.color)
                                .padding(8)
                                .background(
                                    Circle()
                                        .fill(feature.color.opacity(0.15))
                                )
                            
                            // Description
                            Text(feature.description)
                                .font(.system(size: 11))
                                .foregroundColor(secondaryTextColor)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .padding(.horizontal, 6)
                        }
                        .padding()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.05))
                    )
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(feature.color.opacity(0.2), lineWidth: 2)
                    )
                    .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
                }
            }
        }
    }
}



struct FeaturesCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Standard Previews
            FeaturesCarouselView()
                .previewDisplayName("Default View")
            
            // Color Scheme Variations
            FeaturesCarouselView()
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
            
            FeaturesCarouselView()
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")
            
        }
    }
}
