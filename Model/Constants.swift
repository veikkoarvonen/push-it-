//
//  Constants.swift
//  Push It!
//
//  Created by Veikko Arvonen on 19.1.2026.
//

import Foundation

struct C {
    
    struct fonts {
        static let bold = "SFProDisplay-Bold"
        static let medium = "SFProDisplay-Medium"
        static let regular = "SFProDisplay-Regular"
    }
    
    struct colors {
        static let orange1 = "orange1"
        static let gray1 = "gray1"
        static let gray2 = "gray2"
        static let gray3 = "gray3"
        static let gray4 = "gray4"
    }
    
    struct userDefaultValues {
        static let pushUps: String = "pushUps"
        static let minutes: String = "minutes"
        static let shouldUpdateSheet: String = "shouldUpdateSheet"
        static let shouldUpdateTokens: String = "shouldUpdateTokens"
        static let screentimeEnd: String = "screentimeEnd"
    }
    
    static let testUIwithBackgroundColor: Bool = false
    static let testDataForThisWeek: [Int] = [14, 56, 35, 46, 31, 45, 23]
    static let testDataForPreviousWeek: [Int] = [12, 23, 66, 21, 34, 56, 12]
    static let testPushUpCreationWithoutCamera: Bool = false
    
    static let tokenLimits: [Int] = [50, 100, 200, 500, 1000, 2000, 3000, 5000, 10000, 20000, 50000, 100000]
    
    static let bgView = "pushUpbackGround"

    
}
