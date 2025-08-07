//
//  VisitedStore.swift
//  CheckEat-User
//
//  Created by Hee  on 8/6/25.
//

//마이페이지 - 이용한가게 리뷰작성된것 모델
struct MyReview: Codable {
    let revi_id: Int
    let revi_create: String
    let revi_content: String?
    let revi_reco_step: Int
    let revi_reco_vegan: Int
    let images: [String]
    let store: StoreInfo
    let food_list: [FoodInfo]
}

struct StoreInfo: Codable {
    let sto_id: Int
    let sto_name: String
    let sto_img: String?
}

struct FoodInfo: Codable {
    let foo_id: Int
    let foo_img: String?
    let foo_name: String
}

struct MyReviewsResponse: Codable {
    let totalCount: Int
    let page: Int
    let limit: Int
    let totalPages: Int
    let reviews: [MyReview]
}

//마이페이지 - 이용한가게 리뷰 미작성 모델
struct UnwrittenReviewsResponse: Codable {
    let totalCount: Int
    let page: Int
    let limit: Int
    let totalPages: Int
    let stores: [UnwrittenStore]
}

struct UnwrittenStore: Codable, Identifiable {
    let sto_id: Int
    let sto_name: String
    let sto_name_en: String

    var id: Int { sto_id }
}

