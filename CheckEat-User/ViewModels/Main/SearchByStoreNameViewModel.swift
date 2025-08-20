//
//  SearchByStoreNameViewModel.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/10/25.
//

import SwiftUI
import Combine

class SearchByStoreNameViewModel: ObservableObject {
    
    @Published var storesByName: [Stores] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let nameByStoreService = SearchByStoreNameService()
    
    func searchByStoreName(storeName: String, latitude: String, longitude: String, language: String, radius: String) {
        
        guard !storeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "가게명을 입력해주세요."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let stores = try await nameByStoreService.searchByStoreName(
                    storeName: storeName,
                    latitude: latitude,
                    longitude: longitude,
                    language: language,
                    radius: radius
                )
                
                await MainActor.run {
                    self.storesByName = stores
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "search_by_store_name_error".localized
                    self.isLoading = false
                }
            }
        }
    }
}
