//
//  StoreHeaderSection.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/12/25.
//

import SwiftUI

enum VeganType: Int, CaseIterable {
    case none = 0
    case vegan = 1
    case lacto = 2
    case ovo = 3
    case lactoovo = 4
    case pesco = 5
    case pollo = 6
    
    var displayName: String? {
        switch self {
        case .vegan:    return "비건"
        case .lacto:    return "락토 베지테리언"
        case .ovo:      return "오보 베지테리언"
        case .lactoovo: return "락토 오보 베지테리언"
        case .pesco:    return "페스코 베지테리언"
        case .pollo:    return "폴로 베지테리언"
        case .none:     return nil
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .vegan:    return Color("Vegan")
        case .lacto:    return Color("Lacto")
        case .ovo:      return Color("Ovo")
        case .lactoovo: return Color("Lacto-ovo")
        case .pesco:    return Color("Pesco")
        case .pollo:    return Color("Pollo")
        case .none:     return Color.clear
        }
    }
    
    var textColor: Color {
        switch self {
        case .vegan:
            return Color(red: 0.1686, green: 0.4784, blue: 0.4196)
        case .lacto:
            return Color(red: 0.4784, green: 0.451, blue: 0.1725)
        case .ovo:
            return Color(red: 0.3725, green: 0.2941, blue: 0.5451)
        case .lactoovo:
            return Color(red: 0.2039, green: 0.4941, blue: 0.5804)
        case .pesco:
            return Color(red: 0.2902, green: 0.4353, blue: 0.3529)
        case .pollo:
            return Color(red: 0.7216, green: 0.3569, blue: 0.2941)
        case .none:
            return Color.clear
        }
    }
}

struct StoreHeaderSection: View {
    
    let storeId: Int
    
    let storeInfo: StoreDetailInfo
    @EnvironmentObject var viewModel: StoreDetailInfoViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            Text(storeInfo.sto_name)
                .bold20()
            Text(storeInfo.sto_name_en)
                .regular14()
            Spacer()
            Button {
                viewModel.toggleFavorite(storeId: storeId)
            } label: {
                if viewModel.isFavoriteLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(width: 20, height: 20)
                } else {
                    Image(systemName: viewModel.isFavorite(storeId: storeId) ? "star.fill" : "star")
                        .foregroundStyle(viewModel.isFavorite(storeId: storeId) ? .buttonEnable : .buttonOP50 )
                }
            }
        }
        .regular16()
        .padding(.top, 24)
    }
}

struct StoreLocationSection: View {
    
    let storeInfo: StoreDetailInfo
    @Binding var showLocationField: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Image("Location")
            Text(storeInfo.sto_address)
            Spacer()
            Button {
                showLocationField.toggle()
            } label: {
                Image(systemName: showLocationField ? "chevron.up" : "chevron.down")
                    .resizable()
                    .frame(width: 12, height: 8)
                    .foregroundStyle(.buttonOP50)
            }
        }
        .regular16()
        .padding(.trailing, 4)
        
        if showLocationField {
            HStack(spacing: 4) {
                Image("Desc")
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.buttonEnable)
                Text("\(storeInfo.sto_latitude)(latitude), \(storeInfo.sto_longitude)(longtitude)")
            }
            .medium14()
            .foregroundStyle(.buttonEnable)
            .padding(.vertical, 2)
        }
    }
}

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
                Text(normalized(holiday?.holi_weekday) ?? "금일 영업시간 정보 없음")
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
            
            // 정기 휴무
            HStack(spacing: 4) {
                Image("Calendar")
                Text("정기휴무").medium16()
                Text(normalized(holiday?.holi_regular) ?? "정기휴무 정보 없음")
            }
            .padding(.top, 4)
            
            // 공휴일
            HStack(spacing: 4) {
                Image("Calendar")
                Text("공휴일").medium16()
                Text(normalized(holiday?.holi_public) ?? "공휴일 정보 없음")
            }
            
            // 가게 전화번호 (holiday와 무관)
            HStack(spacing: 4) {
                Image("Phone")
                Text(storeInfo.sto_phone ?? "등록된 연락처 없음")
            }
        }
        .regular16()
    }
}

struct StoreMenuSection: View {
    
    let storeInfo: StoreDetailInfo
    @Binding var selectedTab: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 탭 선택 버튼
            HStack(spacing: 24) {
                Spacer()
                Button {
                    selectedTab = "전체메뉴"
                } label: {
                    VStack(spacing: 10) {
                        Text("전체메뉴")
                            .semibold16()
                            .foregroundColor(selectedTab == "전체메뉴" ? .buttonAuth : .buttonOP20)
                        
                        Rectangle()
                            .fill(selectedTab == "전체메뉴" ? Color.buttonAuth : Color.gray.opacity(0.3))
                            .frame(width: 100, height: 2)
                            .animation(.easeInOut(duration: 0.3), value: selectedTab)
                    }
                }
                Spacer()
                Button {
                    selectedTab = "채식메뉴"
                } label: {
                    VStack(spacing: 10) {
                        Text("채식메뉴")
                            .semibold16()
                            .foregroundColor(selectedTab == "채식메뉴" ? .buttonAuth : .buttonOP20)
                        
                        Rectangle()
                            .fill(selectedTab == "채식메뉴" ? Color.buttonAuth : Color.gray.opacity(0.3))
                            .frame(width: 100, height: 2)
                            .animation(.easeInOut(duration: 0.3), value: selectedTab)
                    }
                }
                Spacer()
            }
            .padding(.bottom, 10)
            
            // 필터링된 메뉴 목록
            let filteredFoodList = getFilteredFoodList()
            
            ForEach(Array(filteredFoodList.enumerated()), id: \.1.id) { idx, food in
                VStack {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 20) {
                            AsyncImage(url: URL(string: food.foo_img ?? "")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(maxWidth: 70)
                                    .cornerRadius(8)
                            } placeholder: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: 70, height: 70)
                                        .foregroundStyle(.buttonOP)
                                    Image(systemName: "fork.knife")
                                        .foregroundStyle(.buttonEnable)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(food.foo_name)
                                        .semibold16()
                                    Spacer()
                                    // 비건 레벨 표시
                                    if let veganLevel = food.foo_vegan, veganLevel != 0 {
                                        if let veganType = VeganType(rawValue: veganLevel),
                                           let displayName = veganType.displayName {
                                            Text(displayName)
                                                .regular12()
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(veganType.backgroundColor)
                                                .foregroundColor(veganType.textColor)
                                                .cornerRadius(12)
                                        }
                                    }
                                }
                                HStack {
                                    Text(formatPrice(food.foo_price))
                                        .padding(.bottom, 4)
                                    Spacer()
                                    Button {
                                        
                                    } label: {
                                        HStack {
                                            Text("리뷰")
                                                .foregroundStyle(.black)
                                            Image(systemName: "chevron.forward")
                                                .resizable()
                                                .frame(width: 6, height: 9)
                                                .foregroundStyle(.buttonOP50)
                                        }
                                        .regular14()
                                    }
                                    
                                }
                                HStack(spacing: 4) {
                                    Image("Warn")
                                        .foregroundStyle(.buttonOP50)
                                    Text("알레르기")
                                        .foregroundStyle(.buttonOP50)
                                    Text(food.foo_material.isEmpty ? "유발재료 없음"
                                         : food.foo_material.joined(separator: ", "))
                                    .foregroundStyle(.red)
                                }
                                .regular14()
                            }
                        }
                    }
                    .regular16()
                    .padding(.horizontal)
                }
                if idx < filteredFoodList.count - 1 {
                    Divider()
                        .padding(.vertical, 4)
                }
            }
        }
    }
    
    // 탭에 따라 메뉴 필터링
    private func getFilteredFoodList() -> [MenuInfo] {
        switch selectedTab {
        case "전체메뉴":
            return storeInfo.food_list
        case "채식메뉴":
            return storeInfo.food_list.filter { food in
                // foo_vegan이 0이 아닌 메뉴만 필터링
                if let veganLevel = food.foo_vegan {
                    return veganLevel != 0
                }
                return false
            }
        default:
            return storeInfo.food_list
        }
    }
    
    private func formatPrice(_ s: String) -> String {
        if let n = Int(s) {
            let f = NumberFormatter(); f.numberStyle = .decimal
            return (f.string(from: n as NSNumber) ?? s) + "원"
        }
        return s
    }
}
