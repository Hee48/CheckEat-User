//
//  ManagerFavoriteStoreListView.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/12/25.
//

import SwiftUI

// MARK: - ManagerFavoriteStoreListView
struct ManagerFavoriteStoreListView: View {
    
    @Binding var selectedStoreId: Int?
    let items: [FavoriteStoreItem]

    var body: some View {
        List(items, id: \.sto_id) { item in
            Button {
                selectedStoreId = item.sto_id
            } label: {
                favoriteCell(for: item)
            }
            .buttonStyle(PlainButtonStyle())
            .listRowSeparator(.hidden)
        }
        .padding(.top, 20)
        .listStyle(.plain)
        .navigationTitle("즐겨찾기 가게")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension ManagerFavoriteStoreListView {
    @ViewBuilder
    func favoriteCell(for item: FavoriteStoreItem) -> some View {
        HStack(spacing: 8) {
            AsyncImage(url: URL(string: item.sto_img ?? "")) { image in
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
                Text(item.sto_name)
                    .bold20()
                Group {
                    HStack {
                        Image("Location")
                        Text(item.sto_address)
                            .lineLimit(2)
                    }
                    HStack {
                        Image("Time")
                        if let runtime = item.today_runtime {
                            Text("영업시간 \(runtime)")
                        } else {
                            Text("영업시간 정보 없음")
                        }
                    }
                }
                .regular14()
                .foregroundColor(.secondary)
            }
        }
    }
}
