//
//  StoreMenuSectionView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/29/25.
//

import SwiftUI

struct StoreMenuSectionView: View {
    let storeId: Int
    @Binding var selectedTab: String
    @ObservedObject var viewModel: StoreMapViewModel
    @ObservedObject var foodReviewViewModel: FoodReviewViewModel
    
    @State private var selectedFoodId: Int? = nil
    @State private var isReviewSheetPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            HStack(spacing: 24) {
                Spacer()
                Button {
                    selectedTab = "전체메뉴"
                } label: {
                    VStack {
                        Text("전체메뉴")
                            .semibold16()
                            .foregroundColor(selectedTab == "전체메뉴" ? .buttonAuth : .buttonOP20)
                    }
                }
                Spacer()
                Button {
                    selectedTab = "채식메뉴"
                } label: {
                    Text("채식메뉴")
                        .semibold16()
                        .foregroundColor(selectedTab == "채식메뉴" ? .buttonAuth : .buttonOP20)
                }
                Spacer()
            }
            .semibold16()
            .padding(.bottom)
            
            let filteredMenus = viewModel.filteredMenus(for: selectedTab, storeId: storeId)
            
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(filteredMenus, id: \.foo_id) { menu in
                        StoreMenuCellView(
                            menu: menu,
                            onReviewTap: {
                                selectedFoodId = menu.foo_id
                                print("🍱 선택된 foodId (즉시): \(menu.foo_id)")
                                DispatchQueue.main.async {
                                    print("📤 시트 오픈됨 with foodId: \(selectedFoodId ?? -1)")
                                    isReviewSheetPresented = true
                                }
                            }
                        )
                    }
                }
                .sheet(item: $selectedFoodId) { foodId in
                    FoodReviewView(
                        viewModel: FoodReviewViewModel(foodList: viewModel.allFoods),
                        foodId: foodId,
                        stores: viewModel.allStores
                    )
                }
            }
            
        }
    }
}
