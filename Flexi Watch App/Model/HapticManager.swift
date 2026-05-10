//
//  HapticManager.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//
import WatchKit

class HapticManager {
    static let shared = HapticManager()
    
    private init() {}
    
    /// Trigger a standard selection click (perfect for crown rotation)
    func playSelection() {
        WKInterfaceDevice.current().play(WKHapticType.click)
    }
    
    /// Trigger a successful action (e.g. routine completed)
    func playSuccess() {
        WKInterfaceDevice.current().play(WKHapticType.success)
    }
    
    /// Trigger a light impact (e.g. button press)
    func playImpact() {
        WKInterfaceDevice.current().play(WKHapticType.directionUp)
    }
    
    /// Trigger a warning/error (e.g. bad posture detected)
    func playWarning() {
        WKInterfaceDevice.current().play(WKHapticType.retry)
    }
    
    /// Trigger a start action
    func playStart() {
        WKInterfaceDevice.current().play(WKHapticType.start)
    }
    
    /// Trigger a stop/pause action
    func playStop() {
        WKInterfaceDevice.current().play(WKHapticType.stop)
    }
}
