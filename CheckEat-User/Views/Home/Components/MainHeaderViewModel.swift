//
//  MainHeaderViewModel.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/10/25.
//

import Foundation
import CoreLocation
import Combine

class MainHeaderViewModel: ObservableObject {
    
    @Published var isFilterActive = false
    @Published var lastSuccessfulFilter: String?
    @Published var hasFilterError = false
    @Published var currentFilter: String = "" // 현재 선택된 필터 추가
    
    private let searchByNameViewModel = SearchByStoreNameViewModel()
    private let searchByVeganLevelViewModel = SearchByVeganLevelViewModel()
    
    // 콜백들
    var onSearchResult: (([Stores]) -> Void)?
    var onSearchError: ((String?) -> Void)?
    var onFilterResult: (([Stores]) -> Void)?
    var onFilterError: ((String?) -> Void)?
    var onFilterClear: (() -> Void)?
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        // 검색 결과 바인딩
        searchByNameViewModel.$storesByName
            .sink { [weak self] stores in
                self?.onSearchResult?(stores)
            }
            .store(in: &cancellables)
        
        // 검색 에러 바인딩
        searchByNameViewModel.$errorMessage
            .sink { [weak self] errorMessage in
                self?.onSearchError?(errorMessage)
            }
            .store(in: &cancellables)
        
        // 필터 결과 바인딩
        searchByVeganLevelViewModel.$storesByVeganLevel
            .sink { [weak self] stores in
                self?.handleFilterResult(stores)
            }
            .store(in: &cancellables)
        
        // 필터 에러 바인딩
        searchByVeganLevelViewModel.$errorMessage
            .sink { [weak self] errorMessage in
                self?.handleFilterError(errorMessage)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    func performSearchByName(searchText: String, location: CLLocationCoordinate2D?) {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("🔍❌ 검색어가 비어있습니다")
            return
        }
        
        guard let center = location else {
            print("🚨 현재 위치 정보가 없습니다")
            return
        }
        
        print("🔍 가게명 검색 실행: \(searchText)")
        
        searchByNameViewModel.searchByStoreName(
            storeName: searchText,
            latitude: String(center.latitude),
            longitude: String(center.longitude),
            language: LanguageSettingsViewModel.getCurrentLanguage(),
            radius: "500000" // 가게명 검색시 반경 넓히기?
        )
    }
    
    func performFilterSearch(filter: String, location: CLLocationCoordinate2D?) {
        // 현재 필터 업데이트
        currentFilter = filter
        
        // 중복 요청 방지
        if lastSuccessfulFilter == filter && isFilterActive {
            print("🔄 동일한 필터가 이미 적용되어 있습니다: \(filter)")
            return
        }
        
        // 상태 초기화
        resetFilterState()
        
        guard let center = location else {
            print("🚨 현재 위치 정보가 없습니다")
            return
        }
        
        let mappedVeganLevel = convertFilterToVeganLevel(filter)
        print("✅ 비건 레벨 검색 실행: \(filter) -> \(mappedVeganLevel)")
        
        searchByVeganLevelViewModel.searchByVeganLevel(
            veganLevel: mappedVeganLevel,
            latitude: String(center.latitude),
            longitude: String(center.longitude),
            language: LanguageSettingsViewModel.getCurrentLanguage(),
            radius: "2000"
        )
    }
    
    func clearFilter() {
        print(" 필터 해제 - 현재 좌표 기준으로 재조회")
        resetFilterState()
        currentFilter = "" // 현재 필터 초기화
        onFilterClear?()
    }
    
    // MARK: - Private Methods
    
    private func handleFilterResult(_ stores: [Stores]) {
        if !hasFilterError {
            if !stores.isEmpty || searchByVeganLevelViewModel.errorMessage == nil {
                isFilterActive = true
                lastSuccessfulFilter = currentFilter
                hasFilterError = false
                print("✅ 필터 활성화: \(currentFilter)")
            }
            onFilterResult?(stores)
        }
    }
    
    private func handleFilterError(_ errorMessage: String?) {
        if errorMessage != nil {
            resetFilterState()
            print("🚨 필터 에러로 인한 상태 초기화")
            onFilterResult?([])
        } else {
            hasFilterError = false
        }
        onFilterError?(errorMessage)
    }
    
    private func resetFilterState() {
        isFilterActive = false
        lastSuccessfulFilter = nil
        hasFilterError = false
    }
    
    private func convertFilterToVeganLevel(_ filter: String) -> String {
        let filterMapping = [
            "비건": "1",
            "락토": "2",
            "오보": "3",
            "락토오보": "4",
            "페스코": "5",
            "폴로": "6"
        ]
        return filterMapping[filter] ?? "0"
    }
    
    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>()
}
