//
//  PostureTrendChartView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI
import Charts

struct PostureTrendChartView: View {
    let postureData: [PostureReading]
    
    var body: some View {
        Chart {
            ForEach(postureData, id: \.timestamp) { reading in
                LineMark(
                    x: .value("Time", reading.timestamp),
                    y: .value("Pitch", reading.pitch)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(Color.blue.gradient)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .frame(height: 200)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(10)
    }
}
