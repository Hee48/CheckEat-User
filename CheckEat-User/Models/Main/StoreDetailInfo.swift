//
//  StoreDetailInfo.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/11/25.
//

//MARK: 가게 상세정보 조회
struct StoreDetailInfo: Decodable {
    
    let sto_id: Int
    let sto_name: String
    let sto_name_en: String
    let sto_img: String?
    let sto_address: String
    let sto_type: String
    let sto_halal: Int
    let sto_latitude: Double
    let sto_longitude: Double
    let sto_phone: String?
    let food_list: [MenuInfo]
    let holiday: HolidayInfo?
    
}

struct MenuInfo: Decodable, Identifiable {
    
    let foo_id: Int
    let foo_name: String
    let foo_material: [String]
    let foo_price: String
    let foo_img: String?
    let foo_vegan: Int
    let foo_status: Int
    let CommonAl: [CommonAlInfo]
    let foo_warning: String?
    let foo_warning_coal: [Int]?
    
    var id: Int { foo_id }
    
}

struct CommonAlInfo: Decodable {
    let coal_id: Int
}

struct HolidayInfo: Decodable {
    let holi_weekday: Int?
    let today: String?
    let holi_break: String?
    let holi_regular: [String]
    let holi_public: [String]
    let holi_runtime_sun: String?
    let holi_runtime_mon: String?
    let holi_runtime_tue: String?
    let holi_runtime_wed: String?
    let holi_runtime_thu: String?
    let holi_runtime_fri: String?
    let holi_runtime_sat: String?
}
