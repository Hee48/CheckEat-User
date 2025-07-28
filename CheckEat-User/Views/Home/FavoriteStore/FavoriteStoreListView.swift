//
//  FavoriteStoreListView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/28/25.
//

import SwiftUI

struct FavoriteStoreListView: View {
    @EnvironmentObject var viewModel: StoreMapViewModel
    @Binding var selectedStore: Store?
    @Binding var runTime: String

    var body: some View {
        List(viewModel.favoriteStores, id: \.storeId) { store in
            Button {
                selectedStore = store
            } label: {
                HStack(spacing: 8) {
                    AsyncImage(url: URL(string: store.sto_img ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(maxWidth: 70)
                            .cornerRadius(8)
                    } placeholder: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 70, height: 70)
                                .foregroundStyle(.buttonSoft)
                            Image(systemName: "heart.fill")
                                .foregroundStyle(.buttonEnable)
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
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
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}
