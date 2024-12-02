//
//  WatchSizeConstants.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//

import SwiftUI
import UIKit  // Add this import to use UIScreen

struct WatchSizeConstants {
    // Series 7/8/9/Ultra
    static let largeWidth: CGFloat = 368
    static let largeHeight: CGFloat = 448
    
    // Smaller Apple Watch models
    static let smallWidth: CGFloat = 324
    static let smallHeight: CGFloat = 394
    
    // Detect current device screen size
    static var currentWidth: CGFloat {
        #if os(watchOS)
        return WKInterfaceDevice.current().screenBounds.width
        #else
        return UIScreen.main.bounds.width
        #endif
    }
    
    static var currentHeight: CGFloat {
        #if os(watchOS)
        return WKInterfaceDevice.current().screenBounds.height
        #else
        return UIScreen.main.bounds.height
        #endif
    }
    
    static func adjustForWatchSize<Content: View>(_ view: Content) -> some View {
        view
            .frame(
                width: currentWidth,
                height: currentHeight
            )
    }
}

extension View {
    func watchScreenOptimized() -> some View {
        self
            .frame(
                width: WatchSizeConstants.largeWidth,
                height: WatchSizeConstants.largeHeight
            )
    }
}
