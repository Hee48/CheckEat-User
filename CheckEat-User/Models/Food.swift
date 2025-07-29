//
//  Food.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/21/25.
//

struct Food: Decodable {
    let foo_id: Int
    let foo_name: String
    let foo_material: String?
    let foo_price: Int
    let foo_img: String?
    let foo_status: Int
    let foo_allergy_common: Int?
    let foo_sa_id: Int
    let foo_vegan: Int?
    let ft_id: Int
    let sto_id: Int
}

