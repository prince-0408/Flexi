//
//  DashboardView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//


import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject var healthManager: HealthManager
    @State private var selectedMetric: String = "Steps"
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    // Dynamic Header with 3D Effect
                    HeaderView()
                    
                    // Activity Overview Chart
                    ActivityChartView()
                        .frame(height: geometry.size.height * 0.3)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.blue.opacity(0.1))
                        )
                        .shadow(radius: 5)
                    
                    // Quick Stats Grid
                    QuickStatsGridView()
                    
                    // Posture Health Indicators
                    PostureHealthView()
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
}
