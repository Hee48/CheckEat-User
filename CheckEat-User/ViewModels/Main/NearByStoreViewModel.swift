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
                    let messages = [
                        "사막 같은 지도네요...\n가게 몇 방울만 수집해올게요...",
                        "아직 이 지역은 미지의 구역이에요.\n탐험가를 더 모집해올게요!",
                        "앗, 표시할 가게가 없어요...\n다음 업데이트를 기대해주세요!."
                    ]
                    self.errorMessage = messages.randomElement() ?? "이 지역은 서비스 준비 중이에요.\n곧 찾아갈게요!"
                    self.isLoading = false
                }
            }
        }
    }
}
