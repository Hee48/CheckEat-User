//
//  NickName.swift
//  CheckEat-User
//
//  Created by Hee  on 8/3/25.
//

import Foundation

struct UpdateNickNameRequest: Codable {
    let nickname: String
}

struct UpdateNickNameResponse: Decodable {
    let message: String
    let status: String
    let accessToken: String
}


