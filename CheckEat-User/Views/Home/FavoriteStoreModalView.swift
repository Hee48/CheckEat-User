//
//  FavoriteStoreModalView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/25/25.
//

import SwiftUI

struct FavoriteStoreModalView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var viewModel: StoreMapViewModel
    @State private var selectedStore: Store? = nil

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("⭐ 즐겨찾기한 가게 (\(viewModel.favoriteStores.count)곳)")
                    .regular16()
                Spacer()
                Button(viewModel.markerMode == .all ? "🔁 즐겨찾기 모드로 전환" : "🔁 전체 보기로 전환") {
                    viewModel.markerMode = (viewModel.markerMode == .all) ? .favorite : .all
                    isPresented = false
                }
                .regular14()
            }
            .padding()

            List(viewModel.favoriteStores, id: \.storeId) { store in
                Button {
                    selectedStore = store
                } label: {
                    HStack(spacing: 8) {
                        AsyncImage(url: URL(string: store.sto_img ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipped()
                                .cornerRadius(8)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 60, height: 60)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(store.sto_name)
                                .bold20()
                            Text("주소 | \(store.sto_address)")
                                .regular14()
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        .fullScreenCover(item: $selectedStore) { store in
            StoreDetailView(store: store)
                .environmentObject(viewModel)
                .onDisappear {
                    viewModel.updateFavoriteStores()
                }
        }
    }
}
