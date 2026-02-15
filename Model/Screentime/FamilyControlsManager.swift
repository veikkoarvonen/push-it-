//
//  FamilyControlsManager.swift
//  Push It!
//
//  Created by Veikko Arvonen on 9.2.2026.
//

import Foundation
import FamilyControls
import ManagedSettings

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
    static let shared = BlockedAppsSelectionStore()

    // ✅ Replace with your real App Group identifier
    // Example: "group.com.yourcompany.yourapp"
    private let appGroupID: String? = nil //"group.YOUR_APP_GROUP_ID"

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
}

