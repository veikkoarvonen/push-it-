//
//  DeviceActivity.swift
//  Push It!
//
//  Created by Veikko Arvonen on 16.2.2026.
//

import Foundation
import DeviceActivity


final class DeviceActivityManager {
    
    static let shared = DeviceActivityManager()
    private let center = DeviceActivityCenter()
    private let activityName = DeviceActivityName("blockAfterEndDate")
    
    init() {}
    
    func stopMonitoring() {
        center.stopMonitoring([activityName])
    }
    
    func scheduleTestingInterval() {
        
        stopMonitoring()
        
        let now = Date()
        let components: Set<Calendar.Component> = [.hour, .minute, .second]
        let calendar = Calendar.current
        let startDate = calendar.date(bySettingHour: 14, minute: 10, second: 0, of: now)!
        let endDate = calendar.date(bySettingHour: 14, minute: 30, second: 0, of: now)!
        let intervalStart = calendar.dateComponents(components, from: startDate)
        let intervalEnd = calendar.dateComponents(components, from: endDate)
        
        let schedule = DeviceActivitySchedule(
            intervalStart: intervalStart,
            intervalEnd: intervalEnd,
            repeats: false
        )
        
        do {
            try center.startMonitoring(activityName, during: schedule)
            print("✅ Scheduled test blocking successfully")
            print("✅ Start time is \(startDate), end time is \(endDate)")
            print("✅ Now is \(now)")
        } catch {
            print("❌ Failed to start monitoring:", error)
        }
        
    }
    
    func scheduleEndOfScreentime(until end: Date) {
        
        stopMonitoring()
        
        let intervalStart = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: end)
        
        let distantFuture = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        let intervalEnd = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: distantFuture)
        
        let schedule = DeviceActivitySchedule(
            intervalStart: intervalStart,
            intervalEnd: intervalEnd,
            repeats: false
        )
        
        do {
            try center.startMonitoring(activityName, during: schedule)
        } catch {
            print("Failed to start monitoring")
        }
        
    }
    
}
