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
    @State private var postureAnalysis: PostureAnalysisModel = PostureAnalysisModel()
    @State private var showDetailedAnalysis = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Posture Score Card
                PostureScoreCardView(score: postureAnalysis.currentPostureScore)
                
                // Posture Trend Chart
                PostureTrendChartView(postureData: postureAnalysis.postureReadings)
                
                // Detailed Insights Section
                if showDetailedAnalysis {
                    PostureInsightsView(analysis: postureAnalysis)
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                }
                
                // Toggle Detailed Analysis Button
                Button(action: {
                    withAnimation {
                        showDetailedAnalysis.toggle()
                    }
                }) {
                    Text(showDetailedAnalysis ? "Hide Details" : "Show Detailed Analysis")
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Posture Tracking")
        }
        .onAppear {
            postureAnalysis.startContinuousTracking()
        }
        .onDisappear {
            postureAnalysis.stopTracking()
        }
    }
}
