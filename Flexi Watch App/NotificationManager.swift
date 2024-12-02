//
//  NotificationManager.swift
//  Flexi
//
//  Created by Prince Yadav on 02/12/24.
//


import UserNotifications
import CoreMotion

class NotificationManager {
    static let shared = NotificationManager()
    private let motionManager = CMMotionManager()
    
    private init() {
        requestNotificationPermission()
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
    }
    
    func schedulePostureReminders(interval: TimeInterval = 30 * 60) {
        // Remove existing notifications
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["posture-reminder"])
        
        // Create new periodic notification
        let content = UNMutableNotificationContent()
        content.title = "Posture Check"
        content.body = "Time to adjust your posture and stretch!"
        content.sound = .default
        
        // Repeating trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "posture-reminder",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleStretchReminders(times: [Date] = []) {
        // Remove existing stretch notifications
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["stretch-reminder"])
        
        // Default times if none provided
        let defaultTimes = [
            Calendar.current.date(bySettingHour: 10, minute: 0, second: 0, of: Date())!,
            Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())!,
            Calendar.current.date(bySettingHour: 16, minute: 0, second: 0, of: Date())!
        ]
        
        let timesToUse = times.isEmpty ? defaultTimes : times
        
        timesToUse.forEach { reminderTime in
            let content = UNMutableNotificationContent()
            content.title = "Stretch Break"
            content.body = "Take a quick stretch break to stay healthy!"
            content.sound = .default
            
            // Create trigger
            var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: reminderTime)
            dateComponents.timeZone = TimeZone.current
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(
                identifier: "stretch-reminder-\(reminderTime)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}