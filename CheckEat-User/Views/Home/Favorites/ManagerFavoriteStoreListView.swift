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
        .navigationTitle("favorite_store_title")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension ManagerFavoriteStoreListView {
    @ViewBuilder
    func favoriteCell(for item: FavoriteStoreItem) -> some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: item.sto_img ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: 90)
                    .cornerRadius(8)
            } placeholder: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 90, height: 90)
                        .foregroundStyle(.buttonSoft)
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.buttonEnable)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if LanguageSettingsViewModel.getCurrentLanguage() == "ko" {
                    Text(item.sto_name)
                        .bold20()
                } else {
                    Text(item.sto_name_en)
                        .bold20()
                }
                Group {
                    HStack {
                        Image("Location")
                        Text(item.sto_address)
                            .lineLimit(2)
                    }
                    HStack {
                        Image("Time")
                        Text(CommonStoreHelpers.businessHours(item.today_runtime))
                    }
                    HStack {
                        Image("Time")
                        Text(CommonStoreHelpers.breakTime(breakTime: item.holi_break, weekday: item.holi_weekday))
                    }
                }
                .regular14()
                .foregroundColor(.secondary)
            }
        }
    }
}
