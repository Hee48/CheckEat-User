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
        didSet {
            applyFilters()
        }
    }
    
    @Published var selectedFilter: String = "" {
        didSet {
            applyFilters()
        }
    }
    
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
        // Early exit: If both searchText and selectedFilter are empty, show all stores
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && selectedFilter.isEmpty {
            filteredStores = allStores
            return
        }
        
        let keyword = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // 1. 가게명 매칭
        let nameMatches = allStores.filter {
            $0.sto_name.lowercased().contains(keyword)
        }
        
        // 2. 메뉴명 매칭
        let foodMatches = allFoods.filter {
            $0.foo_name.lowercased().contains(keyword)
        }
        let foodStoreIds = Set(foodMatches.map { $0.sto_id })
        let menuMatches = allStores.filter { foodStoreIds.contains($0.storeId) }
        
        // 3. 카테고리 키워드 기반 비건 매칭
        var categoryStoreMatches: [Store] = []
        if let veganLevel = veganLevelFromFilter(filter: selectedFilter) ?? veganLevelFromKeyword(keyword: keyword) {
            categoryStoreMatches = allStores.filter {
                storeHasVeganLevel(veganLevel, for: $0)
            }
        }
        
        // 4. 할랄 매칭
        var halalMatches: [Store] = []
        if selectedFilter == "할랄" || keyword.contains("할랄") {
            halalMatches = allStores.filter { $0.sto_halal == 1 }
        }
        
        // 5. 최종 결과: 중복 제거된 합집합
        let combined = Set(nameMatches + menuMatches + categoryStoreMatches + halalMatches)
        filteredStores = Array(combined)
    }
    
    // Returns the lowest (most strict) vegan level for a store, or nil if none.
    private func storeHighestVeganLevel(for store: Store) -> Int? {
        allFoods
            .filter { $0.sto_id == store.storeId && $0.foo_vegan != nil }
            .compactMap { $0.foo_vegan }
            .min()
    }
    
    private func veganLevelFromKeyword(keyword: String) -> Int? {
        if keyword.contains("락토오보") { return 4 }
        if keyword.contains("비건") { return 1 }
        if keyword.contains("락토") { return 2 }
        if keyword.contains("오보") { return 3 }
        if keyword.contains("페스코") { return 5 }
        if keyword.contains("폴로") { return 6 }
        return nil
    }
    
    func veganLevelFromFilter(filter: String) -> Int? {
        switch filter {
        case "락토오보": return 4
        case "비건": return 1
        case "락토": return 2
        case "오보": return 3
        case "페스코": return 5
        case "폴로": return 6
        default: return nil
        }
    }
    
    private func filterByVegan(_ levels: [Int], from stores: [Store]) -> [Store] {
        let matchedStoreIds = Set(
            allFoods
                .filter { $0.foo_vegan != nil && levels.contains($0.foo_vegan!) }
                .map { $0.sto_id }
        )
        return stores.filter { matchedStoreIds.contains($0.storeId) }
    }
    
    func highestVeganLevel(for store: Store, filter: String) -> Int? {
        let filterLevel: [Int]? = {
            switch filter {
            case "비건": return [1]
            case "락토": return [2]
            case "오보": return [3]
            case "락토오보": return [4]
            case "페스코": return [5]
            case "폴로": return [6]
            default: return nil
            }
        }()
        
        let levels = allFoods
            .filter { $0.sto_id == store.storeId && $0.foo_vegan != nil }
            .compactMap { $0.foo_vegan }
        
        if let filterLevel = filterLevel {
            return levels.filter { filterLevel.contains($0) }.max()
        } else {
            return levels.max()
        }
    }
    
    func activeCategoryFromSearch() -> String {
        let keyword = searchText.lowercased()
        if keyword.contains("비건") { return "비건" }
        if keyword.contains("락토오보") { return "락토오보" }
        if keyword.contains("락토") { return "락토" }
        if keyword.contains("오보") { return "오보" }
        if keyword.contains("페스코") { return "페스코" }
        if keyword.contains("폴로") { return "폴로" }
        if keyword.contains("할랄") { return "할랄" }
        return selectedFilter
    }
    
    private func storeHasVeganLevel(_ level: Int, for store: Store) -> Bool {
        return allFoods.contains {
            $0.sto_id == store.storeId && $0.foo_vegan == level
        }
    }
}
