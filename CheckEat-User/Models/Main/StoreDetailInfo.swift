//
//  StoreDetailInfo.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/11/25.
//

//MARK: 가게 상세정보 조회
struct StoreDetailInfo: Decodable {
    
    //    let sto_id: Int
    let sto_name_en: String
    let sto_img: String?
    let sto_address: String
    let sto_type: String
    let sto_halal: Int
    let sto_latitude: Double
    let sto_longitude: Double
    let food_list: [MenuInfo]
    
    //    var id: Int { sto_id }
    
}

struct MenuInfo: Decodable, Identifiable {
    
    let foo_id: Int
    let foo_name: String
    let foo_material: [String]
    let foo_price: String
    let foo_img: String?
    let foo_status: Int
    
    var id: Int { foo_id }
    
}
