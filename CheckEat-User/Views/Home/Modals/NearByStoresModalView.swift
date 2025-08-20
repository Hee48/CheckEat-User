//
//  NearByStoresModalView.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/9/25.
//

import SwiftUI
import CoreLocation

struct NearByStoresModalView: View {
    
    @Binding var isPresented: Bool
    var currentLocation: CLLocationCoordinate2D
    var stores: [Stores] // 외부에서 전달받은 가게 목록
    var isSearchMode: Bool // 검색 모드인지 여부
    var isFilterMode: Bool // 필터 모드인지 여부
    
    @StateObject private var viewModel = NearByStoreViewModel()
    @State private var selectedStore: Stores? = nil
    
    // 가게 상세정보 조회
    @State private var selectedStoreId: Int? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if isFilterMode {
                    Text("filter_results_title".localized + " (\(stores.count)" + "stores_count".localized + ")")
                } else if isSearchMode {
                    Text("search_results_title".localized + " (\(stores.count)" + "stores_count".localized + ")")
                } else {
                    Text("nearby_stores_title".localized + " (\(stores.count)" + "stores_count".localized + ")")
                }
                Spacer()
                Button("close".localized) {
                    isPresented = false
                }
                .regular14()
                .foregroundStyle(.secondary)
            }
            .semibold18()
            .padding(.horizontal)
            .padding(.top, 24)
            .padding(.bottom, 4)
            
            if viewModel.isLoading {
                ProgressView{
                    Text("loading_stores".localized)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text(errorMessage)
                        .regular16()
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(stores, id: \.storeId) { store in
                    Button {
                        // 선택한 가게 아이디 저장
                        selectedStoreId = store.storeId
                    } label: {
                        storeCell(for: store)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .background(Color.clear)
            }
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            // 검색 모드나 필터 모드가 아닐 때만 API 호출
            if !isSearchMode && !isFilterMode {
                loadNearbyStores()
            }
        }
        .sheet(item: $selectedStoreId) { id in
            StoreDetailInfoView(storeId: id, language: LanguageSettingsViewModel.getCurrentLanguage())
                .presentationDetents([.large])
        }
    }
    
    private func loadNearbyStores() {
        viewModel.fetchNearByStores(
            latitude: String(currentLocation.latitude),
            longitude: String(currentLocation.longitude),
            radius: "2000"
        )
    }
}

extension NearByStoresModalView {
    @ViewBuilder
    private func storeCell(for store: Stores) -> some View {
        
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: store.sto_img ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .cornerRadius(8)
            } placeholder: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(height: 100)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.buttonSoft)
                    Image(systemName: "storefront.fill")
                        .foregroundStyle(.buttonEnable)
                }
            }
            
            HStack {
                if LanguageSettingsViewModel.getCurrentLanguage() == "ko" {
                    Text(store.sto_name)
                        .bold20()
                } else {
                    Text(store.sto_name_en)
                        .bold20()
                }
                
                if store.sto_halal == 1 {
                    Text("halal_certified")
                        .foregroundColor(.white)
                        .medium12()
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(.correct)
                        .cornerRadius(15)
                }
            }
            .padding(.vertical, 8)
            
            Group {
                HStack {
                    Image("Location")
                    Text(store.sto_address)
                }
                HStack {
                    Image("Time")
                    Text(CommonStoreHelpers.businessHours(store.today_runtime))
                }
                HStack {
                    Image("Time")
                    Text(CommonStoreHelpers.breakTime(breakTime: store.holi_break, weekday: store.holi_weekday))
                }
            }
            .foregroundColor(.secondary)
            
            HStack {
                Image("Desc")
                Text(getDistanceText(Int(store.distance)))
                    .foregroundColor(.buttonEnable)
            }
            .padding(.bottom, 4)
        }
        .regular14()
        .padding()
        .background(Color(.white))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private func getDistanceText(_ distance: Int) -> String {
        return "\("distance_from_current_location".localized) \(distance)\("meters".localized)"
    }
}
