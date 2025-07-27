//
//  StoreDetailView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/24/25.
//

import SwiftUI

struct StoreDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let store: Store
    @EnvironmentObject var viewModel: StoreMapViewModel
    @EnvironmentObject var foodReviewViewModel: FoodReviewViewModel
    
    // store
    @State var stoDesc: String = "9호선 개포역 5번 출구 100m 직진 후 좌측 코너에 위치하고 있습니다.(해당 자리는 상호명으로 대체됩니다)"
    
    // holiday
    @State var runTime: String = "09:00 ~ 18:00"
    @State var breakTime: String = "13:00 ~ 14:00"
    @State var regularHolidayType: String = "매주"
    @State var regularHoilday: String = "월요일"
    @State var publicHoilday: String = "설날, 추석"
    
    // show field
    @State var isFieldVisible: Bool = false
    @State var isFavorite: Bool = false // 즐겨찾기 버튼
    
    @State var selectedTab: String = "전체메뉴"
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    VStack {
                        ZStack {
                            Rectangle()
                                .fill(.buttonSoft)
                                .frame(maxWidth: .infinity, minHeight: geo.size.height * 0.3)
                            AsyncImage(url: URL(string: store.sto_img ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geo.size.width, height: geo.size.height * 0.3)
                                    .clipped()
                            } placeholder: {
                                Image(systemName: "storefront.fill")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .foregroundStyle(.buttonDisable)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            StoreHeaderView(store: store)
                                .environmentObject(viewModel)
                            
                            StoreLocationView(store: store, isFieldVisible: $isFieldVisible)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Image("Time")
                                    Text("영업시간 \(runTime)")
                                }
                                HStack {
                                    Image("Time")
                                    Text("브레이크타임 \(breakTime)")
                                }
                                HStack {
                                    Image("Calendar")
                                    Text("\(regularHolidayType) \(regularHoilday) 정기 휴무 | \(publicHoilday) 휴무")
                                        .foregroundStyle(.red)
                                }
                                HStack {
                                    Image("Phone")
                                    Text(store.sto_phone)
                                }
                                HStack {
                                    Text(stoDesc)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 24)
                        
                        Rectangle()
                            .fill(Color("Button_OP20"))
                            .frame(height: 1)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                        
                        StoreMenuSectionView(
                            storeId: store.storeId,
                            selectedTab: $selectedTab,
                            viewModel: viewModel,
                            foodReviewViewModel: foodReviewViewModel
                        )
                    }
                    .regular16()
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundStyle(.black)
                    }
                }
            }
        }
    }
}

// MARK: - StoreHeaderView
struct StoreHeaderView: View {
    let store: Store
    @EnvironmentObject var viewModel: StoreMapViewModel

    var body: some View {
        HStack {
            Text(store.sto_name)
                .bold20()
            Spacer()
            Button {
                viewModel.toggleFavorite(for: store)
            } label: {
                Image(systemName: viewModel.isFavorite(store: store) ? "star.fill" : "star")
                    .foregroundStyle(viewModel.isFavorite(store: store) ? .buttonEnable : .buttonOP50 )
            }
        }
    }
}

// MARK: - StoreLocationView
struct StoreLocationView: View {
    let store: Store
    @Binding var isFieldVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image("Location")
                Text(store.sto_address)
                Spacer()
                Button {
                    isFieldVisible.toggle()
                } label: {
                    Image(systemName: isFieldVisible ? "chevron.up" : "chevron.down")
                        .resizable()
                        .frame(width: 12, height: 8)
                        .foregroundStyle(.buttonOP50)
                }
            }
            .padding(.trailing, 4)
            
            if isFieldVisible {
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.buttonEnable)
                    Text("\(store.sto_latitude)(latitude), \(store.sto_longitude)(longtitude)")
                }
                .medium16()
                .foregroundStyle(.buttonEnable)
                .padding(.vertical, 2)
            }
        }
    }
}

// MARK: - StoreMenuSectionView
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

private struct StoreMenuCellView: View {
    let menu: Food
    let onReviewTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: menu.foo_img ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxWidth: 70)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                        .frame(width: 70, height: 70)
                }
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(menu.foo_name)
                            .semibold18()
                        Spacer()
                        Text("비건 단계 표시")
                    }
                    HStack {
                        Text("\(menu.foo_price)원")
                            .semibold16()
                            .padding(.bottom, 4)
                        Spacer()
                        Button(action: onReviewTap) {
                            HStack {
                                Text("리뷰")
                                    .foregroundStyle(.black)
                                Image(systemName: "chevron.forward")
                                    .resizable()
                                    .frame(width: 6, height: 9)
                                    .foregroundStyle(.buttonOP50)
                            }
                            .regular12()
                        }
                    }
                    HStack(spacing: 2) {
                        Image(systemName: "info.circle")
                            .frame(width: 16, height: 16)
                            .foregroundStyle(.buttonOP50)
                        Text("알레르기")
                            .foregroundStyle(.buttonOP50)
                            .padding(.trailing, 6)
                        Text(menu.foo_material ?? "위험한 유발 요인 없읍")
                            .foregroundStyle(.red)
                    }
                }
                .regular14()
            }
            .padding(.vertical, 2)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            Divider()
        }
    }
}

extension Int: Identifiable {
    public var id: Int { self }
}
