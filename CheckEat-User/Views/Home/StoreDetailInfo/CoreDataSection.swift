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
                Text("영업시간").medium16()
                Text(holiday?.today ?? "금일 영업시간 정보 없음")
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
                ("월요일", holiday?.holi_runtime_mon),
                ("화요일", holiday?.holi_runtime_tue),
                ("수요일", holiday?.holi_runtime_wed),
                ("목요일", holiday?.holi_runtime_thu),
                ("금요일", holiday?.holi_runtime_fri),
                ("토요일", holiday?.holi_runtime_sat),
                ("일요일", holiday?.holi_runtime_sun)
            ]
            
            if showRunningTimeField {
                ForEach(weekData, id: \.0) { day, time in
                    HStack(spacing: 4) {
                        Text(day).medium16()
                        Text(normalized(time) ?? "영업시간 정보 없음")
                    }
                    .regular14()
                    .padding(.bottom, 2)
                    .padding(.leading, 24)
                }
            }
            
            // 휴게시간
            HStack(spacing: 4) {
                Image("Time")
                Text("휴게시간").medium16()
                let breakTime = holiday?.holi_break
                let currentWeekday = holiday?.holi_weekday ?? 0
                Text(BreakTimeUtils.getBreakTimeText(for: breakTime, weekday: currentWeekday))
            }
            
            // 정기 휴무
            HStack(spacing: 4) {
                Image("Calendar")
                //                Text("정기휴무").medium16()
                
                if let regularHolidays = holiday?.holi_regular, !regularHolidays.isEmpty {
                    Text("\(regularHolidays.joined(separator: ", ")) 정기휴무")
                        .medium16()
                } else {
                    Text("정기 휴무일 없음")
                }
            }
            
            HStack(spacing: 4) {
                Image("Calendar")
                //                Text("공휴일 휴무").medium16()
                if let publicHolidays = holiday?.holi_public, !publicHolidays.isEmpty {
                    Text("\(publicHolidays.joined(separator: ", ")) 휴무")
                        .medium16()
                } else {
                    Text("공휴일 휴무일 없음")
                }
            }
            
            HStack(spacing: 4) {
                Image("Phone")
                Text(storeInfo.sto_phone ?? "등록된 연락처 없음")
            }
        }
        .regular16()
    }
}
