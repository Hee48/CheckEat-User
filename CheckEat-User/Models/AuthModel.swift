//
//  LoginModels.swift
//  CheckEat-User
//
//  Created by Hee  on 7/17/25.
//

import Foundation

//로그인 요청
struct LoginRequest: Codable {
    var ld_log_id: String
    var ld_pwd: String
}
//로그인 응답
struct LoginResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
//회원가입 요청
struct RegisterRequest: Codable {
    let log_Id: String
    let log_pwd: String
    let email: String
    let allergy: String?
    let nickname: String
    let commonAllergies: [Int]?
    let vegan: Int?
    let isHalal: Int?
}
//회원가입 응답
struct RegisterResponse: Decodable {
    let message: String
    let userId: String?
    let status: Int
}
//아이디찾기 토큰 요청
struct FindIdTokenRequest: Codable {
    let email: String
    let language: String
}
//아이디찾기 토큰확인 요청
struct CheckIdTokenRequest: Codable {
    let email: String
    let token: String
}
//아이디찾기 토큰확인 응답
struct CheckIdTokenResponse: Decodable {
    let message: String
    let status: String
    let log_id: LogID
}
struct LogID: Decodable {
    let ld_log_id: String
}
//아이디중복 응답
struct IDUniqueResponse: Decodable {
    let message: String
    let status: Int
}
//이메일중복확인 요청
struct EmailUniqueRequest: Codable {
    let email: String
}
//이메일중복확인 응답
struct EmailUniqueResponse: Decodable {
    let message: String
    let status: Int
}
//이메일인증 토큰발송 요청
struct SendEmailTokenRequest: Codable {
    let email: String
    let language: String
}
//이메일인증 토큰확인 요청
struct CheckEmailTokenRequest: Codable {
    let email: String
    let token: String
}
//이메일인증 토큰확인 응답
struct CheckEmailTokenResponse: Decodable {
    let message: String
    let status: String
}
//비건 단계
enum VeganLevel: Int, CaseIterable {
    case none = 0
    case level1 = 1
    case level2 = 2
    case level3 = 3
    case level4 = 4
    case level5 = 5
    case level6 = 6
    
    var description: String {
        switch self {
        case .none:
            return "비건 아님"
        case .level1:
            return "폴로 베지테리언"
        case .level2:
            return "페스코 베지테리언"
        case .level3:
            return "락토 오보 베지테리언"
        case .level4:
            return "오보 베지테리언"
        case .level5:
            return "락토 베지테리언"
        case .level6:
            return "비건 베지테리언"
        }
    }
}
//할랄 여부
enum HalaStatus: Int, CaseIterable {
    case no = 0
    case yes = 1
    
    var description: String {
        switch self {
        case .no:
            return "할랄 아님"
        case .yes:
            return "할랄"
        }
    }
}
