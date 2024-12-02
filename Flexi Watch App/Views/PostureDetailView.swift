//
//  PostureDetailView.swift
//  Flexi
//
//  Created by Prince Yadav on 17/12/24.
//

import SwiftUI

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


struct PostureDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostureDetailView(score: Double())
            .colorScheme(.light)
    }
}
