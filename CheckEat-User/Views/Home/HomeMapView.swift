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
    
    var body: some View {
        ZStack {
            GoogleMapView(
                coordinate: $locationManager.userLocation,
                centerCoordinate: $locationManager.centerMapOnLocation,
                markers: viewModel.filteredStores,
                currentFilter: viewModel.activeCategoryFromSearch(),
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
        .sheet(isPresented: $isNearbyPresented) {
            NearbyStoreModalView(
                isPresented: $isNearbyPresented,
                currentLocation: locationManager.centerMapOnLocation ?? locationManager.userLocation ?? CLLocationCoordinate2D(),
                stores: viewModel.nearbyStores
            )
            .presentationDetents([.height(400)])
        }
        .onChange(of: locationManager.centerMapOnLocation) { newCenter in
            guard let center = newCenter else { return }

            if !didInitialLocationUpdate {
                viewModel.updateNearbyStores(center: center)
                locationManager.centerMapOnLocation = center
                lastPresentedCenter = center
                isNearbyPresented = true
                didInitialLocationUpdate = true
                return
            }

            if let last = lastPresentedCenter {
                let distance = CLLocation(latitude: center.latitude, longitude: center.longitude)
                    .distance(from: CLLocation(latitude: last.latitude, longitude: last.longitude))
                if distance > 20 {
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
        
        .overlay(
            VStack(spacing: 16) {
                SearchBar(
                    searchText: $viewModel.searchText,
                    placeholder: "찾으시려는 장소를 검색해보세요",
                    onSearch: {
                        viewModel.applyFilters()
                    }
                )
                FilterButton(selectedFilter: $viewModel.selectedFilter)
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
}

#Preview {
    HomeMapView()
}
