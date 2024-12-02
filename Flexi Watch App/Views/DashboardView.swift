//
//  DashboardView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//


import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject var healthManager: HealthManager
    @State private var selectedMetric: String = "Steps"
    
    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color.black.opacity(0.9),
                        Color.black.opacity(0.8),
                        Color(hex: "#1A1A2E") // Assuming you have a Color extension for hex
                    ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .center, spacing: 12) {
                    HeaderView()
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.3))
                        )
                    
                    ActivityLineChartView()
                        .frame(height: 200)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.2))
                        )
                    
                    QuickStatsView()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.2))
                        )
                    
                    PostureHealthView()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.black.opacity(0.2))
                        )
                }
                .padding(12)
            }
            .navigationTitle("Today")
            .navigationBarColor(
                backgroundColor: Color.clear,
                titleColor: Color.white
            )
        }
    }
}

// Color extension for hex initialization
//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3: // RGB (12-bit)
//            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: // RGB (24-bit)
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: // ARGB (32-bit)
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (a, r, g, b) = (1, 1, 1, 0)
//        }
//
//        self.init(
//            .sRGB,
//            red: Double(r) / 255,
//            green: Double(g) / 255,
//            blue:  Double(b) / 255,
//            opacity: Double(a) / 255
//        )
//    }
//}

// Navigation Bar Color Extension
extension View {
    func navigationBarColor(
        backgroundColor: Color = .clear,
        titleColor: Color = .white
    ) -> some View {
        self.modifier(NavigationBarModifier(
            backgroundColor: backgroundColor,
            titleColor: titleColor
        ))
    }
}

//struct NavigationBarModifier: ViewModifier {
//    var backgroundColor: Color
//    var titleColor: Color
//
//    func body(content: Content) -> some View {
//        content
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbarBackground(
//                backgroundColor,
//                for: .navigationBar
//            )
//            .toolbarColorScheme(.dark, for: .navigationBar)
//    }
//}


// Optional Navigation Bar Color Extension
extension View {
    // Version accepting UIColor
    func navigationBarColor(backgroundColor: UIColor?, titleColor: UIColor?) -> some View {
        self.modifier(NavigationBarModifier(
            backgroundColor: backgroundColor != nil ? Color(uiColor: backgroundColor!) : nil,
            titleColor: titleColor != nil ? Color(uiColor: titleColor!) : nil
        ))
    }
    
    // Version accepting Color
    func navigationBarColor(backgroundColor: Color?, titleColor: Color?) -> some View {
        self.modifier(NavigationBarModifier(
            backgroundColor: backgroundColor,
            titleColor: titleColor
        ))
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DashboardView()
                .preferredColorScheme(.light)
            
            DashboardView()
                .preferredColorScheme(.dark)
        }
        .environmentObject(HealthManager())
    }
}
