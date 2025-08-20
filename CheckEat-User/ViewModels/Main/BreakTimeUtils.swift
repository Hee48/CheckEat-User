//
//  BreakTimeUtils.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/17/25.
//

import Foundation

struct BreakTimeUtils {
    
    static func parseBreakTime(_ breakTime: String) -> (weekday: [String], weekend: [String]) {
        var weekdayBreaks: [String] = []
        var weekendBreaks: [String] = []
        
        // "W:10:00~10:30;E:13:00~15:00" 형태를 ";"로 분리
        let segments = breakTime.split(separator: ";")
        
        for segment in segments {
            let trimmed = segment.trimmingCharacters(in: .whitespaces)
            
            if trimmed.hasPrefix("W:") {
                // 평일 브레이크 "W:10:00~10:30" → "10:00~10:30"
                let time = String(trimmed.dropFirst(2))
                weekdayBreaks.append(time)
            } else if trimmed.hasPrefix("E:") {
                // 주말 브레이크 "E:13:00~15:00" → "13:00~15:00"
                let time = String(trimmed.dropFirst(2))
                weekendBreaks.append(time)
            }
        }
        
        return (weekday: weekdayBreaks, weekend: weekendBreaks)
    }
    
    // 현재 요일에 맞는 브레이크 타임 텍스트 반환
    // - Parameters:
    // - breakTime: 브레이크 타임 문자열
    // - weekday: 현재 요일 (0: 일요일, 1-5: 평일, 6: 토요일)
    // - Returns: 표시할 브레이크 타임 텍스트
    static func getBreakTimeText(for breakTime: String?, weekday: Int) -> String {
        guard let breakTime = breakTime else {
            return "break_time_not_available".localized
        }
        
        if breakTime == "" {
            return "no_break_time".localized
        }
//        if breakTime == "NONE" {
//            return "휴게시간 없음"
//        }
        
        if breakTime.contains("W:") || breakTime.contains("E:") {
            let parsed = parseBreakTime(breakTime)
            
            if weekday == 0 || weekday == 6 {
                // 주말
                if !parsed.weekend.isEmpty {
                    return "\(parsed.weekend.joined(separator: ", "))"
                } else {
                    return "info_not_available".localized
                }
            } else {
                // 평일
                if !parsed.weekday.isEmpty {
                    return "\(parsed.weekday.joined(separator: ", "))"
                } else {
                    return "info_not_available".localized
                }
            }
        } else {
            return "\(breakTime)"
        }
    }
}
