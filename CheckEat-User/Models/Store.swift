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
    let sto_address: String
    let sto_phone: String
    let sto_halal: Int
    let sto_type: String
    let sto_latitude: Double
    let sto_longitude: Double
    let sto_sa_id: Int

    enum CodingKeys: String, CodingKey {
        case storeId = "sto_id"
        case sto_name, sto_img, sto_address, sto_phone, sto_halal,
             sto_type, sto_latitude, sto_longitude, sto_sa_id
    }

    var id: Int { storeId }
}
