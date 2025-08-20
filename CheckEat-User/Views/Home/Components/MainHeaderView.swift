//
//  MainHeaderView.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/10/25.
//

import SwiftUI
import CoreLocation

struct MainHeaderView: View {
    
    @Binding var searchText: String
    @Binding var selectedFilter: String
    
    let hasToken: Bool
    let currentLocation: CLLocationCoordinate2D?
    
    // 콜백들
    let onSearchResult: ([Stores]) -> Void
    let onSearchError: (String?) -> Void
    let onFilterResult: ([Stores]) -> Void
    let onFilterError: (String?) -> Void
    let onFilterClear: () -> Void
    
    @StateObject private var viewModel = MainHeaderViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            SearchBar(
                searchText: $searchText,
                placeholder: "search_by_store_name".localized,
                onSearch: {
                    viewModel.performSearchByName(
                        searchText: searchText,
                        location: currentLocation
                    )
                }
            )
            FilterButtonSection(
                selectedFilter: $selectedFilter,
                searchText: $searchText,
                hasToken: hasToken,
                onFilterSelected: { filter in
                    viewModel.performFilterSearch(
                        filter: filter,
                        location: currentLocation
                    )
                },
                onFilterClear: {
                    viewModel.clearFilter()
                }
            )
        }
        .padding(.horizontal)
        .padding(.top, 35)
        .onAppear {
            setupCallbacks()
        }
        .onChange(of: searchText) { newText in
            if newText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                onSearchResult([])
                onSearchError(nil)
            }
        }
    }
    
    private func setupCallbacks() {
        viewModel.onSearchResult = onSearchResult
        viewModel.onSearchError = onSearchError
        viewModel.onFilterResult = onFilterResult
        viewModel.onFilterError = onFilterError
        viewModel.onFilterClear = onFilterClear
    }
}
