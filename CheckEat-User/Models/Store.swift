//
//  Store.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/21/25.
//

struct Store: Decodable, Identifiable, Hashable {
    let storeId: Int
    let sto_name: String
    let sto_img: String?
    let sto_halal: Int
    let sto_type: String
    let sto_sa_id: Int
    let sto_address: String
    let sto_latitude: Double
    let sto_longitude: Double
    let sto_phone: String
    let sto_name_en: String?
    let sto_status: Int
    
    enum CodingKeys: String, CodingKey {
        case storeId = "sto_id"
        case sto_name, sto_img, sto_halal, sto_type, sto_sa_id, sto_address,
             sto_latitude, sto_longitude, sto_phone, sto_name_en, sto_status
    }
    
    var id: Int { storeId }
}
