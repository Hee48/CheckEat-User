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
    
    @State private var isNearbyPresented = false
    @State private var lastPresentedCenter: CLLocationCoordinate2D?
    @State private var didInitialLocationUpdate = false
    @State private var mapZoomLevel: Float = 15.0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                GoogleMapView(
                    coordinate: $locationManager.userLocation,
                    centerCoordinate: $locationManager.centerMapOnLocation,
                    isNearbyPresented: $isNearbyPresented,
                    mapZoomLevel: $mapZoomLevel,
                    selectedStore: $selectedStore,
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
            .sheet(isPresented: $isNearbyPresented) {
                NearbyStoreModalView(
                    isPresented: $isNearbyPresented,
                    currentLocation: locationManager.centerMapOnLocation ?? locationManager.userLocation ?? CLLocationCoordinate2D(),
                    viewModel: viewModel
                )
                .presentationDetents([.height(geo.size.height*0.5), .large])
            }
        }
        .onChange(of: locationManager.centerMapOnLocation) { newCenter in
            guard let center = newCenter else { return }

            let defaultLat = 37.5665
            let defaultLng = 126.9780

            if !didInitialLocationUpdate {
                // 서울시청 초기값이 아닌 경우에만 모달 띄우기
                if abs(center.latitude - defaultLat) > 0.0005 || abs(center.longitude - defaultLng) > 0.0005 {
                    viewModel.updateNearbyStores(center: center)
                    locationManager.centerMapOnLocation = center
                    lastPresentedCenter = center
                    isNearbyPresented = true
                    didInitialLocationUpdate = true
                }
                return
            }

            if let last = lastPresentedCenter {
                let distance = CLLocation(latitude: center.latitude, longitude: center.longitude)
                    .distance(from: CLLocation(latitude: last.latitude, longitude: last.longitude))
                if distance > 100 {
                    viewModel.updateNearbyStores(center: center)
                    lastPresentedCenter = center
                    isNearbyPresented = false
                }
            } else {
                viewModel.updateNearbyStores(center: center)
                lastPresentedCenter = center
                isNearbyPresented = false
            }
        }
        .onChange(of: mapZoomLevel) { _ in
            if let center = locationManager.centerMapOnLocation {
                updateNearbyIfNeeded(center)
            }
        }
        
        .overlay(
            VStack(spacing: 16) {
                SearchBar(
                    searchText: $viewModel.searchText,
                    placeholder: "찾으시려는 장소를 검색해보세요",
                    onSearch: {
                        viewModel.applyFilters()
                    }
                )
                FilterButton(selectedFilter: $viewModel.selectedFilter, selectedStoreType: $viewModel.selectedStoreType, searchText: $viewModel.searchText)
            }
                .padding(.horizontal)
                .padding(.top, 35),
            alignment: .top
        )
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isNearbyPresented = true
                    }) {
                        Image(systemName: "list.bullet")
                            .font(.system(size: 18))
                            .foregroundStyle(.buttonOP70)
                            .padding(20)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    .padding(.trailing, 8)
                    .padding(.bottom, 80)
                }
            }
        )
    }
    
    private func updateNearbyIfNeeded(_ center: CLLocationCoordinate2D) {
        let defaultLat = 37.5665
        let defaultLng = 126.9780

        if !didInitialLocationUpdate {
            if abs(center.latitude - defaultLat) > 0.0005 || abs(center.longitude - defaultLng) > 0.0005 {
                viewModel.updateNearbyStores(center: center)
                locationManager.centerMapOnLocation = center
                lastPresentedCenter = center
                isNearbyPresented = true
                didInitialLocationUpdate = true
            }
            return
        }

        if let last = lastPresentedCenter {
            let distance = CLLocation(latitude: center.latitude, longitude: center.longitude)
                .distance(from: CLLocation(latitude: last.latitude, longitude: last.longitude))
            if distance > 100 {
                viewModel.updateNearbyStores(center: center)
                lastPresentedCenter = center
            }
        } else {
            viewModel.updateNearbyStores(center: center)
            lastPresentedCenter = center
        }
    }
}

#Preview {
    HomeMapView()
}
