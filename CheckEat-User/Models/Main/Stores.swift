//
//  Stores.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/9/25.
//

//MARK: 사용자 현재 위치 반경 지정 가게 조회, 가게명/비건레벨로 가게 조회 (response 동일)
struct Stores: Decodable, Identifiable, Hashable {
    
    let storeId: Int
    let sto_name: String
    let sto_latitude: Double
    let sto_longitude: Double
    let sto_type: String
    let sto_address: String
    let sto_halal: Int // 0: 할랄 인증 x, 1: 할랄 인증 받은 가게
    let sto_status: Int // 0: 정상영업, 1: 임시 휴업/휴가, 2: 가게접음 (2번은 걸러서 보내주고 잇음)
    let sto_img: String? // 기본 영업장 이미지 설정 필요함
    let distance: Double // 현재 위치에서의 거리
    
    let holi_weekday: Int // 요일 (얘는 쓸지 안 쓸지 고민)
    
    let today_runtime: String? //금일 영업시간
    let holi_break: String? // 브레이크 타임
    
    // 쓰이지 않은 정보 필드
    let holi_regular: [String]? // 정기 휴일 정보
    let holi_public: [String]? // 공휴일 휴무 정보
    
    enum CodingKeys: String, CodingKey {
        case storeId = "sto_id"
        case sto_name, sto_latitude, sto_longitude, sto_type, sto_address, sto_halal, sto_status, sto_img, distance, holi_weekday, today_runtime, holi_break, holi_regular, holi_public
    }
    
    var id: Int { storeId }
}
