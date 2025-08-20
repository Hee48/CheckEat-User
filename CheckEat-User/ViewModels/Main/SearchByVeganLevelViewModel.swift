//
//  SearchByVeganLevelViewModel.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/10/25.
//

import SwiftUI
import Combine

class SearchByVeganLevelViewModel: ObservableObject {
    
    @Published var storesByVeganLevel: [Stores] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let veganLevelByStoreService = SearchByVeganLevelService()
    
    func searchByVeganLevel(veganLevel: String, latitude: String, longitude: String, language: String, radius: String) {
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let stores = try await veganLevelByStoreService.searchByVeganLevel(
                    veganLevel: veganLevel,
                    latitude: latitude,
                    longitude: longitude,
                    language: language,
                    radius: radius
                )
                
                await MainActor.run {
                    print("✅ 비건 레벨 검색 성공: \(stores.count)개")
                    self.storesByVeganLevel = stores
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    print("🚨 비건 레벨 검색 실패: \(error.localizedDescription)")
                    self.errorMessage = "search_by_store_vegan_level_error".localized
                    self.isLoading = false
                }
            }
        }
    }
}
