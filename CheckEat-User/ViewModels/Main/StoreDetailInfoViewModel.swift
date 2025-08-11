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

    private let storeDetailInfoService = StoreDetailInfoService()

    func loadStoreDetailInfo(storeId: Int, language: String) {
        isLoading = true
        defer { self.isLoading = false }
        errorMessage = nil

        Task {
            do {
                let storeDetailInfo = try await storeDetailInfoService.loadStoreDetailInfo(
                    storeId: storeId,
                    language: language
                )
                print("✅ 가게 상세 정보 조회 성공")
                self.storeDetailInfo = storeDetailInfo
            } catch {
                print("🚨 가게 상세 정보 조회 실패: \(error.localizedDescription)")
                self.errorMessage = "해당 가게 정보를 가져오는 데 실패했어요...\n잠시후에 다시 시도해주세요!"
            }
        }
    }
}
