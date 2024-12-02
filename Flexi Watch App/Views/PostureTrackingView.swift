//
//  PostureTrackingView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//


import SwiftUI
import Charts
import CoreMotion

struct PostureTrackingView: View {
    @EnvironmentObject var healthManager: HealthManager
//    @State private var postureAnalysis: PostureAnalysisModel = PostureAnalysisModel()
    @StateObject private var postureAnalysis = PostureAnalysisModel()

    @State private var showDetailedAnalysis = false
    @Environment(\.colorScheme) private var colorScheme
    
    // Custom color definitions
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.95, green: 0.95, blue: 0.97)
    }
    
    private var cardBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.18, green: 0.18, blue: 0.20) : .white
    }
    
    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : Color(red: 0.2, green: 0.2, blue: 0.2)
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark ? Color(red: 0.7, green: 0.7, blue: 0.7) : Color(red: 0.4, green: 0.4, blue: 0.4)
    }
    
    private var toggleButtonColor: Color {
        colorScheme == .dark ? Color.blue.opacity(0.3) : Color.blue.opacity(0.1)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Custom Background View
                CustomBackgroundView(geometry: geometry, colorScheme: colorScheme)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Posture Tracking")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(primaryTextColor)
                            
                            Text("Monitor your posture health")
                                .font(.subheadline)
                                .foregroundColor(secondaryTextColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        // Posture Score Card
                        PostureScoreCardView(score: postureAnalysis.currentPostureScore)
                            .background(cardBackgroundColor)
                            .cornerRadius(15)
                            .shadow(color: colorScheme == .dark ? .clear : .gray.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                        
                        // Posture Trend Chart
                        PostureTrendChartView(postureData: postureAnalysis.postureReadings)
                            .background(cardBackgroundColor)
                            .cornerRadius(15)
                            .shadow(color: colorScheme == .dark ? .clear : .gray.opacity(0.1), radius: 5, x: 0, y: 2)
                            .padding(.horizontal)
                        
                        // Detailed Insights Section
                        if showDetailedAnalysis {
                            PostureInsightsView()  // No arguments
                                .background(cardBackgroundColor)
                                .cornerRadius(15)
                                .shadow(color: colorScheme == .dark ? .clear : .gray.opacity(0.1), radius: 5, x: 0, y: 2)
                                .padding(.horizontal)
                                .transition(.asymmetric(insertion: .scale, removal: .opacity))
                        }
                        
                        // Toggle Detailed Analysis Button
                        Button(action: {
                            withAnimation(.spring()) {
                                showDetailedAnalysis.toggle()
                            }
                        }) {
                            Text(showDetailedAnalysis ? "Hide Details" : "Show Detailed Analysis")
                                .foregroundColor(primaryTextColor)
                                .padding()
                                .background(toggleButtonColor)
                                .cornerRadius(10)
                        }
                        .padding(.bottom)
                    }
                }
                .zIndex(1)
            }
        }
        .onAppear {
            postureAnalysis.startContinuousTracking()
        }
        .onDisappear {
            postureAnalysis.stopTracking()
        }
    }
    
    // Custom Background View
    struct CustomBackgroundView: View {
        let geometry: GeometryProxy
        let colorScheme: ColorScheme
        
        var body: some View {
            ZStack {
                // Gradient Background
                LinearGradient(
                    gradient: Gradient(colors: colorScheme == .dark
                                       ? [Color.black, Color(red: 0.1, green: 0.1, blue: 0.15)]
                                       : [Color(red: 0.95, green: 0.95, blue: 0.97), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Subtle Geometric Pattern
                GeometryBackground(geometry: geometry, colorScheme: colorScheme)
            }
        }
    }
    
    // Geometric Background Pattern
    struct GeometryBackground: View {
        let geometry: GeometryProxy
        let colorScheme: ColorScheme
        
        var body: some View {
            ZStack {
                // Subtle geometric shapes
                ForEach(0..<10) { index in
                    Circle()
                        .fill(colorScheme == .dark
                              ? Color.white.opacity(0.05)
                              : Color.blue.opacity(0.05))
                        .frame(width: CGFloat.random(in: 50...200),
                               height: CGFloat.random(in: 50...200))
                        .position(x: CGFloat.random(in: 0...geometry.size.width),
                                  y: CGFloat.random(in: 0...geometry.size.height))
                        .blur(radius: 10)
                }
            }
        }
    }
}
    #Preview("Light Mode - Default") {
        NavigationView {
            PostureTrackingView()
                .environmentObject(HealthManager())
                .environment(\.colorScheme, .light)
        }
    }
    
    #Preview("Dark Mode - Default") {
        NavigationView {
            PostureTrackingView()
                .environmentObject(HealthManager())
                .environment(\.colorScheme, .dark)
        }
    }

