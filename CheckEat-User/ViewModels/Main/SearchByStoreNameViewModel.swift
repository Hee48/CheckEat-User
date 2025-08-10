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
                    let messages = [
                        "앗! 아직 등록되지 않은 가게예요...\n곧 추가될지도 몰라요",
                        "탐험을 열심히 하는 중이에요...\n다음 업데이트를 기대해주세요!",
                        "찾으시는 가게가 숨은 맛집인가요?\n우리 지도에선 보이지가 않네요..."
                    ]
                    self.errorMessage = messages.randomElement() ?? "찾으시는 가게명으로 등록된 가게가 없습니다."
                    self.isLoading = false
                }
            }
        }
    }
}
