//
//  MainHeaderView.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/10/25.
//

import SwiftUI

struct MainHeaderView: View {
    @Binding var searchText: String
    @Binding var selectedFilter: String
    @Binding var selectedStoreType: String
    let onSearch: () -> Void
    let hasToken: Bool // 토큰 존재 여부
    
    var body: some View {
        VStack(spacing: 16) {
            SearchBar(
                searchText: $searchText,
                placeholder: "가게명으로 검색해보세요",
                onSearch: onSearch
            )
            FilterButtonSection(
                selectedFilter: $selectedFilter,
                selectedStoreType: $selectedStoreType,
                searchText: $searchText,
                hasToken: hasToken
            )
        }
        .padding(.horizontal)
        .padding(.top, 35)
    }
}
