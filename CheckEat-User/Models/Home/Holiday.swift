//
//  Holiday.swift
//  CheckEat-User
//
//  Created by 최준영 on 7/24/25.
//

struct Holiday: Codable {
    let holi_id: Int
    let holi_weekday: Int
    let holi_break: String
    let holi_runtime_sun: String?
    let holi_runtime_mon: String?
    let holi_runtime_tue: String?
    let holi_runtime_wed: String?
    let holi_runtime_thu: String?
    let holi_runtime_fri: String?
    let holi_runtime_sat: String?
    let holi_regular: String?
    let holi_public: String?
    let holi_sajang_id: Int
}
