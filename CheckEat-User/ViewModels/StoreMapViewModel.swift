//
//  StoreMapViewModel.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/21/25.
//

import Foundation
import Combine

class StoreMapViewModel: ObservableObject {
    
    @Published var allStores: [Store] = []
    @Published var allFoods: [Food] = []
    @Published var filteredStores: [Store] = []
    
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
    
    init() {
        loadStores()
        loadFoods()
    }
    
    private func loadStores() {
        guard let url = Bundle.main.url(forResource: "store_dummy_data_200", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Store].self, from: data) else {
            print("❌ Store JSON 로드 실패")
            return
        }
        allStores = decoded
        filteredStores = decoded
    }
    
    private func loadFoods() {
        guard let url = Bundle.main.url(forResource: "food_dummy_data_650", withExtension: "json"),
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
    
    func highestVeganLevel(for store: Store, filter: String) -> Int? {
        let relevantLevels = filterToVeganLevel[filter].map { [$0] }
        let levels = allFoods
            .filter { $0.sto_id == store.storeId && $0.foo_vegan != nil }
            .compactMap { $0.foo_vegan }
        return relevantLevels != nil ? levels.filter { relevantLevels!.contains($0) }.max() : levels.max()
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
}
