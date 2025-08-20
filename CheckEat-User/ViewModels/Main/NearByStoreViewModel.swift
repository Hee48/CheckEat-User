//
//  NearByStoreViewModel.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/9/25.
//

import SwiftUI
import Combine

class NearByStoreViewModel: ObservableObject {
    
    @Published var nearbyStores: [Stores] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let storeService = NearByStoreService()
    
    func fetchNearByStores(latitude: String, longitude: String, radius: String) {
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let stores = try await storeService.fetchNearByStores(
                    latitude: latitude,
                    longitude: longitude,
                    radius: radius
                )
                
                await MainActor.run {
                    self.nearbyStores = stores
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "store_list_fetch_error".localized
                    self.isLoading = false
                }
            }
        }
    }
}
