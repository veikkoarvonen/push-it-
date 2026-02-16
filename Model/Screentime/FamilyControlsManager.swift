//
//  FamilyControlsManager.swift
//  Push It!
//
//  Created by Veikko Arvonen on 9.2.2026.
//

import Foundation
import FamilyControls
import ManagedSettings
import DeviceActivity

final class FamilyControlsAuthorization {
    static let shared = FamilyControlsAuthorization()
    private init() {}

    func requestIfNeeded() async -> AuthorizationStatus {
        let center = AuthorizationCenter.shared

        if center.authorizationStatus == .notDetermined {
            do {
                try await center.requestAuthorization(for: .individual)
            } catch {
                // If user cancels or system fails, status may remain notDetermined/denied
                print("Authorization request error:", error)
            }
        }

        return center.authorizationStatus
    }

    func status() -> AuthorizationStatus {
        AuthorizationCenter.shared.authorizationStatus
    }
}

final class BlockedAppsSelectionStore {
    static public let shared = BlockedAppsSelectionStore()

    // ✅ Replace with your real App Group identifier
    // Example: "group.com.yourcompany.yourapp"
    private let appGroupID: String? = "group.veikkoarvonen.pushuppal"

    private let key = "blockedAppsSelection"

    private var defaults: UserDefaults {
        guard let d = UserDefaults(suiteName: appGroupID) else {
            // Fallback for early dev if app group isn't configured yet
            return .standard
        }
        return d
    }

    init() {}

    func save(_ selection: FamilyActivitySelection) {
        do {
            let data = try JSONEncoder().encode(selection)
            defaults.set(data, forKey: key)
            defaults.synchronize()
            print("✅ Saved blocked apps selection. Apps:", selection.applicationTokens.count)
        } catch {
            print("❌ Failed to save selection:", error)
        }
    }

    func load() -> FamilyActivitySelection {
        guard let data = defaults.data(forKey: key) else {
            return FamilyActivitySelection()
        }

        do {
            return try JSONDecoder().decode(FamilyActivitySelection.self, from: data)
        } catch {
            print("❌ Failed to load selection:", error)
            return FamilyActivitySelection()
        }
    }

    func clear() {
        defaults.removeObject(forKey: key)
        print("✅ Cleared saved blocked apps selection.")
    }
    
    func checkAppGroupConfiguration() {
        if let d = UserDefaults(suiteName: appGroupID) {
            print("User defaults for app group found: \(d)")
        } else {
            print("App group not configured")
        }
    }
    
    // MARK: - Enabled flag
    
    private let enabledKey = "blockingEnabled"
    
    func setBlockingEnabled(_ enabled: Bool) {
        defaults.set(enabled, forKey: enabledKey)
    }
    
    func isBlockingEnabled() -> Bool {
        let enabled = defaults.bool(forKey: enabledKey)
        return enabled
    }
    
    
}

final class ShieldManager {
    
    static let shared = ShieldManager()
    
    init() {}
    
    private let store = ManagedSettingsStore()
    
    func applyShieldsFromStoredSelection() {
           let selection = BlockedAppsSelectionStore.shared.load()
           let tokens = selection.applicationTokens

           guard !tokens.isEmpty else {
               print("⚠️ No stored apps to shield.")
               return
           }

           store.shield.applications = tokens
           store.shield.applicationCategories = nil

           print("✅ Shields applied. Apps shielded:", tokens.count)
    }
    
    func clearShields() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.clearAllSettings()
        
        print("✅ Shields cleared.")
        
    }
    
    
    
}


final class BlockingScheduler {
    static let shared = BlockingScheduler()
    init() {}

    private let center = DeviceActivityCenter()
    private let activityName = DeviceActivityName("blockAfterEndDate")

    func rescheduleBlockingStart(at endDate: Date) {
        // Stop any previous schedule
        center.stopMonitoring([activityName])

        // If endDate already passed, we want blocking immediately.
        if endDate <= Date() {
            // Extension can also enforce, but do immediate shielding from app if you want.
            // (Or just start monitoring "now".)
        }

        // Create a long interval starting exactly at endDate
        let start = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: endDate)

        // End far in the future so "blocked mode" stays active until you clear it
        let farFuture = endDate.addingTimeInterval(60 * 60 * 24 * 365 * 5) // 5 years
        let end = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: farFuture)

        let schedule = DeviceActivitySchedule(
            intervalStart: start,
            intervalEnd: end,
            repeats: false
        )

        do {
            try center.startMonitoring(activityName, during: schedule)
            print("✅ Scheduled blocking to start at:", endDate)
        } catch {
            print("❌ Failed to start monitoring:", error)
        }
    }
}



