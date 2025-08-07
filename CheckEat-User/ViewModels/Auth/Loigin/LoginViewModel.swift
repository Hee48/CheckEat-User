//
//  LoginViewModel.swift
//  CheckEat-User
//
//  Created by Hee  on 7/17/25.
//

import Foundation
import Alamofire
import Combine

class LoginViewModel: ObservableObject {

    @Published var loginId: String = ""
    @Published var password: String = ""
    @Published var loginSuccess = false
    @Published var alertMessage: String = ""

    private var cancellables = Set<AnyCancellable>()

    func login() {
        let loginData = LoginRequest(ld_log_id: loginId, ld_pwd: password)

        AF.request(AuthAPI.loginURL, method: .post, parameters: loginData, encoder: JSONParameterEncoder.default)
            .publishDecodable(type: LoginResponse.self)
            .value()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.loginSuccess = false
                    self.alertMessage = "입력하신 정보가 일치하지 않습니다. 다시 확인해주세요"
                    print("로그인실패 ❌❌❌ \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { data in
                self.loginSuccess = true
                AuthViewModel.shared.isLoggedIn = true
                print("로그인성공 \(data)")
                let access = data.accessToken
                let refresh = data.refreshToken
                TokenManager.shared.save(accessToken: access, refreshToken: refresh)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                       self.loginSuccess = false
                   }
            }
            .store(in: &cancellables)
    }
    func reset() {
        loginId = ""
        password = ""
        loginSuccess = false
        alertMessage = ""
    }
}
