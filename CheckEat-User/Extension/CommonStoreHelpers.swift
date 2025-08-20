//
//  CommonStoreHelpers.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/19/25.
//

import Foundation

struct CommonStoreHelpers {
    
    static func businessHours(_ runtime: String?) -> String {
        if let runtime = runtime {
            return "\("business_hours".localized) \(runtime)"
        } else {
            return "\("business_hours".localized) \("today_hours_not_available".localized)"
        }
    }
    
    static func breakTime(breakTime: String?, weekday: Int) -> String {
        let breakTimeText = BreakTimeUtils.getBreakTimeText(for: breakTime, weekday: weekday)
        return "\("break_time".localized) \(breakTimeText)"
    }
}
