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
                .tag(0)
            
            PostureTrackingView()
                .tag(1)
            
            StretchRoutineView(selectedRoutine: .advanced)
                .tag(2)
            
            SettingsView()
                .tag(3)
        }
        .tabViewStyle(.verticalPage)
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
