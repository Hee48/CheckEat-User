//
//  MainHomeView.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/9/25.
//

import SwiftUI
import CoreLocation

struct MainHomeView: View {
    @StateObject private var locationService = LocationService()
    @StateObject private var storeViewModel = NearByStoreViewModel()
    
    @State private var searchText: String = ""
    @State private var selectedFilter: String = ""
    @State private var selectedStoreType: String = "전체"
    @State private var showingNearbyModal = false
    @State private var mapCenter: CLLocationCoordinate2D? = nil
    @State private var mapZoomLevel: Float = 15.0
    @State private var hasShownInitialModal = false
    
    var body: some View {
        ZStack {
            // 1. 맵 (맨 뒤)
            GoogleMapsView(
                center: $mapCenter,
                zoomLevel: $mapZoomLevel,
                onCenterChanged: { newCenter in
                    mapCenter = newCenter
                    locationService.updateMapCenter(newCenter)
                    locationService.updateNearbyIfNeeded(newCenter, viewModel: storeViewModel)
                },
                stores: storeViewModel.nearbyStores,
                shouldShowSearchButton: locationService.shouldShowSearchButton,
                onSearchButtonTapped: {
                    locationService.fetchStoresAtCurrentCenter(viewModel: storeViewModel)
                },
                currentFilter: selectedFilter,
                isFavoriteMode: false
            )
            .ignoresSafeArea(.all)
            
            // 2. 헤더 (맵 위)
            VStack {
                MainHeaderView(
                    searchText: $searchText,
                    selectedFilter: $selectedFilter,
                    selectedStoreType: $selectedStoreType,
                    onSearch: {
                        print("🔍 검색 실행: \(searchText)")
                    },
                    hasToken: hasValidToken
                )
                Spacer()
            }
            
            // 3. 플로팅 버튼들 (맨 위)
            HomeMapFloatingButtons(
                onNearbyTapped: {
                    showingNearbyModal = true
                },
                onFavoriteTapped: {
                    // TODO: 즐겨찾기 기능 구현
                    print("즐겨찾기 버튼 탭")
                }
            )
            
            // 4. 로딩 상태 표시 (맨 위)
            if storeViewModel.isLoading {
                VStack {
                    ProgressView("가게 목록을 불러오는 중...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                }
            }
            
            // 5. 에러 상태 표시 (맨 위)
            if let errorMessage = storeViewModel.errorMessage {
                VStack {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                        Button("다시 시도") {
                            if let center = locationService.currentMapCenter {
                                locationService.fetchStoresAtCurrentCenter(viewModel: storeViewModel)
                            }
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                }
            }
        }
        .onAppear {
            // 앱 시작시 초기화
            locationService.performInitialSearch(viewModel: storeViewModel)
        }
        .onChange(of: locationService.userLocation) { newUserLocation in
            // 사용자 GPS 위치가 처음 업데이트될 때
            if let userLocation = newUserLocation {
                mapCenter = userLocation  // 지도 중심을 사용자 위치로 설정
                locationService.currentMapCenter = userLocation
                
                // 자동으로 가게 검색 실행 (viewModel 전달)
                locationService.performInitialSearch(viewModel: storeViewModel)
            }
        }
        .onChange(of: storeViewModel.nearbyStores) { stores in
            // 가게 목록이 로드되면 초기 모달 자동 표시 (최초 1회만)
            if !hasShownInitialModal && !stores.isEmpty {
                hasShownInitialModal = true
                showingNearbyModal = true
            }
        }
        .onChange(of: selectedFilter) { newFilter in
            // 필터 변경시 맵 마커 업데이트
            print(" 필터 변경: \(newFilter)")
        }
        .onChange(of: selectedStoreType) { newType in
            // 가게 타입 변경시 맵 마커 업데이트
            print("🏪 가게 타입 변경: \(newType)")
        }
        .sheet(isPresented: $showingNearbyModal) {
            // 근처 가게 모달 표시
            NearByStoresModalView(
                isPresented: $showingNearbyModal,
                currentLocation: locationService.currentMapCenter ?? CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
            )
            .presentationDetents([.medium, .large])
        }
    }
    
    // 토큰 상태 확인 함수 (임시로 false 반환, 나중에 실제 토큰 체크 로직으로 교체)
    private var hasValidToken: Bool {
        // TODO: 실제 토큰 체크 로직 구현
        return false
    }
}

#Preview {
    MainHomeView()
}
