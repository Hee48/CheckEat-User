//
//  CoreDataSection.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/17/25.
//

import SwiftUI

struct CoreDataSection: View {
    
    let storeInfo: StoreDetailInfo
    @Binding var showRunningTimeField: Bool
    
    private func normalized(_ s: String?) -> String? {
        guard let t = s?.trimmingCharacters(in: .whitespacesAndNewlines), !t.isEmpty else { return nil }
        return t
    }
    
    var body: some View {
        // holiday가 nil이거나 값이 비어 있어도 UI는 항상 표시
        let holiday = storeInfo.holiday
        
        VStack(alignment: .leading) {
            // 영업시간(오늘)
            HStack(spacing: 4) {
                Image("Time")
                Text("business_hours".localized).medium16()
                Text(holiday?.today ?? "today_hours_not_available".localized)
                    .padding(.trailing, 12)
                Button {
                    showRunningTimeField.toggle()
                } label: {
                    Image(systemName: showRunningTimeField ? "chevron.up" : "chevron.down")
                        .resizable()
                        .frame(width: 12, height: 8)
                        .foregroundStyle(.buttonOP50)
                }
            }
            
            // 요일별 영업시간 목록
            let weekData: [(String, String?)] = [
                ("monday".localized, holiday?.holi_runtime_mon),
                ("tuesday".localized, holiday?.holi_runtime_tue),
                ("wednesday".localized, holiday?.holi_runtime_wed),
                ("thursday".localized, holiday?.holi_runtime_thu),
                ("friday".localized, holiday?.holi_runtime_fri),
                ("saturday".localized, holiday?.holi_runtime_sat),
                ("sunday".localized, holiday?.holi_runtime_sun)
            ]
            
            if showRunningTimeField {
                ForEach(weekData, id: \.0) { day, time in
                    HStack(spacing: 4) {
                        Text(day).medium16()
                        Text(normalized(time) ?? "hours_not_available".localized)
                    }
                    .regular14()
                    .padding(.bottom, 2)
                    .padding(.leading, 24)
                }
            }
            
            // 휴게시간
            HStack(spacing: 4) {
                Image("Time")
                Text(CommonStoreHelpers.breakTime(breakTime: holiday?.holi_break, weekday: holiday?.holi_weekday ?? 0))
//                Text("break_time".localized).medium16()
//                let breakTime = holiday?.holi_break
//                let currentWeekday = holiday?.holi_weekday ?? 0
//                Text(BreakTimeUtils.getBreakTimeText(for: breakTime, weekday: currentWeekday))
            }
            
            // 정기 휴무
            HStack(spacing: 4) {
                Image("Calendar")
                //                Text("정기휴무").medium16()
                
                if let regularHolidays = holiday?.holi_regular, !regularHolidays.isEmpty {
//                    Text("\(regularHolidays.joined(separator: ", ")) regular_holiday")
                    Text("\(regularHolidays.joined(separator: ", ")) \("regular_holiday".localized)")
                        .medium16()
                } else {
                    Text("no_regular_holiday".localized)
                }
            }
            
            HStack(spacing: 4) {
                Image("Calendar")
                //                Text("공휴일 휴무").medium16()
                if let publicHolidays = holiday?.holi_public, !publicHolidays.isEmpty {
//                    Text("\(publicHolidays.joined(separator: ", ")) closed_on")
                    Text("\(publicHolidays.joined(separator: ", ")) \("closed_on".localized)")
                        .medium16()
                } else {
                    Text("no_public_holiday".localized)
                }
            }
            
            HStack(spacing: 4) {
                Image("Phone")
                Text(storeInfo.sto_phone ?? "no_phone_registered".localized)
            }
        }
        .regular16()
    }
}
