//
//  CalendarManager.swift
//  Push It!
//
//  Created by Veikko Arvonen on 26.1.2026.
//

import Foundation

final class CalendarManager {
            
    static let shared = CalendarManager()
    
    func pushUpsForSingleDate(for date: Date) -> Int {
        let coreData = CoreDataManager()
        let workouts = coreData.fetchSingleDayWorkouts(for: date)
        let totalReps = workouts.reduce(0) { $0 + $1.reps }
        return Int(totalReps)
    }
    
    func datesForWeek(weekOffset: Int) -> [Date] {
        let cal = Calendar.current
        let now = cal.date(byAdding: .weekOfYear, value: weekOffset, to: Date())!
        
        let comps = cal.dateComponents([.yearForWeekOfYear, .weekOfYear, .weekday], from: now)
        
        let year = comps.yearForWeekOfYear!
        let week = comps.weekOfYear!
        var weekday: Int = 2
        
        var datesToReturn: [Date] = []
        
        for _ in 0..<7 {
            let dateToLog = cal.date(from: DateComponents(year: year, weekday: weekday, weekOfYear: week))!
            datesToReturn.append(dateToLog)
            
            if weekday == 7 {
                weekday = 1
                //week += 1
            } else {
                weekday += 1
            }
        }
        
        return datesToReturn
        
    }
    
    func pushUpsForWeek(weekOffset: Int) -> (singleDates: [Int], total: Int) {
        
        let dates = datesForWeek(weekOffset: weekOffset)
        var pushUps: [Int] = []
        
        for date in dates {
            pushUps.append(pushUpsForSingleDate(for: date))
        }
        
        let totalPushUps = pushUps.reduce(0, +)
        
        return (singleDates: pushUps, total: totalPushUps)
        
    }
    
    func totalPushUps() -> Int {
        let allWorkouts = CoreDataManager().fetchAllWorkouts()
        let totalPushups = allWorkouts.reduce(0) { $0 + $1.reps }
        return Int(totalPushups)
    }
    
    func resetScreentime() {
        UserDefaults.standard.set(Date(), forKey: C.userDefaultValues.screentimeEnd)
    }
    
}
