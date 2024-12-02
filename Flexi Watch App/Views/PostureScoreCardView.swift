//
//  PostureScoreCardView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

import SwiftUI

struct PostureScoreCardView: View {
    let score: Double
    @State private var showDetails = false
    
    private var scoreGradient: LinearGradient {
        switch score {
        case 70...100:
            return LinearGradient(
                gradient: Gradient(colors: [.green.opacity(0.7), .green]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 50..<70:
            return LinearGradient(
                gradient: Gradient(colors: [.orange.opacity(0.7), .orange]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                gradient: Gradient(colors: [.red.opacity(0.7), .red]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var scoreDescription: String {
        switch score {
        case 80...100: return "Excellent Posture"
        case 60..<80: return "Good Posture"
        case 40..<60: return "Needs Improvement"
        default: return "Poor Posture"
        }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            // Header Section
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Posture Health")
                        .font(.headline)
                    
                    Text(scoreDescription)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button {
                    showDetails = true
                } label: {
                    Image(systemName: "info.circle.fill")
                        .foregroundStyle(scoreGradient)
                        .font(.title2)
                }
            }
            
            // Circular Score Visualization
            ZStack {
                // Background Circle
                Circle()
                    .stroke(scoreGradient.opacity(0.2), lineWidth: 12)
                
                // Progress Circle
                Circle()
                    .trim(from: 0, to: CGFloat(min(score / 100, 1.0)))
                    .stroke(
                        scoreGradient,
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                
                // Score Text
                VStack(spacing: 4) {
                    Text("\(Int(score))")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(scoreGradient)
                    
                    Text("SCORE")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 180, height: 180)
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray.opacity(0.05))
                .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
        )
        .sheet(isPresented: $showDetails) {
            PostureDetailView(score: score)
                .presentationDetents([.medium, .large])
        }
    }
}

struct PostureDetailView: View {
    let score: Double
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text("Posture Insights")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Score Summary
                HStack {
                    Text("Current Score")
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(score))/100")
                        .fontWeight(.semibold)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                // Recommendations Section
                Text("Recommendations")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 10) {
                    RecommendationItem(
                        icon: "figure.stand",
                        title: "Posture Correction",
                        description: "Focus on core strengthening exercises"
                    )
                    
                    RecommendationItem(
                        icon: "figure.walk",
                        title: "Movement Breaks",
                        description: "Take short walks every hour"
                    )
                }
            }
            .padding()
        }
    }
}

struct RecommendationItem: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title2)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct PostureScoreCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PostureScoreCardView(score: 85)
            PostureScoreCardView(score: 55)
            PostureScoreCardView(score: 35)
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
