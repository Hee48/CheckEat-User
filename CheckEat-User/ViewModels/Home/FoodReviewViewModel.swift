//
//  FoodReviewViewModel.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/27/25.
//

import Foundation
import Combine

class FoodReviewViewModel: ObservableObject {
    
    @Published var allReviews: [Review] = []
    private let foodList: [Food]
    
    init(foodList: [Food]) {
        self.foodList = foodList
        loadReviews()
    }
    
    private func loadReviews() {
        guard let url = Bundle.main.url(forResource: "review_dummy_data", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Review].self, from: data) else {
            print("❌ Review JSON 로드 실패")
            return
        }
        allReviews = decoded
    }
    
    func reviews(for foodId: Int) -> [Review] {
        let filtered = allReviews.filter { $0.food_id == foodId }
        print("🔍 \(foodId)번 음식에 대한 리뷰 \(filtered.count)개")
        return filtered
    }
    
    func foodName(for foodId: Int) -> String? {
        print("🔎 foodName(for: \(foodId)) 호출됨 — foodList.count = \(foodList.count)")
        return foodList.first(where: { $0.foo_id == foodId })?.foo_name
    }
    
    func storeName(for foodId: Int, from stores: [Store]) -> String? {
        guard let food = foodList.first(where: { $0.foo_id == foodId }) else { return nil }
        return stores.first(where: { $0.id == food.sto_id })?.sto_name
    }
}
