//
//  PostureHealthView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//

import SwiftUI

struct PostureHealthView: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var animationProgress: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 16) {
            // Left: Glowing Kinetic Icon
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            gradient: Gradient(colors: [Color.green.opacity(0.5), .clear]),
                            center: .center,
                            startRadius: 0,
                            endRadius: 25
                        )
                    )
                    .scaleEffect(1.0 + (animationProgress * 0.2))
                
                GeometryReader { geometry in
                    Canvas { context, size in
                        let center = CGPoint(x: size.width / 2, y: size.height / 2)
                        let radius = min(size.width, size.height) / 2
                        
                        // Draw Spine (simplified kinetic)
                        let spinePath = Path { path in
                            path.move(to: CGPoint(x: center.x, y: center.y - radius * 0.4))
                            path.addQuadCurve(
                                to: CGPoint(x: center.x, y: center.y + radius * 0.4),
                                control: CGPoint(x: center.x + sin(animationProgress * .pi * 2) * 4, y: center.y)
                            )
                        }
                        
                        context.stroke(spinePath, with: .color(.white), lineWidth: 3)
                        
                        // Orbital particles
                        for i in 0..<3 {
                            let angle = (animationProgress * .pi * 2) + (Double(i) * .pi * 2 / 3)
                            let pos = CGPoint(
                                x: center.x + cos(angle) * (radius * 0.8),
                                y: center.y + sin(angle) * (radius * 0.8)
                            )
                            context.fill(Path(ellipseIn: CGRect(x: pos.x - 2, y: pos.y - 2, width: 4, height: 4)), with: .color(.white.opacity(0.8)))
                        }
                    }
                }
            }
            .frame(width: 44, height: 44)
            
            // Right: Status Information
            VStack(alignment: .leading, spacing: 0) {
                Text("POSTURE STATUS")
                    .font(DesignSystem.captionText)
                    .fontWeight(.bold)
                    .foregroundColor(.white.opacity(0.6))
                
                Text("EXCELLENT")
                    .font(DesignSystem.primaryTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.green)
                    .shadow(color: .green.opacity(0.3), radius: 5)
                
                Text("Your spine is perfectly aligned.")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.white.opacity(0.4))
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(14)
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                animationProgress = 1
            }
        }
    }
}

struct PostureHealthView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            PostureHealthView()
                .glassyCard()
                .padding()
        }
    }
}
