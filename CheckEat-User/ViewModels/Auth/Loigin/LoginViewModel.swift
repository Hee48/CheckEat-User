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
        self.alertMessage = ""
        let loginData = LoginRequest(ld_log_id: loginId, ld_pwd: password)

        AF.request(AuthAPI.loginURL, method: .post, parameters: loginData, encoder: JSONParameterEncoder.default)
            .responseString { resp in
                let code = resp.response?.statusCode ?? -1
                print("🗒️ RAW(\(code)):", resp.value ?? "<no body>")

                guard !(200...299).contains(code) else { return }
                
                // 서버 메시지 파싱
                if let data = resp.data,
                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let message = json["message"] as? String {
                    if message == "account_deleted" {
                        self.alertMessage = message
                    } else {
                        self.alertMessage = "input_not_match_check_again"
                    }
                } else {
                    self.alertMessage = "input_not_match_check_again"
                }
            }
            .publishDecodable(type: LoginResponse.self)
            .value()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.loginSuccess = false
                    print("로그인실패 ❌❌❌ \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { data in
                self.loginSuccess = true
                print("로그인성공 \(data)")
                let access = data.accessToken
                let refresh = data.refreshToken
                TokenManager.shared.save(accessToken: access, refreshToken: refresh)
                UserDefaults.standard.set(self.loginId, forKey: "logId")
                self.alertMessage = ""
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
