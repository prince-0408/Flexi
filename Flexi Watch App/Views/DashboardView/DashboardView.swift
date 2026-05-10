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
    @Environment(\.colorScheme) private var colorScheme

    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.95, green: 0.95, blue: 0.97)
    }
    
    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : .black.opacity(0.8)
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.6)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                    .edgesIgnoringSafeArea(.all)
                
                content
            }
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) { // Increased spacing for better hierarchy
                headerSection()
                activitySection()
                quickStatsSection()
                healthMetricsSection()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 16)
        }
    }
    
    private func headerSection() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("DAILY OVERVIEW")
                .font(DesignSystem.sectionHeader)
                .foregroundColor(.white.opacity(0.8)) // Increased visibility
                .padding(.leading, 8)
            
            HeaderView()
                .glassyCard()
        }
    }
    
    private func activitySection() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("ACTIVITY TREND")
                .font(DesignSystem.sectionHeader)
                .foregroundColor(.white.opacity(0.8))
                .padding(.leading, 8)
            
            ActivityLineChartView()
                .frame(height: 130)
                .glassyCard()
        }
    }
    
    private func quickStatsSection() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("HEALTH METRICS")
                .font(DesignSystem.sectionHeader)
                .foregroundColor(.white.opacity(0.8))
                .padding(.leading, 8)
            
            QuickStatsView()
                .glassyCard()
        }
    }
    
    private func healthMetricsSection() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("POSTURE HEALTH")
                .font(DesignSystem.sectionHeader)
                .foregroundColor(.white.opacity(0.8))
                .padding(.leading, 8)
            
            PostureHealthView()
                .glassyCard()
        }
    }
}



struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DashboardView()
                .preferredColorScheme(.light)
            
            DashboardView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(HealthManager())
    }
}
