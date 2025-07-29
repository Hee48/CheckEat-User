//
//  NearbyStoreModalView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/22/25.
//

import SwiftUI
import CoreLocation

struct NearbyStoreModalView: View {
    
    @Binding var isPresented: Bool
    var currentLocation: CLLocationCoordinate2D
    var viewModel: StoreMapViewModel
    var foodReviewViewModel: FoodReviewViewModel

    @State private var selectedStore: Store? = nil
    
    @State var runTime: String = "09:00 ~ 18:00"

    private var modalStores: [Store] {
        viewModel.storesForModalList(center: currentLocation, radius: 2000)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("🔍 2Km 반경 가게 (\(modalStores.count)곳 조회)")
                    .regular16()
                Spacer()
                Button("닫기") {
                    isPresented = false
                }
                .regular14()
            }
            .padding()

            List(modalStores, id: \.storeId) { store in
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
            .fullScreenCover(item: $selectedStore) { store in
                StoreDetailView(store: store)
                    .environmentObject(viewModel)
                    .environmentObject(foodReviewViewModel)
            }
        }
        .frame(maxHeight: .infinity)
    }
}

extension NearbyStoreModalView {
    @ViewBuilder
    private func storeCell(for store: Store) -> some View {
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
                    Text("영업시간 \(runTime)")
                }
            }
            .regular14()
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.white))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
