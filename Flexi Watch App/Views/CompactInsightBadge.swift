//
//  CompactInsightBadge.swift
//  Flexi
//
//  Created by Prince Yadav on 03/12/24.
//
import SwiftUI

struct CompactInsightBadge: View {
    let icon: String
    let title: String
    let value: String
    let gradient: LinearGradient
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(gradient)
                .font(.system(size: 14))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(gradient)
            }
        }
        .padding(8)
        .background(gradient.opacity(0.1))
        .cornerRadius(10)
    }
}
