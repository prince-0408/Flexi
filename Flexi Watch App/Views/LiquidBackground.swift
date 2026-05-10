import SwiftUI

@available(watchOS 11.0, *)
public struct LiquidBackground: View {
    @State private var t: Float = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    public init() {}

    public var body: some View {
        MeshGradient(width: 3, height: 3, points: [
            .init(0, 0), .init(0.5, 0), .init(1, 0),
            .init(0, 0.5), .init(0.5 + 0.2 * sin(t), 0.5 + 0.2 * cos(t)), .init(1, 0.5),
            .init(0, 1), .init(0.5, 1), .init(1, 1)
        ], colors: [
            .black, .blue.opacity(0.5), .black,
            .purple.opacity(0.4), .blue.opacity(0.2), .indigo.opacity(0.4),
            .black, .black, .black
        ])
        .ignoresSafeArea()
        .onReceive(timer) { _ in
            withAnimation(.linear(duration: 0.1)) {
                t += 0.05
            }
        }
    }
}
