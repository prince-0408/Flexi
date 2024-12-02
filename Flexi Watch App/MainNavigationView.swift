//
//  MainNavigationView.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct MainNavigationView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                DashboardView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Dashboard")
                    }
                    .tag(0)
                
                PostureTrackingView()
                    .tabItem {
                        Image(systemName: "figure.stand")
                        Text("Posture")
                    }
                    .tag(1)
                
//                StretchRoutineView(selectedRoutine: StretchRoutine(rawValue: String().appending(selectedTab))!)
//                    .tabItem {
//                        Image(systemName: "figure.flexibility")
//                        Text("Stretches")
//                    }
//                    .tag(2)
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(3)
            }
            .navigationTitle("Flexi")
        }
    }
}
