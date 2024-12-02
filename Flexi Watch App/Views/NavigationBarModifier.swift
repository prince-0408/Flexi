//
//  NavigationBarModifier.swift
//  Flexi
//
//  Created by Prince Yadav on 03/12/24.
//
import SwiftUI

struct NavigationBarModifier: ViewModifier {
    var backgroundColor: Color?
    var titleColor: Color?
    var title: String

    init(
        backgroundColor: Color? = nil,
        titleColor: Color? = nil,
        title: String = "Today"
    ) {
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.title = title
    }

    func body(content: Content) -> some View {
        content
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(false)
            #if !os(watchOS)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(titleColor ?? .white)
                }
            }
            #endif
            .toolbarBackground(
                backgroundColor ?? Color.black.opacity(0.2),
                for: .navigationBar
            )
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// Extension to make it more flexible
extension View {
    func navigationBarColor(
        backgroundColor: Color? = nil,
        titleColor: Color? = nil,
        title: String = "Today"
    ) -> some View {
        self.modifier(
            NavigationBarModifier(
                backgroundColor: backgroundColor,
                titleColor: titleColor,
                title: title
            )
        )
    }
}
