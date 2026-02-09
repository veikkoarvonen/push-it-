//
//  FamilyControlsManager.swift
//  Push It!
//
//  Created by Veikko Arvonen on 9.2.2026.
//

import Foundation
import FamilyControls
import ManagedSettings

final class FamilyControlsManager {
    static let shared = FamilyControlsManager()
    init() {}
    
    func request() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }
    
    func status() -> AuthorizationStatus {
        AuthorizationCenter.shared.authorizationStatus
    }
    
    private let store = ManagedSettingsStore()

    /// Blocks exactly the apps the user selected in the FamilyActivityPicker.
    func enableBlocking(selection: FamilyActivitySelection) {
        // Selected apps
        store.shield.applications = selection.applicationTokens

        // (Not using categories in your MVP)
        store.shield.applicationCategories = nil

        print("✅ Blocking enabled. Apps selected:", selection.applicationTokens.count)
    }

    /// Clears all shields applied by this store.
    func disableBlocking() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.clearAllSettings()

        print("✅ Blocking disabled (shields cleared).")
    }
    
}

