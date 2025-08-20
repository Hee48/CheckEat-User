//
//  StoreMenuSection.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/17/25.
//

import SwiftUI
import Kingfisher

struct StoreMenuSection: View {
    
    let storeInfo: StoreDetailInfo
    @Binding var selectedTab: String
    
    // 공통 알레르기 매핑
    private let allergyMapping: [Int: String] = [
        1: "난류", 2: "우유", 3: "메밀", 4: "땅콩", 5: "대두",
        6: "밀", 7: "고등어", 8: "게", 9: "새우", 10: "돼지고기",
        11: "복숭아", 12: "토마토", 13: "아황산류", 14: "호두", 15: "닭고기",
        16: "쇠고기", 17: "오징어", 18: "조개류", 19: "잣"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 탭 선택 버튼
            HStack(spacing: 24) {
                Spacer()
                Button {
                    selectedTab = "menu_tab_all".localized
                } label: {
                    VStack(spacing: 10) {
                        Text("menu_tab_all".localized)
                            .semibold16()
                            .foregroundColor(selectedTab == "menu_tab_all".localized ? .buttonAuth : .buttonOP20)
                        
                        Rectangle()
                            .fill(selectedTab == "menu_tab_all".localized ? Color.buttonAuth : Color.gray.opacity(0.3))
                            .frame(width: 100, height: 2)
                            .animation(.easeInOut(duration: 0.3), value: selectedTab)
                    }
                }
                Spacer()
                Button {
                    selectedTab = "menu_tab_vegan".localized
                } label: {
                    VStack(spacing: 10) {
                        Text("menu_tab_vegan".localized)
                            .semibold16()
                            .foregroundColor(selectedTab == "menu_tab_vegan".localized ? .buttonAuth : .buttonOP20)
                        
                        Rectangle()
                            .fill(selectedTab == "menu_tab_vegan".localized ? Color.buttonAuth : Color.gray.opacity(0.3))
                            .frame(width: 120, height: 2)
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
                        HStack(alignment: .top,spacing: 20) {
                            KFImage(URL(string: food.foo_img ?? ""))
                                .placeholder {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .frame(width: 70, height: 70)
                                            .foregroundStyle(.buttonOP)
                                        Image(systemName: "fork.knife")
                                            .foregroundStyle(.buttonEnable)
                                    }
                                }
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(maxWidth: 70)
                                .cornerRadius(8)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(food.foo_name)
                                        .semibold16()
                                    Spacer()
                                    // 비건 레벨 표시
                                    if food.foo_vegan != 7 {
                                        if let veganType = VeganType(rawValue: food.foo_vegan),
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
                                            Text("review_button".localized)
                                            Image(systemName: "chevron.forward")
                                                .resizable()
                                                .frame(width: 6, height: 9)
                                            
                                        }
                                        .foregroundStyle(.buttonOP50)
                                        .regular12()
                                    }
                                    
                                }
                                
                                // 알레르기 정보 섹션
                                VStack(alignment: .leading, spacing: 6) {
                                    
                                    // 전체 재료 (직접입력 + 19종 알레르기)
                                    HStack(alignment: .top, spacing: 4) {
                                        Image("Warn")
                                            .foregroundStyle(.buttonOP50)
                                        Text("ingredients_label".localized)
                                            .foregroundStyle(.buttonOP50)
                                    }
                                    Text(getCombinedIngredients(food: food))
                                        .foregroundStyle(.black)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    // 개인 알레르기 주의 성분 (직접입력 + 19종 중 해당되는 것)
                                    if hasAllergyWarnings(food: food) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "exclamationmark.triangle.fill")
                                                .font(.system(size: 12))
                                            Text("allergy_caution_label".localized)
                                        }
                                        Text(getCombinedAllergyWarnings(food: food))
                                            .foregroundStyle(.red)
                                            .fontWeight(.semibold)
                                    }
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
    
    // MARK: - Helper Functions
    private func getCombinedIngredients(food: MenuInfo) -> String {
        var allIngredients: [String] = []
        
        // 직접 입력된 재료들
        allIngredients.append(contentsOf: food.foo_material)
        
        // 19종 공통 알레르기 재료들
        //        if let commonAl = food.CommonAl, !commonAl.isEmpty {
        //            let allergyIngredients = commonAl.compactMap { allergyMapping[$0.coal_id] }
        //            allIngredients.append(contentsOf: allergyIngredients)
        //        }
        if !food.CommonAl.isEmpty {
            let allergyIngredients = food.CommonAl.compactMap { allergyMapping[$0.coal_id] }
            allIngredients.append(contentsOf: allergyIngredients)
        }
        
        // 중복 제거 및 정렬
        let uniqueIngredients = Array(Set(allIngredients)).sorted()
        //        print("foo_m: \(food.foo_material), foo_c: \(food.CommonAl)")
        //        print("uniqueIngredients: \(uniqueIngredients.joined(separator: "/"))")
        return uniqueIngredients.isEmpty ? "no_ingredient_info".localized : uniqueIngredients.joined(separator: ", ")
    }
    
    private func getCombinedAllergyWarnings(food: MenuInfo) -> String {
        var allWarnings: [String] = []
        
        // 개인 알레르기 (직접 입력)
        if let personalAllergy = food.foo_warning {
            allWarnings.append(personalAllergy)
        }
        
        // 19종 중 해당되는 알레르기
        if let coalWarnings = food.foo_warning_coal, !coalWarnings.isEmpty {
            let allergyNames = coalWarnings.compactMap { allergyMapping[$0] }
            allWarnings.append(contentsOf: allergyNames)
        }
        
        // 중복 제거 및 정렬
        let uniqueWarnings = Array(Set(allWarnings)).sorted()
        //        print("foo_m: \(food.foo_warning ?? "none"), foo_c: \(food.foo_warning_coal ?? [-1])")
        //        print("uniqueWarnings: \(uniqueWarnings.joined(separator: "/"))")
        return uniqueWarnings.joined(separator: ", ")
    }
    
    private func hasAllergyWarnings(food: MenuInfo) -> Bool {
        return food.foo_warning != nil ||
        (food.foo_warning_coal != nil && !food.foo_warning_coal!.isEmpty)
    }
    
    // 탭에 따라 메뉴 필터링
    private func getFilteredFoodList() -> [MenuInfo] {
        switch selectedTab {
        case "menu_tab_all".localized:
            return storeInfo.food_list
        case "menu_tab_vegan".localized:
            return storeInfo.food_list.filter { food in
                // foo_vegan이 7이 아닌 메뉴만 필터링
                return food.foo_vegan != 7
            }
        default:
            return storeInfo.food_list
        }
    }
    
    private func formatPrice(_ s: String) -> String {
        if let n = Int(s) {
            let f = NumberFormatter(); f.numberStyle = .decimal
            return (f.string(from: n as NSNumber) ?? s) + "price_suffix_won".localized
        }
        return s
    }
}
