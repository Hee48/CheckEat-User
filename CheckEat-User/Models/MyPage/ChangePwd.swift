//
//  ChangePwd.swift
//  CheckEat-User
//
//  Created by Hee  on 8/3/25.
//

// 비밀번호변경 요청
struct ChangePasswordRequest: Encodable {
    let newPwd: String
}

// 비밀번호변경 응답
struct ChangePasswordResponse: Decodable {
    let message: String
    let status: String
}
