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
    
    @Published var allStores: [Store] = []
    @Published var allFoods: [Food] = []
    @Published var filteredStores: [Store] = []
    
    @Published var nearbyStores: [Store] = []
    
    @Published var searchText: String = "" {
        didSet { applyFilters() }
    }
    
    @Published var selectedFilter: String = "" {
        didSet { applyFilters() }
    }
    
    private let filterToVeganLevel: [String: Int] = [
        "비건": 1, "락토": 2, "오보": 3,
        "락토오보": 4, "페스코": 5, "폴로": 6
    ]
    
    private var veganLevelCache: [Int: Int] = [:]
    
    init() {
        loadStores()
        loadFoods()
        // precomputeAllVeganLevels()
    }
    
    private func loadStores() {
        guard let url = Bundle.main.url(forResource: "store_dummy_data", withExtension: "json"),
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
        let trimmedKeyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        guard !trimmedKeyword.isEmpty || !selectedFilter.isEmpty else {
            filteredStores = allStores
            return
        }
        
        let keywordLevel = veganLevel(from: selectedFilter) ?? veganLevel(from: trimmedKeyword)
        let halalSearch = selectedFilter == "할랄" || trimmedKeyword.contains("할랄")
        
        // Store name matches
        let storeMatches = allStores.filter {
            $0.sto_name.lowercased().contains(trimmedKeyword)
        }
        
        // Menu name matches
        let menuStoreIds = Set(
            allFoods
                .filter { $0.foo_name.lowercased().contains(trimmedKeyword) }
                .map { $0.sto_id }
        )
        let menuMatches = allStores.filter { menuStoreIds.contains($0.storeId) }
        
        // Vegan category matches
        let categoryMatches: [Store] = {
            guard let level = keywordLevel else { return [] }
            let matchedIds = Set(
                allFoods
                    .filter { $0.foo_vegan == level }
                    .map { $0.sto_id }
            )
            return allStores.filter { matchedIds.contains($0.storeId) }
        }()
        
        // Halal matches
        let halalMatches = halalSearch ? allStores.filter { $0.sto_halal == 1 } : []
        
        // Combine all matches
        filteredStores = Array(Set(storeMatches + menuMatches + categoryMatches + halalMatches))
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
    
    
    /*
     func precomputeAllVeganLevels() {
     veganLevelCache = [:]
     for store in allStores {
     let levels = allFoods
     .filter { $0.sto_id == store.storeId && (1...6).contains($0.foo_vegan ?? 0) }
     .compactMap { $0.foo_vegan }
     let mostStrict = levels.min() ?? 0
     veganLevelCache[store.storeId] = mostStrict
     }
     }
     */
    
    /*
     func cachedVeganLevel(for store: Store) -> Int? {
     return veganLevelCache[store.storeId]
     }
     */
    
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
    
    func storesForModalList(center: CLLocationCoordinate2D?, radius: Double = 2000) -> [Store] {
        let hasFilter = !selectedFilter.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        let hasSearch = !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        
        if hasFilter || hasSearch {
            let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let keywordLevel = veganLevel(from: selectedFilter) ?? veganLevel(from: keyword)
            let halalSearch = selectedFilter == "할랄" || keyword.contains("할랄")

            let matchedByVegan = Set(
                allFoods.filter {
                    guard let level = keywordLevel else { return false }
                    return $0.foo_vegan == level
                }.map { $0.sto_id }
            )

            let matchedByMenuName = Set(
                allFoods.filter {
                    $0.foo_name.lowercased().contains(keyword)
                }.map { $0.sto_id }
            )

            let result = allStores.filter { store in
                (store.sto_name.lowercased().contains(keyword) ||
                 matchedByVegan.contains(store.storeId) ||
                 matchedByMenuName.contains(store.storeId) ||
                 (halalSearch && store.sto_halal == 1)) &&
                (center == nil || CLLocation(latitude: store.sto_latitude, longitude: store.sto_longitude).distance(from: CLLocation(latitude: center!.latitude, longitude: center!.longitude)) <= radius)
            }

            return result
        } else {
            return nearbyStores
        }
    }
}

