//
//  AuthViewModel.swift
//  CheckEat-User
//
//  Created by Hee  on 8/5/25.
//  

import Foundation

//로그인 상태 뷰모델
class AuthViewModel: ObservableObject {
    static let shared = AuthViewModel()
    
    @Published var isLoggedIn: Bool = false
    @Published var shouldShowLogin: Bool = false
    
    private init() {
        checkToken()
    }
    
    func checkToken() {
        if let token = TokenManager.shared.getAccessToken(), !token.isEmpty {
            isLoggedIn = true
        } else {
            isLoggedIn = false
        }
    }
    
    func logout() {
        TokenManager.shared.clear()
        isLoggedIn = false
        UserDefaults.standard.removeObject(forKey: "favorite_store_ids")
    }
}
