import SwiftUI

struct GlassyCard: ViewModifier {
    var cornerRadius: CGFloat = 20
    var borderColor: Color = .white.opacity(0.3)
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.clear)
                    .background(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [borderColor, .clear, borderColor.opacity(0.1)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

extension View {
    func glassyCard(cornerRadius: CGFloat = 20, borderColor: Color = .white.opacity(0.3)) -> some View {
        self.modifier(GlassyCard(cornerRadius: cornerRadius, borderColor: borderColor))
    }
}

struct DesignSystem {
    static let primaryTitle = Font.system(size: 16, weight: .heavy, design: .rounded)
    static let sectionHeader = Font.system(size: 12, weight: .bold, design: .rounded)
    static let bodyText = Font.system(size: 14, weight: .medium, design: .rounded)
    static let captionText = Font.system(size: 10, weight: .regular, design: .rounded)
    static let massiveMetric = Font.system(size: 44, weight: .heavy, design: .rounded)
}
