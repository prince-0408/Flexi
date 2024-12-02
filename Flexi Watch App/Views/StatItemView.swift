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
    let fontSize: CGFloat
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: fontSize + 2))
            
            Text(title)
                .font(.system(size: fontSize - 2, weight: .medium))
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.system(size: fontSize, weight: .bold))
                .foregroundColor(.primary)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(6)
    }
}
