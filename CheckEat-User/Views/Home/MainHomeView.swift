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
    @State private var showingNearbyModal = false
    @State private var showingFavoriteModal = false
    @State private var showingLoginView = false
    @State private var mapCenter: CLLocationCoordinate2D? = nil
    @State private var mapZoomLevel: Float = 15.0
    @State private var hasShownInitialModal = false
    
    // 검색 결과를 저장할 상태
    @State private var currentStores: [Stores] = []
    @State private var filterStores: [Stores] = [] // 필터 결과를 저장할 상태 추가
    
    @State private var isSearchMode: Bool = false // 검색 모드 여부
    @State private var searchErrorMessage: String? = nil // 검색 에러 메시지
    
    @State private var isFilterMode: Bool = false // 필터 모드 여부
    @State private var filterErrorMessage: String? = nil // 필터 에러 메시지
    
    @State private var selectedStoreId: Int? = nil
    
    var body: some View {
        ZStack {
            // 1. 맵 (맨 뒤)
            GoogleMapsView(
                center: $mapCenter,
                zoomLevel: $mapZoomLevel,
                onCenterChanged: { newCenter in
                    mapCenter = newCenter
                    locationService.updateMapCenter(newCenter)
                    // 검색 모드나 필터 모드가 아닐 때만 자동 갱신
                    if !isSearchMode && !isFilterMode {
                        locationService.updateNearbyIfNeeded(newCenter, viewModel: storeViewModel)
                    }
                },
                stores: getCurrentStores(), // 현재 모드에 따라 다른 데이터 표시
                shouldShowSearchButton: locationService.shouldShowSearchButton,
                onSearchButtonTapped: {
                    // 검색 모드와 필터 모드 해제하고 현재 위치 조회로 돌아가기
                    exitAllModes()
                    selectedFilter = ""
                    locationService.fetchStoresAtCurrentCenter(viewModel: storeViewModel)
                },
                onMarkerTapped: { store in
                    selectedStoreId = store.storeId
                },
                currentFilter: selectedFilter,
                isFavoriteMode: false,
                isSearchMode: isSearchMode,
                isFilterMode: isFilterMode
            )
            .ignoresSafeArea(.all)
            
            // 2. 헤더 (맵 위)
            VStack {
                MainHeaderView(
                    searchText: $searchText,
                    selectedFilter: $selectedFilter,
                    hasToken: hasValidToken,
                    currentLocation: locationService.currentMapCenter,
                    onSearchResult: { stores in
                        handleSearchResult(stores)
                    },
                    onSearchError: { errorMessage in
                        searchErrorMessage = errorMessage
                    },
                    onFilterResult: { stores in
                        handleFilterResult(stores)
                    },
                    onFilterError: { errorMessage in
                        filterErrorMessage = errorMessage
                    },
                    onFilterClear: {
                        handleFilterClear()
                    }
                )
                Spacer()
            }
            
            // 3. 플로팅 버튼들 (맨 위)
            HomeMapFloatingButtons(
                onNearbyTapped: {
                    showingNearbyModal = true
                },
                onFavoriteTapped: {
                    // 로그인 상태 확인
                    if AuthViewModel.shared.isLoggedIn {
                        showingFavoriteModal = true
                    } else {
                        print("🚫 로그인이 필요합니다. 로그인 화면을 띄웁니다.")
                        showingLoginView = true
                    }
                }
            )
            
            // 4. 로딩 상태 표시 (맨 위)
            if storeViewModel.isLoading {
                VStack {
                    ProgressView {
                        Text("loading_stores".localized)
                    }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                }
            }
            
            // 5. 에러 상태 표시 (맨 위)
            if let errorMessage = storeViewModel.errorMessage {
                VStack {
                    VStack(spacing: 20) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.largeTitle)
                            .foregroundStyle(.buttonDisable)
                        Text(errorMessage)
                            .regular14()
                            .multilineTextAlignment(.center)
                        Button {
                            storeViewModel.errorMessage = nil
                        } label: {
                            Text("confirm".localized)
                                .primaryButtonStyle()
                                .regular16()
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                }
                .padding(.horizontal)
            }
            
            // 6. 검색 에러 상태 표시 (맨 위)
            if let errorMessage = searchErrorMessage {
                VStack {
                    VStack(spacing: 20) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.largeTitle)
                            .foregroundStyle(.buttonDisable)
                        Text(errorMessage)
                            .regular14()
                            .multilineTextAlignment(.center)
                        Button {
                            searchErrorMessage = nil
                        } label: {
                            Text("confirm".localized)
                                .primaryButtonStyle()
                                .regular16()
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                }
                .padding(.horizontal)
            }
            
            // 7. 필터 에러 상태 표시 (맨 위)
            if let errorMessage = filterErrorMessage {
                VStack {
                    VStack(spacing: 20) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.largeTitle)
                            .foregroundStyle(.buttonDisable)
                        Text(errorMessage)
                            .regular14()
                            .multilineTextAlignment(.center)
                        Button {
                            filterErrorMessage = nil
                        } label: {
                            Text("confirm".localized)
                                .primaryButtonStyle()
                                .regular16()
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                }
                .padding(.horizontal)
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
        .sheet(isPresented: $showingNearbyModal) {
            // 근처 가게 모달 표시
            NearByStoresModalView(
                isPresented: $showingNearbyModal,
                currentLocation: locationService.currentMapCenter ?? CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
                stores: getCurrentStores(), // 현재 모드에 따라 다른 데이터 전달
                isSearchMode: isSearchMode,
                isFilterMode: isFilterMode
            )
            .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $showingFavoriteModal) {
            ManageFavoriteModalView(isPresented: $showingFavoriteModal)
                .presentationDetents([.medium, .large])
        }
        .sheet(item: $selectedStoreId) { id in
            StoreDetailInfoView(storeId: id, language: LanguageSettingsViewModel.getCurrentLanguage())
                .presentationDetents([.medium, .large])
        }
        .fullScreenCover(isPresented: $showingLoginView) {
            LoginView {
                showingLoginView = false
            }
        }
    }
    
    // 현재 모드에 따라 표시할 가게 목록 반환
    private func getCurrentStores() -> [Stores] {
        if isSearchMode {
            return currentStores
        } else if isFilterMode {
            return filterStores
        } else {
            return storeViewModel.nearbyStores
        }
    }
    
    // 검색 결과 처리 함수
    private func handleSearchResult(_ stores: [Stores]) {
        if stores.isEmpty {
            // 검색 결과가 없으면 검색 모드 해제
            exitSearchMode()
        } else {
            // 검색 결과가 있으면 검색 모드로 전환
            currentStores = stores
            isSearchMode = true
            isFilterMode = false // 필터 모드 해제
            print("🔍 검색 모드 활성화: \(stores.count)개 가게")
            
            // 검색 결과가 있으면 자동으로 모달 표시
            showingNearbyModal = true
        }
    }
    
    // 필터 결과 처리 함수 추가
    private func handleFilterResult(_ stores: [Stores]) {
        if stores.isEmpty {
            // 필터 결과가 없으면 필터 모드 해제
            exitFilterMode()
            // 필터 선택 상태도 초기화
            selectedFilter = ""
            print(" 필터 결과 없음 - 필터 선택 해제")
        } else {
            // 필터 결과가 있으면 필터 모드로 전환
            filterStores = stores
            isFilterMode = true
            isSearchMode = false // 검색 모드 해제
            print("🌱 필터 모드 활성화: \(stores.count)개 가게")
            
            // 필터 결과가 있으면 자동으로 모달 표시
            showingNearbyModal = true
        }
    }
    
    private func handleFilterClear() {
        print(" 필터 해제 - 현재 좌표 기준으로 재조회")
        
        // 필터 모드 해제
        exitFilterMode()
        
        // 선택된 필터 초기화
        selectedFilter = ""
        
        // 현재 좌표 기준으로 가게 재조회
        if let currentCenter = locationService.currentMapCenter {
            locationService.fetchStoresAtCurrentCenter(viewModel: storeViewModel)
        }
    }
    
    // 검색 모드 해제 함수
    private func exitSearchMode() {
        isSearchMode = false
        currentStores = []
        print(" 검색 모드 해제: 현재 위치 조회로 복귀")
    }
    
    // 필터 모드 해제 함수 추가
    private func exitFilterMode() {
        isFilterMode = false
        filterStores = []
        print(" 필터 모드 해제: 현재 위치 조회로 복귀")
    }
    
    // 모든 모드 해제 함수 추가
    private func exitAllModes() {
        exitSearchMode()
        exitFilterMode()
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
