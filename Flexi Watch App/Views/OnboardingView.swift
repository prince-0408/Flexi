//
//  OnboardingView.swift
//  Flexi
//
//  Created by Prince Yadav on 12/12/24.
//

import SwiftUI
import HealthKit
import UserNotifications

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var showMainApp = false
    @Environment(\.colorScheme) private var colorScheme
    
    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : .black.opacity(0.8)
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.6)
    }
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.95, green: 0.95, blue: 0.97)
    }
    
    private func playHapticFeedback() {
         WKInterfaceDevice.current().play(.click)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CustomBackgroundView(geometry: geometry, colorScheme: colorScheme)
                    .edgesIgnoringSafeArea(.all)
                
                if showMainApp {
                    MainNavigationView()
                } else {
                    onboardingContent
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    private func backgroundView() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.1, green: 0.1, blue: 0.2),
                Color(red: 0.15, green: 0.15, blue: 0.25)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .edgesIgnoringSafeArea(.all)
    }
    
    
    private var onboardingContent: some View {
        ZStack {
            // Page Content
            TabView(selection: $currentPage) {
                welcomePage
                    .tag(0)
                
                FeaturesCarouselView()
                    .tag(1)
                
                permissionsPage
                    .tag(2)
                
                finalSetupPage
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // Bottom Navigation Container
            VStack {
                Spacer()
                HStack(spacing: 15) {
                    // Back Button (Bottom Left)
                    if currentPage > 0 {
                        backButton
                    }
                    
                    // Page Indicator (Centered)
                    pageIndicator()
                    
                    // Next/Finish Button (Bottom Right)
                    nextButton
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
        }
    }

    private var backButton: some View {
        Button(action: previousPage) {
            Image(systemName: "chevron.left")
                .font(.headline)
                .foregroundColor(secondaryTextColor)
                .padding(10)
                .background(
                    Circle()
                        .fill(colorScheme == .dark
                            ? Color.white.opacity(0.1)
                            : Color.black.opacity(0.05))
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var nextButton: some View {
        Button(action: nextPage) {
            Text(currentPage == 3 ? "Finish" : "Next")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(primaryTextColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(colorScheme == .dark
                            ? Color.white.opacity(0.1)
                            : Color.black.opacity(0.05))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(colorScheme == .dark
                            ? Color.white.opacity(0.2)
                            : Color.black.opacity(0.1),
                            lineWidth: 0.5)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func pageIndicator() -> some View {
        HStack(spacing: 6) {
            ForEach(0..<4) { index in
                Capsule()
                    .fill(currentPage == index ? Color.white : Color.white.opacity(0.2))
                    .frame(
                        width: currentPage == index ? 20 : 8,
                        height: 4
                    )
                    .animation(
                        .interpolatingSpring(
                            stiffness: 300,
                            damping: 15
                        ),
                        value: currentPage
                    )
                    .transition(.scale)
            }
        }
    }
    
    private var sectionBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(colorScheme == .dark
                  ? Color.white.opacity(0.05)
                  : Color.black.opacity(0.03))
    }
    
    private var welcomePage: some View {
        VStack(spacing: 15) {
            Image(systemName: "figure.walk.motion")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.6),
                            Color.purple.opacity(0.6)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Circle())
                .shadow(radius: 10)
            
            Text("Flexi")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(primaryTextColor)
            
            Text("Your Wellness Companion")
                .font(.caption)
                .foregroundColor(secondaryTextColor)
        }
        .padding()
    }

    

    private var permissionsPage: some View {
        ScrollView {
            VStack(spacing: 15) {
                Text("Permissions")
                    .font(.headline)
                    .foregroundColor(primaryTextColor)
                
                VStack(spacing: 12) {
                    permissionRow(
                        icon: "figure.walk.motion",
                        title: "Motion Access",
                        isGranted: true
                    )
                    
                    permissionRow(
                        icon: "heart.text.square.fill",
                        title: "Health Data",
                        isGranted: false
                    )
                    
                    permissionRow(
                        icon: "bell.badge.fill",
                        title: "Notifications",
                        isGranted: false
                    )
                }
                .padding()
            }
        }
    }

    private func permissionRow(icon: String, title: String, isGranted: Bool) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(isGranted ? .green : .white.opacity(0.5))
            
            Text(title)
                .font(.headline)
                .foregroundColor(primaryTextColor)
            
            Spacer()
            
            Image(systemName: isGranted ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                .foregroundColor(isGranted ? .green : .yellow)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(12)
    }

    private var finalSetupPage: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.green)
            
            Text("All Set!")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(primaryTextColor)
            
            Text("Flexi is ready to enhance your wellness journey")
                .font(.caption)
                .foregroundColor(secondaryTextColor)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    private func previousPage() {
        playHapticFeedback()
        withAnimation {
            currentPage = max(0, currentPage - 1)
        }
    }
    
    private func nextPage() {
        playHapticFeedback()
        withAnimation {
            if currentPage < 3 {
                 currentPage += 1
            } else {
                completeOnboarding()
            }
        }
    }
    
    private func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "OnboardingCompleted")
        showMainApp = true
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .colorScheme(.dark)
        
        OnboardingView()
            .colorScheme(.light)
    }
}
