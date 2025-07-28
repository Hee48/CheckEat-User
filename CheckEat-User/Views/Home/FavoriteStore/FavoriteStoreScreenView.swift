//
//  FavoriteStoreScreenView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/29/25.
//

import SwiftUI

struct FavoriteStoreScreenView: View {
    @Binding var isPresented: Bool
    @Binding var selectedStore: Store?
    @EnvironmentObject var viewModel: StoreMapViewModel
    @EnvironmentObject var foodReviewViewModel: FoodReviewViewModel
    @Environment(\.dismiss) private var dismiss
    @State var runTime: String = "09:00 ~ 18:00"

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                FavoriteStoreListView(selectedStore: $selectedStore, runTime: $runTime)
            }
            .padding(.horizontal)
            .navigationTitle("즐겨찾기 가게")
            .navigationBarTitleDisplayMode(.inline)
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
