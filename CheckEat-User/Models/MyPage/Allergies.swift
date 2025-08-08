//
//  Allergies.swift
//  CheckEat-User
//
//  Created by Hee  on 8/8/25.
//

//사용자 알레르기 모델 - 토큰에서 꺼내기
struct UserAllergy: Codable {
    let directAllergy: String
    let commonAllergies: [CommonAllergy]
}

struct CommonAllergy: Codable, Identifiable {
    let coal_id: Int
    let coal_name: String

    var id: Int { coal_id }
}

//마이페이지 - 알레르기 수정 요청
struct AllergyUpdateRequest: Encodable {
    let common_al: [Int]
    let personal_al: String
}

struct AllergyUpdateResponse: Decodable {
    let accessToken: String
}
