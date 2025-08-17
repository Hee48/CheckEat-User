//
//  StoreMenuSection.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/17/25.
//

import SwiftUI

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
