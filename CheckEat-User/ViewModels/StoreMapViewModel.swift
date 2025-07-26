//
//  StoreMapViewModel.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/21/25.
//

import Foundation
import Combine
import CoreLocation

class StoreMapViewModel: ObservableObject {
    
    enum MarkerDisplayMode {
        case all
        case favorite
    }

    @Published var allStores: [Store] = []
    @Published var allFoods: [Food] = []
    @Published var filteredStores: [Store] = []
    @Published var nearbyStores: [Store] = []
    @Published var favoriteStores: [Store] = []
    @Published var favoriteStoreIds: Set<Int> = [] {
        didSet {
            saveFavorites()
            updateFavoriteStores()
        }
    }

    @Published var markerMode: MarkerDisplayMode = .all
    
    @Published var searchText: String = "" {
        didSet { applyFilters() }
    }
    
    @Published var selectedFilter: String = "" {
        didSet { applyFilters() }
    }
    
    @Published var selectedStoreType: String = "전체" {
        didSet { applyFilters() }
    }
    
    private let filterToVeganLevel: [String: Int] = [
        "비건": 1, "락토": 2, "오보": 3,
        "락토오보": 4, "페스코": 5, "폴로": 6
    ]
    
    private var veganLevelCache: [Int: Int] = [:]
    private let favoritesKey = "favorite_store_ids"
    
    init() {
        loadStores()
        loadFoods()
        loadFavorites()
    }
    
    private func loadStores() {
        guard let url = Bundle.main.url(forResource: "store_dummy_data_new", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Store].self, from: data) else {
            print("❌ Store JSON 로드 실패")
            return
        }
        allStores = decoded
        filteredStores = decoded
    }
    
    private func loadFoods() {
        guard let url = Bundle.main.url(forResource: "food_dummy_data", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Food].self, from: data) else {
            print("❌ Food JSON 로드 실패")
            return
        }
        allFoods = decoded
    }
    
    func applyFilters() {
        let trimmedKeyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedFilter = selectedFilter.trimmingCharacters(in: .whitespacesAndNewlines)
        let isDefault = trimmedKeyword.isEmpty && trimmedFilter.isEmpty && selectedStoreType == "전체"
        if isDefault {
            filteredStores = allStores
        } else {
            filteredStores = storesForModalList(center: nil)
        }
    }

    func filteredMenus(for tab: String, storeId: Int) -> [Food] {
        
        let storeMenus = allFoods.filter { $0.sto_id == storeId }
        
        switch tab {
        case "전체메뉴":
            return storeMenus
        case "채식메뉴":
            return storeMenus.filter { $0.foo_vegan != 0 }
        default:
            print("XXX 메뉴 카테고리별 필터링 조회 오류 발생")
            return []
        }
    }
    
    private func veganLevel(from keyword: String) -> Int? {
        for (filter, level) in filterToVeganLevel.sorted(by: { $0.value < $1.value }) {
            if keyword.contains(filter.lowercased()) {
                return level
            }
        }
        return nil
    }
    
    func veganLevelFromFilter(filter: String) -> Int? {
        return filterToVeganLevel[filter]
    }
    
    private func storeHasVeganLevel(_ level: Int, for store: Store) -> Bool {
        allFoods.contains { $0.sto_id == store.storeId && $0.foo_vegan == level }
    }
    
    func activeCategoryFromSearch() -> String {
        let keyword = searchText.lowercased()
        for (filter, _) in filterToVeganLevel {
            if keyword.contains(filter.lowercased()) {
                return filter
            }
        }
        return keyword.contains("할랄") ? "할랄" : selectedFilter
    }
    
    func updateNearbyStores(center: CLLocationCoordinate2D, radius: Double = 2000) {
        print("🎯 중심 좌표(백엔드로 넘길 현재 좌표): \(center.latitude), \(center.longitude)")
        let filtered = allStores.filter { store in
            let storeLocation = CLLocation(latitude: store.sto_latitude, longitude: store.sto_longitude)
            let centerLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
            let distance = storeLocation.distance(from: centerLocation)
            return distance <= radius
        }
        print("🔎 반경 내 가게 수: \(filtered.count)")
        nearbyStores = filtered
    }
    
    // MARK: - FavoriteMode
    
    var isFavoriteMode: Bool {
        markerMode == .favorite
    }

    // MARK: - Favorites Management

    func toggleFavorite(for store: Store) {
        if favoriteStoreIds.contains(store.storeId) {
            favoriteStoreIds.remove(store.storeId)
        } else {
            favoriteStoreIds.insert(store.storeId)
        }
    }

    func isFavorite(store: Store) -> Bool {
        return favoriteStoreIds.contains(store.storeId)
    }

    // favoriteStores is now a stored property, updated via updateFavoriteStores()

    func updateFavoriteStores() {
        favoriteStores = allStores.filter { favoriteStoreIds.contains($0.storeId) }
        print("📌 즐겨찾기 목록 새로 고침: \(favoriteStores.count)개")
    }
    
    var storesToDisplayOnMap: [Store] {
        switch markerMode {
        case .all:
            return nearbyStores
        case .favorite:
            return nearbyStores.filter { favoriteStoreIds.contains($0.storeId) }
        }
    }
    
    func saveFavorites() {
       let idsArray = Array(favoriteStoreIds)
       UserDefaults.standard.set(idsArray, forKey: favoritesKey)
   }

    func loadFavorites() {
       if let ids = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] {
           favoriteStoreIds = Set(ids)
       }
   }
    
    func storesForModalList(center: CLLocationCoordinate2D?, radius: Double = 2000) -> [Store] {
        let trimmedKeyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let filterKeyword = selectedFilter.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        let effectiveStoreType: String = {
            if trimmedKeyword.contains("음식점") {
                return "음식점"
            } else if trimmedKeyword.contains("카페") {
                return "카페"
            }
            return selectedStoreType.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        }()
        
        let effectiveVeganLevel: Int? = {
            if let level = veganLevel(from: filterKeyword) {
                return level
            }
            return veganLevel(from: trimmedKeyword)
        }()
        
        let halalSearch = filterKeyword == "할랄" || trimmedKeyword.contains("할랄")
        
        let noFilterOrSearch = trimmedKeyword.isEmpty && filterKeyword.isEmpty && effectiveStoreType == "전체"
        if noFilterOrSearch {
            return nearbyStores
        }
        
        let matchedByVegan = Set(
            allFoods.filter {
                if let level = effectiveVeganLevel {
                    return $0.foo_vegan == level
                }
                return false
            }.map { $0.sto_id }
        )
        
        let matchedByMenuName = Set(
            allFoods.filter {
                $0.foo_name.lowercased().contains(trimmedKeyword)
            }.map { $0.sto_id }
        )
        
        let result = allStores.filter { store in
            
            let matchesLocation = (center == nil || CLLocation(latitude: store.sto_latitude, longitude: store.sto_longitude).distance(from: CLLocation(latitude: center!.latitude, longitude: center!.longitude)) <= radius)
            
            let storeType = store.sto_type.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let matchesType = effectiveStoreType == "전체" || storeType == effectiveStoreType
            
            let matchesKeyword = store.sto_name.lowercased().contains(trimmedKeyword)
                || matchedByVegan.contains(store.storeId)
                || matchedByMenuName.contains(store.storeId)
                || (halalSearch && store.sto_halal == 1)
            
            return matchesKeyword && matchesLocation && matchesType
            
        }
        return result
    }
}
