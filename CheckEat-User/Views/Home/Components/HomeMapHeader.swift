//
//  HomeMapHeader.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/29/25.
//

import SwiftUI

struct HomeMapHeader: View {
    @Binding var searchText: String
    @Binding var selectedFilter: String
    @Binding var selectedStoreType: String
    let onSearch: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            SearchBar(
                searchText: $searchText,
                placeholder: "찾으시려는 장소를 검색해보세요",
                onSearch: onSearch
            )
            FilterButton(
                selectedFilter: $selectedFilter,
                selectedStoreType: $selectedStoreType,
                searchText: $searchText
            )
        }
        .padding(.horizontal)
        .padding(.top, 35)
    }
}
