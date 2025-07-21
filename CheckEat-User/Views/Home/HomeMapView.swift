//
//  HomeMapView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/21/25.
//

import SwiftUI

struct HomeMapView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = StoreMapViewModel()

    var body: some View {
        ZStack {
            GoogleMapView(
                coordinate: $locationManager.userLocation,
                centerCoordinate: $locationManager.centerMapOnLocation,
                markers: viewModel.filteredStores,
                currentFilter: viewModel.selectedFilter,
                viewModel: viewModel
            )

            VStack {
                Spacer()
                if locationManager.userLocation == nil {
                    HStack(spacing: 8) {
                        ProgressView()
                        Text("위치 가져오는 중...")
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .overlay(
            VStack(spacing: 16) {
                SearchBar(
                    text: $viewModel.searchText,
                    placeholder: "찾으시려는 장소를 검색해보세요",
                    onSearch: {
                        //TODO: 서치바 동작 구현
                    }
                )
                FilterButton(selectedFilter: $viewModel.selectedFilter)
            }
            .padding(.horizontal)
            .padding(.top, 35),
            alignment: .top
        )
    }
}

#Preview {
    HomeMapView()
}
