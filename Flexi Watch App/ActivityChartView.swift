//
//  ActivityChartView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI
import Charts

struct ActivityChartView: View {
    @State private var selectedMetric = "Steps"
    
    var body: some View {
        Chart {
            BarMark(
                x: .value("Day", "Today"),
                y: .value("Steps", 8500)
            )
            .foregroundStyle(Color.blue.gradient)
            .interpolationMethod(.catmullRom)
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .animation(.spring(), value: selectedMetric)
    }
}
