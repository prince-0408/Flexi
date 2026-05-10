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
        .black
    }
    
    private var cardBackgroundColor: Color {
        Color.clear
    }
    
    private var primaryTextColor: Color {
        .white
    }
    
    private var secondaryTextColor: Color {
        Color.white.opacity(0.7)
    }
    
    private var toggleButtonColor: Color {
        Color.blue.opacity(0.3)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Custom Background View
                Color.clear
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header Section
                        VStack(alignment: .leading, spacing: 4) {
                            Text("POSTURE")
                                .font(DesignSystem.sectionHeader)
                                .foregroundColor(.white.opacity(0.6))
                            
                            Text("Continuous Tracking")
                                .font(DesignSystem.primaryTitle)
                                .foregroundColor(primaryTextColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        
                        PostureScoreCardView(score: postureAnalysis.currentPostureScore)
                            .glassyCard()
                            .padding(.horizontal)
                        
                        PostureTrendChartView(postureData: postureAnalysis.postureReadings)
                            .padding(.horizontal)
                        
                        // Detailed Insights Section
                        if showDetailedAnalysis {
                            PostureInsightsView()
                                .padding(.horizontal)
                                .transition(.asymmetric(insertion: .scale, removal: .opacity))
                        }
                        
                        // Toggle Detailed Analysis Button
                        Button(action: {
                            withAnimation(.spring()) {
                                showDetailedAnalysis.toggle()
                            }
                        }) {
                            Text(showDetailedAnalysis ? "Hide Details" : "Show Insights")
                                .font(DesignSystem.bodyText)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.white.opacity(0.1))
                                .cornerRadius(15)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
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
    
    // Custom Background View removed as LiquidBackground is used globally
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

