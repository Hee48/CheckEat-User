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
                // 제목을 모드에 따라 다르게 표시
                if isFilterMode {
                    Text("🔍 비건 필터 결과 (\(stores.count)곳 조회)")
                        .regular16()
                } else if isSearchMode {
                    Text("🔍 검색 결과 (\(stores.count)곳 조회)")
                        .regular16()
                } else {
                    Text("🔍 2Km 반경 가게 (\(stores.count)곳 조회)")
                        .regular16()
                }
                Spacer()
                Button("닫기") {
                    isPresented = false
                }
                .regular14()
            }
            .padding()
            
            if viewModel.isLoading {
                ProgressView("가게 목록을 불러오는 중...")
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
            StoreDetailInfoView(storeId: id, language: "ko")
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
            
            Text(store.sto_name)
                .bold20()
            
            Group {
                HStack {
                    Image("Location")
                    Text(store.sto_address)
                }
                HStack {
                    Image("Time")
                    if let runtime = store.today_runtime {
                        Text("영업시간 \(runtime)")
                    } else {
                        Text("영업시간 정보 없음")
                    }
                }
            }
            .regular14()
            .foregroundColor(.secondary)
            
            HStack {
                Text("거리: \(Int(store.distance))m")
                    .regular14()
                    .foregroundColor(.blue)
                Spacer()
                if store.sto_halal == 1 {
                    Text("할랄 인증")
                        .regular12()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                }
            }
        }
        .padding()
        .background(Color(.white))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
