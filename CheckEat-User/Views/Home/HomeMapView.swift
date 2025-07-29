//
//  HomeMapView.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/21/25.
//

import SwiftUI
import CoreLocation

struct HomeMapView: View {
    
    @StateObject private var locationManager = LocationManager()
    @StateObject private var viewModel = StoreMapViewModel()
    @StateObject private var foodReviewViewModel = FoodReviewViewModel(foodList: [])
    
    @State private var isNearbyPresented = false
    @State private var selectedNearbyStore: Store? = nil
    @State private var selectedFavoriteStore: Store? = nil
    @State private var selectedFavoriteSheetStore: Store? = nil
    @State private var isFavoritesPresented = false
    @State private var mapZoomLevel: Float = 15.0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                GoogleMapView(
                    coordinate: $locationManager.userLocation,
                    centerCoordinate: $locationManager.centerMapOnLocation,
                    isNearbyPresented: $isNearbyPresented,
                    mapZoomLevel: $mapZoomLevel,
                    selectedStore: $selectedNearbyStore,
                    markers: viewModel.filteredStores,
                    currentFilter: viewModel.activeCategoryFromSearch(),
                    viewModel: viewModel
                )
                .ignoresSafeArea(.all)
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
            .sheet(item: $selectedNearbyStore) { store in
                StoreDetailView(store: store)
                    .environmentObject(viewModel)
                    .environmentObject(foodReviewViewModel)
            }
            .sheet(isPresented: $isNearbyPresented) {
                NearbyStoreModalView(
                    isPresented: $isNearbyPresented,
                    currentLocation: locationManager.centerMapOnLocation ?? locationManager.userLocation ?? CLLocationCoordinate2D(),
                    viewModel: viewModel,
                    foodReviewViewModel: foodReviewViewModel
                )
                .presentationDetents([.height(geo.size.height*0.5), .large])
            }
            .sheet(isPresented: $isFavoritesPresented) {
                FavoriteStoreModalView(isPresented: $isFavoritesPresented, selectedStore: $selectedFavoriteSheetStore)
                    .environmentObject(viewModel)
                    .environmentObject(foodReviewViewModel)
                    .presentationDetents([.height(geo.size.height*0.5), .large])
            }
        }
        .onChange(of: locationManager.centerMapOnLocation) { newCenter in
            guard let center = newCenter else { return }

            if !locationManager.didInitialLocationUpdate {
                //MARK: 서울시청 초기값이 아닌 경우 모달 뷰 (권한 허용 이후 내 위치정보와 동시에 띄우기 위함)
                if abs(center.latitude - LocationManager.defaultLatitude) > 0.0005 || abs(center.longitude - LocationManager.defaultLongitude) > 0.0005 {
                    viewModel.updateNearbyStores(center: center)
                    locationManager.centerMapOnLocation = center
                    locationManager.lastPresentedCenter = center
                    isNearbyPresented = true
                    locationManager.didInitialLocationUpdate = true
                }
                return
            }

            if let last = locationManager.lastPresentedCenter {
                let distance = CLLocation(latitude: center.latitude, longitude: center.longitude)
                    .distance(from: CLLocation(latitude: last.latitude, longitude: last.longitude))
                if distance > 100 {
                    viewModel.updateNearbyStores(center: center)
                    locationManager.lastPresentedCenter = center
                    isNearbyPresented = false
                }
            } else {
                viewModel.updateNearbyStores(center: center)
                locationManager.lastPresentedCenter = center
                isNearbyPresented = false
            }
        }
        .onChange(of: mapZoomLevel) { _ in
            if let center = locationManager.centerMapOnLocation {
                locationManager.updateNearbyIfNeeded(center, viewModel: viewModel)
            }
        }
        .overlay(
            HomeMapHeader(
                searchText: $viewModel.searchText,
                selectedFilter: $viewModel.selectedFilter,
                selectedStoreType: $viewModel.selectedStoreType,
                onSearch: {
                    viewModel.applyFilters()
                }
            ),
            alignment: .top
        )
        .overlay(
            HomeMapFloatingButtons(
                onNearbyTapped: { isNearbyPresented = true },
                onFavoriteTapped: { isFavoritesPresented = true }
            )
        )
    }
}

#Preview {
    HomeMapView()
}
