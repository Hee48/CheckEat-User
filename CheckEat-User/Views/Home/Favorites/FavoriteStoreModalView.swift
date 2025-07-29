//
//  FavoriteStoreModalView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/28/25.
//

import SwiftUI

struct FavoriteStoreModalView: View {
    @Binding var isPresented: Bool
    @Binding var selectedStore: Store?
    @EnvironmentObject var viewModel: StoreMapViewModel
    @EnvironmentObject var foodReviewViewModel: FoodReviewViewModel
    @State var runTime: String = "09:00 ~ 18:00"

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

            FavoriteStoreListView(selectedStore: $selectedStore, runTime: $runTime)
        }
        .fullScreenCover(item: $selectedStore) { store in
            StoreDetailView(store: store)
                .environmentObject(viewModel)
                .environmentObject(foodReviewViewModel)
                .onDisappear {
                    viewModel.updateFavoriteStores()
                }
        }
    }
}
