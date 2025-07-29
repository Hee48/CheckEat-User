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
                                    .foregroundStyle(.buttonEnable)
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
                                    //FIXME: 해당 부분 삭제 + sto_name은 가게명 필드로 수정
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

extension Int: Identifiable {
    public var id: Int { self }
}
