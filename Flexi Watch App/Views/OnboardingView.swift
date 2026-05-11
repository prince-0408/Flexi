//
//  OnboardingView.swift
//  Flexi
//
//  Created by Prince Yadav on 11/05/26.
//
import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var isCalibrating = false
    @State private var calibrationProgress: CGFloat = 0
    @AppStorage("OnboardingCompleted") private var onboardingCompleted = false
    
    @EnvironmentObject var healthManager: HealthManager
    @EnvironmentObject var motionManager: MotionManager
    
    private let totalPages = 4
    
    var body: some View {
        ZStack {
            // Background Layer
            LiquidBackground()
                .edgesIgnoringSafeArea(.all)
                .hueRotation(.degrees(Double(currentPage) * 45))
                .animation(.interactiveSpring(response: 1.2, dampingFraction: 0.8), value: currentPage)
            
            // Content Layer
            VStack(spacing: 0) {
                // Header
                Text("FLEXI")
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .kerning(4)
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.top, 10)
                
                Spacer()
                
                // Active Slide
                ZStack {
                    switch currentPage {
                    case 0: WelcomeSlideView()
                    case 1: CalibrationSlideView(progress: $calibrationProgress, isCalibrating: $isCalibrating)
                    case 2: PermissionsSlideView()
                    case 3: ReadySlideView(action: finishOnboarding)
                    default: EmptyView()
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity).combined(with: .scale(scale: 0.9)),
                    removal: .move(edge: .top).combined(with: .opacity).combined(with: .scale(scale: 1.1))
                ))
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: currentPage)
                
                Spacer()
                
                // Navigation Bar (Fixed Position)
                HStack(spacing: 0) {
                    // Back Area
                    ZStack {
                        if currentPage > 0 {
                            OnboardingNavButton(icon: "arrow.up", action: goBack)
                        }
                    }
                    .frame(width: 45)
                    
                    Spacer()
                    
                    // Center Indicators
                    HStack(spacing: 6) {
                        ForEach(0..<totalPages, id: \.self) { i in
                            Circle()
                                .fill(i == currentPage ? .white : .white.opacity(0.2))
                                .frame(width: 5, height: 5)
                                .scaleEffect(i == currentPage ? 1.4 : 1.0)
                        }
                    }
                    
                    Spacer()
                    
                    // Next Area
                    ZStack {
                        if currentPage < totalPages - 1 {
                            OnboardingNavButton(icon: "arrow.down", action: handleNext, isPrimary: true)
                        }
                    }
                    .frame(width: 45)
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 22)
            }
        }
    }
    
    private func handleNext() {
        HapticManager.shared.playSelection()
        if currentPage == 1 {
            if calibrationProgress < 1.0 {
                isCalibrating = true
                startCalibrationTimer()
                motionManager.checkMotionPermission()
            } else { nextPage() }
        } else if currentPage == 2 {
            healthManager.requestHealthKitAuthorization()
            motionManager.setupHeadphoneMotion()
            nextPage()
        } else { nextPage() }
    }
    
    private func goBack() {
        HapticManager.shared.playSelection()
        withAnimation { if currentPage > 0 { currentPage -= 1 } }
    }
    
    private func nextPage() {
        withAnimation { if currentPage < totalPages - 1 { currentPage += 1 } }
    }
    
    private func finishOnboarding() {
        HapticManager.shared.playSuccess()
        withAnimation { onboardingCompleted = true }
    }
    
    private func startCalibrationTimer() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            calibrationProgress += 0.02
            if calibrationProgress >= 1.0 {
                timer.invalidate()
                isCalibrating = false
                HapticManager.shared.playSuccess()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { nextPage() }
            }
        }
    }
}

struct OnboardingNavButton: View {
    let icon: String
    let action: () -> Void
    var isPrimary: Bool = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isPrimary ? .white : .white.opacity(0.15))
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(isPrimary ? .black : .white)
            }
            .frame(width: 40, height: 40)
            .shadow(color: isPrimary ? .white.opacity(0.2) : .clear, radius: 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct WelcomeSlideView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "figure.walk.motion")
                .font(.system(size: 45, weight: .thin))
                .foregroundStyle(.blue.gradient)
            
            Text("WELCOME")
                .font(DesignSystem.sectionHeader)
            
            Text("Fluid, strong, resilient.")
                .font(DesignSystem.bodyText)
                .foregroundColor(.white.opacity(0.6))
        }
    }
}

struct CalibrationSlideView: View {
    @Binding var progress: CGFloat
    @Binding var isCalibrating: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Text("CALIBRATION")
                .font(DesignSystem.sectionHeader)
            
            ZStack {
                Circle().stroke(Color.white.opacity(0.05), lineWidth: 8).frame(width: 90, height: 90)
                Circle().trim(from: 0, to: progress).stroke(AngularGradient(colors: [.blue, .cyan, .blue], center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round)).frame(width: 90, height: 90).rotationEffect(.degrees(-90)).shadow(color: .blue.opacity(0.3), radius: 8)
                Image(systemName: progress >= 1.0 ? "checkmark" : "arrow.up").font(.title3.bold()).foregroundColor(progress >= 1.0 ? .green : .white)
            }
            Text(isCalibrating ? "ANALYZING..." : (progress >= 1.0 ? "DONE" : "Tap down to start."))
                .font(.system(size: 8, weight: .black)).foregroundColor(.white.opacity(0.4))
        }
    }
}

struct PermissionsSlideView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("ECOSYSTEM")
                .font(DesignSystem.sectionHeader)
            
            VStack(spacing: 6) {
                CompactPermissionRow(icon: "heart.fill", title: "Health", color: .red)
                CompactPermissionRow(icon: "headphones", title: "AirPods", color: .blue)
            }
            .padding(.horizontal, 10)
        }
    }
}

struct CompactPermissionRow: View {
    let icon: String
    let title: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(color)
                .frame(width: 22, height: 22)
                .background(color.opacity(0.1), in: Circle())
            
            Text(title)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
            
            Spacer()
            
            Circle()
                .fill(.white.opacity(0.1))
                .frame(width: 14, height: 14)
                .overlay(Image(systemName: "checkmark").font(.system(size: 7, weight: .black)))
        }
        .padding(8)
        .glassyCard()
    }
}

struct ReadySlideView: View {
    let action: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Text("YOU ARE READY")
                .font(DesignSystem.sectionHeader)
            
            Button(action: action) {
                Text("BEGIN")
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.black)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 14)
                    .background(Color.white, in: Capsule())
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
