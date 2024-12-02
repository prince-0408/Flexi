//
//  HapticType.swift
//  Flexi
//
//  Created by Prince Yadav on 12/12/24.
//

import WatchKit

extension WKInterfaceDevice {
    enum HapticType {
        case start
        case stop
        case success
        case failure
        case notification
        case directionUp
        case directionDown
    }
    
    func play(_ type: HapticType) {
        switch type {
        case .start:
            play(WKHapticType.start)
        case .stop:
            play(WKHapticType.stop)
        case .success:
            play(WKHapticType.success)
        case .failure:
            play(WKHapticType.failure)
        case .notification:
            play(WKHapticType.notification)
        case .directionUp:
            play(WKHapticType.directionUp)
        case .directionDown:
            play(WKHapticType.directionDown)
        }
    }
}
