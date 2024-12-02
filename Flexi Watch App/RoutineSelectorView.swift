//
//  RoutineSelectorView 2.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import SwiftUI

struct RoutineSelectorView: View {
    @Binding var selectedRoutine: StretchRoutine
    
    var body: some View {
        Picker("Select Routine", selection: $selectedRoutine) {
            ForEach(StretchRoutine.allCases, id: \.self) { routine in
                Text(routine.rawValue).tag(routine)
            }
        }
        #if os(watchOS)
        .pickerStyle(WheelPickerStyle())
        #else
        .pickerStyle(SegmentedPickerStyle())
        #endif
        .padding()
    }
}


struct RoutineSelectorView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedRoutine: StretchRoutine = .beginner
        
        var body: some View {
            RoutineSelectorView(selectedRoutine: $selectedRoutine)
        }
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
