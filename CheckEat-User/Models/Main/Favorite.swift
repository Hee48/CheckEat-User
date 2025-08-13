//
//  Favorite.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/12/25.
//


struct FavoriteStore: Decodable {
    
    let message: String
    let status: String
    
}

struct FavoriteStoreItem: Decodable {
    let sto_id: Int
    let sto_name: String
    let sto_img: String?
    let sto_address: String
    let today_runtime: String?
    let holi_break: String?
    let holi_regular: String?
    let holi_public: String?
}

struct FavoriteStoreListResponse: Decodable {
    let status: String
    let stores: [FavoriteStoreItem]
}
