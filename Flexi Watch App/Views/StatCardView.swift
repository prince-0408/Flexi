//
//  StatCardView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct StatItemView: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 12, weight: .bold))
            
            Text(title)
                .font(.system(size: 9))
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(4)
    }
}
