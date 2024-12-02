//
//  MainNavigationView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

//import SwiftUI

struct MainNavigationView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                    .tabItem {
                        VStack {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    }
                    .tag(0)
                    .background(Color.clear)
            
            PostureTrackingView()
                .tabItem {
                    VStack {
                        Image(systemName: "figure.stand")
                        Text("Posture")
                    }
                }
                .tag(1)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.green.opacity(0.1),
                            Color.green.opacity(0.05)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            StretchRoutineView(selectedRoutine: .advanced)
                .tabItem {
                    VStack {
                        Image(systemName: "figure.flexibility")
                        Text("Stretch")
                    }
                }
                .tag(2)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.purple.opacity(0.1),
                            Color.purple.opacity(0.05)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
                .tag(3)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.gray.opacity(0.1),
                            Color.gray.opacity(0.05)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white,
                    Color.white.opacity(0.95)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

#Preview {
    MainNavigationView()
        .colorScheme(.dark)
    
}

#Preview {
    MainNavigationView()
        .colorScheme(.light)
    
}
