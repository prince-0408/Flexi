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
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.11, green: 0.11, blue: 0.12) : Color(red: 0.95, green: 0.95, blue: 0.97)
    }
    
    private var primaryTextColor: Color {
        colorScheme == .dark ? .white : .black.opacity(0.8)
    }
    
    private var secondaryTextColor: Color {
        colorScheme == .dark ? .white.opacity(0.7) : .black.opacity(0.6)
    }
    
    private func createSpinePath(in geometry: GeometryProxy) -> Path {
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let radius = min(geometry.size.width, geometry.size.height) / 2
        
        return Path { path in
            let spineStart = CGPoint(x: center.x, y: center.y - radius * 0.3)
            let spineEnd = CGPoint(x: center.x, y: center.y + radius * 0.3)
            
            let controlPoint = CGPoint(
                x: center.x + sin(animationProgress * .pi * 2) * radius * 0.2,
                y: center.y
            )
            
            path.move(to: spineStart)
            path.addQuadCurve(to: spineEnd, control: controlPoint)
        }
    }
    
    private func createJoints(in geometry: GeometryProxy) -> [CGPoint] {
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let radius = min(geometry.size.width, geometry.size.height) / 2
        
        return [
            CGPoint(x: center.x, y: center.y - radius * 0.3), // Head
            CGPoint(x: center.x - radius * 0.4, y: center.y), // Left Shoulder
            CGPoint(x: center.x + radius * 0.4, y: center.y), // Right Shoulder
            CGPoint(x: center.x - radius * 0.3, y: center.y + radius * 0.5), // Left Hip
            CGPoint(x: center.x + radius * 0.3, y: center.y + radius * 0.5) // Right Hip
        ]
    }
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.7),
                        Color.purple.opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .clipShape(Circle())
                
                GeometryReader { geometry in
                    Canvas { context, size in
                        // Draw Spine
                        let spinePath = createSpinePath(in: geometry)
                        context.stroke(
                            spinePath,
                            with: .color(.white.opacity(0.8)),
                            lineWidth: 3
                        )
                        
                        // Draw Joints
                        let joints = createJoints(in: geometry)
                        joints.forEach { joint in
                            context.fill(
                                Path(ellipseIn: CGRect(
                                    x: joint.x - 2,
                                    y: joint.y - 2,
                                    width: 4,
                                    height: 4
                                )),
                                with: .color(.white.opacity(0.6))
                            )
                        }
                    }
                }
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: 2)
                        .repeatForever(autoreverses: true)
                    ) {
                        animationProgress = 1
                    }
                }
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text("Posture Health")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(primaryTextColor)
                    
                    Spacer()
                    
                    Text("Today")
                        .font(.system(size: 9))
                        .foregroundColor(secondaryTextColor)
                }
                
                HStack(alignment: .bottom, spacing: 4) {
                    Text("Great")
                        .font(.system(size: 10))
                        .foregroundColor(.green)
                    
                    Text("Progress")
                        .font(.system(size: 9))
                        .foregroundColor(secondaryTextColor)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    colorScheme == .dark
                        ? Color.white.opacity(0.05)
                        : Color.black.opacity(0.05)
                )
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    colorScheme == .dark
                        ? Color.white.opacity(0.1)
                        : Color.black.opacity(0.1),
                    lineWidth: 0.5
                )
        )
    }
}

// Optional: Add a preview for design iterations
struct PostureHealthView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PostureHealthView()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.light)
            
            PostureHealthView()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
