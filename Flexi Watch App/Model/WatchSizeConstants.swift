//
//  WatchSizeConstants.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//

import SwiftUI

#if os(watchOS)
import WatchKit
#else
import UIKit
#endif

struct WatchSizeConstants {
    // Screen size detection
    static var screenWidth: CGFloat {
        #if os(watchOS)
        return WKInterfaceDevice.current().screenBounds.width
        #else
        return UIScreen.main.bounds.width
        #endif
    }
    
    static var screenHeight: CGFloat {
        #if os(watchOS)
        return WKInterfaceDevice.current().screenBounds.height
        #else
        return UIScreen.main.bounds.height
        #endif
    }
    
    // Scaling factor for different watch sizes
    static var scaleFactor: CGFloat {
        #if os(watchOS)
        let baseWidth: CGFloat = 368 // Large watch width
        return screenWidth / baseWidth
        #else
        return 1.0
        #endif
    }
}

extension View {
    func adaptToWatchScreen() -> some View {
        #if os(watchOS)
        return self
            .frame(width: WatchSizeConstants.screenWidth,
                   height: WatchSizeConstants.screenHeight)
            .transformEffect(.identity.scaledBy(x: WatchSizeConstants.scaleFactor,
                                                y: WatchSizeConstants.scaleFactor))
        #else
        return self
        #endif
    }
    
    func watchOptimizedPadding() -> some View {
        #if os(watchOS)
        return self.padding(max(8 * WatchSizeConstants.scaleFactor, 4))
        #else
        return self.padding()
        #endif
    }
}
