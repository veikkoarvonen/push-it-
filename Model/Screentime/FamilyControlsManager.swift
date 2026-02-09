//
//  FamilyControlsManager.swift
//  Push It!
//
//  Created by Veikko Arvonen on 9.2.2026.
//

import Foundation
import FamilyControls

final class FamilyControlsManager {
    static let shared = FamilyControlsManager()
    init() {}
    
    func request() async throws {
        try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }
    
    func status() -> AuthorizationStatus {
        AuthorizationCenter.shared.authorizationStatus
    }
    
    
    
}
    
   
