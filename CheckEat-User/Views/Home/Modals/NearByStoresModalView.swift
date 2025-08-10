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
    
    @StateObject private var viewModel = NearByStoreViewModel()
    @State private var selectedStore: Stores? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("🔍 2km 반경에 \(viewModel.nearbyStores.count)곳의 가게가 있어요")
                    .bold18()
                Spacer()
                Button("닫기") {
                    isPresented = false
                }
                .regular14()
                .foregroundStyle(.black)
            }
            .padding(.top, 24)
            .padding(.bottom, 4)
            .padding(.horizontal)
            
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
                    Button("다시 시도") {
                        loadNearbyStores()
                    }
                    .regular14()
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(viewModel.nearbyStores, id: \.storeId) { store in
                    Button {
                        selectedStore = store
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
            loadNearbyStores()
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
            
            HStack(spacing: 8) {
                Text(store.sto_name)
                    .bold20()
                
                if store.sto_halal == 1 {
                    Text("할랄 인증")
                        .regular12()
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.correct)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            
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
                Image("Desc")
                Text("현재 위치에서 \(Int(store.distance))m 거리에 있어요")
                    .regular14()
                    .foregroundColor(.buttonEnable)
                Spacer()
                
            }
        }
        .padding()
        .background(Color(.white))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
