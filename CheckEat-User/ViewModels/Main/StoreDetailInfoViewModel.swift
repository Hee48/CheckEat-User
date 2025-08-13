//
//  StoreDetailInfoViewModel.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/11/25.
//

import SwiftUI
import Combine

@MainActor
class StoreDetailInfoViewModel: ObservableObject {
    
    @Published var storeDetailInfo: StoreDetailInfo? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isFavoriteLoading = false
    @Published var showLoginView = false

    // Favorites (UserDefaults-backed)
    private let favoritesKey = "favorite_store_ids"
    @Published var favoriteStoreIds: Set<Int> = []
    
    private let storeDetailInfoService = StoreDetailInfoService()
    private let favoriteService = ManageFavoriteService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadFavoritesFromServer()
    }
    
    func loadFavoritesFromServer() {
        favoriteService.fetchFavoriteStores()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("✅ 서버에서 즐겨찾기 목록 로드 완료")
                case .failure(let error):
                    print("❌ 서버에서 즐겨찾기 목록 로드 실패:", error.localizedDescription)
                    self.errorMessage = "즐겨찾기 목록을 가져오는데 실패했습니다."
                }
            } receiveValue: { storeIds in
                // 서버에서 받은 store_id 배열을 Set으로 변환
                self.favoriteStoreIds = Set(storeIds)
                
                print("📌 서버에서 가져온 즐겨찾기 가게 수: \(storeIds.count)개")
            }
            .store(in: &cancellables)
    }

    func isFavorite(storeId: Int) -> Bool {
        favoriteStoreIds.contains(storeId)
    }

    func toggleFavorite(storeId: Int) {
        // 로그인 상태 확인
        guard AuthViewModel.shared.isLoggedIn else {
            print("🚫 로그인이 필요합니다. 로그인 화면을 띄웁니다.")
            showLoginView = true
            return
        }
        
        isFavoriteLoading = true
        
        favoriteService.toggleFavorite(storeId: (storeId), isCurrentlyFavorite: self.favoriteStoreIds.contains(storeId))
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isFavoriteLoading = false
                switch completion {
                case .finished:
                    print("즐겨찾기 토글 완료")
                case .failure(let error):
                    print("즐겨찾기 토글 실패:", error.localizedDescription)
                    self.errorMessage = "즐겨찾기 처리에 실패했습니다."
                }
            } receiveValue: { success in
                if success {
                    // 성공 시에만 UI 업데이트
                    if self.favoriteStoreIds.contains(storeId) {
                        self.favoriteStoreIds.remove(storeId)
                    } else {
                        self.favoriteStoreIds.insert(storeId)
                    }
                    UserDefaults.standard.set(Array(self.favoriteStoreIds), forKey: self.favoritesKey)
                }
            }
            .store(in: &cancellables)
    }

    func loadStoreDetailInfo(storeId: Int, language: String) {
        errorMessage = nil
        isLoading = true

        Task {
            defer { isLoading = false }
            do {
                let storeDetailInfo = try await storeDetailInfoService.loadStoreDetailInfo(
                    storeId: storeId,
                    language: language
                )
                print("✅ 가게 상세 정보 조회 성공")
                self.storeDetailInfo = storeDetailInfo
            } catch {
                print(" 가게 상세 정보 조회 실패: \(error.localizedDescription)")
                self.errorMessage = "해당 가게 정보를 가져오는 데 실패했어요...\n잠시후에 다시 시도해주세요!"
            }
        }
    }
}
