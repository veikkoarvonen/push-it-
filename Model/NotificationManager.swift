//
//  NotificationManager.swift
//  Push It!
//
//  Created by Veikko Arvonen on 3.2.2026.
//

import Foundation
import UserNotifications

final class NotificationManager {
    
    static let shared = NotificationManager()
    
    enum AppLaunchTracker {
        private static let hasLaunchedKey = "hasLaunchedBefore"

        static var isFirstLaunch: Bool {
            let launched = UserDefaults.standard.bool(forKey: hasLaunchedKey)
            if !launched {
                UserDefaults.standard.set(true, forKey: hasLaunchedKey)
            }
            return !launched
        }
    }
    
    func requestNotificationsIfNeeded() {
        guard AppLaunchTracker.isFirstLaunch else { return }

        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]
        ) { granted, _ in
            DispatchQueue.main.async {
                if granted {
                    print("✅ Notification permission granted")
                } else {
                    print("❌ Notification permission denied")
                }
            }
        }
    }
    
    func notificationsAllowed() async -> Bool {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        
        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        default:
            return false
        }
    }
    
    func scheduleTestNotification(after seconds: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Push It"
        content.body = "Time’s up! Do your push-ups 💪"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: seconds,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "test_notification",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleScreentimeEndNotification() {
        
        let endTime = UserDefaults.standard.value(forKey: C.userDefaultValues.screentimeEnd) as? Date ?? Date()
        
        guard endTime > Date() else { return }
        
        let identifier: String = "screen_time_ended"
        
        let content = UNMutableNotificationContent()
            content.title = "Screen Time Ended"
            content.body = "Do push ups to earn more screentime! 💪"
            content.sound = .default
        
        let components = Calendar.current.dateComponents(
                [.year, .month, .day, .hour, .minute, .second],
                from: endTime
            )
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier,
                                                content: content,
                                                trigger: trigger)

            UNUserNotificationCenter.current().add(request)
        
    }
        
    
}
