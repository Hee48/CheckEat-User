//
//  TokenManager.swift
//  CheckEat-User
//
//  Created by Hee  on 7/31/25.
//

import Foundation

enum TokenKey: String {
    case accessToken
    case refreshToken
}

final class TokenManager {
    static let shared = TokenManager()

    private init() {}

    func save(accessToken: String, refreshToken: String) {
        UserDefaults.standard.set(accessToken, forKey: TokenKey.accessToken.rawValue)
        UserDefaults.standard.set(refreshToken, forKey: TokenKey.refreshToken.rawValue)
    }

    func getAccessToken() -> String? {
        UserDefaults.standard.string(forKey: TokenKey.accessToken.rawValue)
    }

    func getRefreshToken() -> String? {
        UserDefaults.standard.string(forKey: TokenKey.refreshToken.rawValue)
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: TokenKey.accessToken.rawValue)
        UserDefaults.standard.removeObject(forKey: TokenKey.refreshToken.rawValue)
    }
    
    func saveAccessToken(accessToken: String) {
        UserDefaults.standard.set(accessToken, forKey: TokenKey.accessToken.rawValue)
    }
}
