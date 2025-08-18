//
//  ReviewPage.swift
//  CheckEat-User
//
//  Created by Hee  on 8/5/25.
//

import Foundation

//리뷰등록때 우리어플에 등록되어있는가게인지 확인하는 요청
struct CanWriteReviewRequest: Codable {
    let sto_name: String
    let sto_address: String
}
//리뷰등록때 우리어플에 등록되어있는가게인지 확인하는 응답
struct CanWriteReviewResponse: Decodable {
    let message: String
    let status: String
    let sto_id: Int
}
//리뷰등록때 다음에등록눌렀을시 추후등록으로 서버에 전달 요청
struct RegisterLaterRequest: Codable {
    let sto_id: Int
}
//리뷰등록때 다음에등록눌렀을시 추후등록으로 서버에 전달 응답
struct RegisterLaterResponse: Decodable {
    let message: String
    let review_id: Int
    let status: String
}
//리뷰등록때 가게 메뉴 리스트 요청
struct RegisterMenuPageRequest: Codable {
    let sto_id: Int
}
//리뷰등록때 가게 메뉴 리스트 응답
typealias RegisterMenuPageResponse = [StoreMenuItem]

struct StoreMenuItem: Decodable {
    let foo_id: Int
    let foo_price: Int
    let foo_img: String?
    let foo_name: String
    let foo_material: [String]
}
//리뷰등록 요청
struct RegisterReviewRequest: Codable {
    let food_ids: [Int]
    let store_id: Int
    let revi_content: String?
    let revi_reco_vegan: Int
    let revi_reco_step: Int
    let revi_status: Int
}
//리뷰등록 응답
struct RegisterReviewResponse: Decodable {
    let message: String
    let review_id: Int
    let uploaded_images: Int
}
