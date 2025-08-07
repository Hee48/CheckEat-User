//
//  MyPageViewModel.swift
//  CheckEat-User
//
//  Created by Hee  on 8/6/25.
//

import JWTDecode
import Combine

class MyPageViewModel: ObservableObject {
    @Published var userInfo: UserInfo?
    
    func loadUserInfoFromToken() {
        guard let token = TokenManager.shared.getAccessToken() else { return }
        do {
            let jwt = try decode(jwt: token)
            let email = jwt.claim(name: "email").string ?? ""
            let nickName = jwt.claim(name: "user_nick").string ?? ""
            self.userInfo = UserInfo(email: email, nickName: nickName)
        } catch {
            print("❌ JWT 디코딩 실패: \(error)")
        }
    }
}
