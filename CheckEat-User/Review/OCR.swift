//
//  OCRModel.swift
//  CheckEat-User
//
//  Created by Hee  on 8/4/25.
//


struct OCRResponse: Decodable, Equatable {
    let store: String
    let address: String?
    let menus: [MenuItemDto]
    let total: Int?
}

struct MenuItemDto: Decodable, Equatable {
    let name: String
    let price: Int?
}
