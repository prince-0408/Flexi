//
//  PostureScoreCardView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct PostureScoreCardView: View {
    let score: Double
    
    var body: some View {
        VStack {
            Text("Posture Health Score")
                .font(.headline)
            
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.2), lineWidth: 20)
                
                Circle()
                    .trim(from: 0, to: CGFloat(score / 100))
                    .stroke(
                        score > 70 ? Color.green :
                        score > 50 ? Color.yellow :
                        Color.red,
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(score))")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(
                        score > 70 ? Color.green :
                        score > 50 ? Color.yellow :
                        Color.red
                    )
            }
            .frame(width: 200, height: 200)
        }
    }
}
