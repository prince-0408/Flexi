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
            VStack(spacing: 20) {
                headerSection()
                activitySection()
                quickStatsSection()
                healthMetricsSection()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
    
    private func headerSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Hello")
                .font(.headline)
                .foregroundColor(primaryTextColor)
            
            HeaderView()
                .frame(height: 68)
                .background(sectionBackground)
                .cornerRadius(12)
        }
    }
    
    private func activitySection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Activity Insights")
                .font(.headline)
                .foregroundColor(primaryTextColor)
            
            ActivityLineChartView()
                .frame(height: 150)
                .background(sectionBackground)
                .cornerRadius(12)
        }
    }
    
    private func quickStatsSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Quick Stats")
                .font(.headline)
                .foregroundColor(primaryTextColor)
            
            QuickStatsView()
                .frame(height: 150)
                .background(sectionBackground)
                .cornerRadius(12)
        }
    }
    
    private func healthMetricsSection() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Posture Health")
                .font(.headline)
                .foregroundColor(primaryTextColor)
            
            PostureHealthView()
                .background(sectionBackground)
                .cornerRadius(12)
        }
    }
    
    // Reusable background for sections
    private var sectionBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.clear)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
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
