//
//  Language.swift
//  CheckEat-User
//
//  Created by Hee  on 8/8/25.
//

import Foundation

struct UpdateLanguageRequest: Encodable {
    let new_lang: String
}
struct UpdateLanguageResponse: Decodable {
    let message: String
    let status: String
    let accessToken: String
}
