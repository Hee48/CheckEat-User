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

    private var cancellables = Set<AnyCancellable>()

    func login() {
        let loginData = LoginRequest(ld_log_id: loginId, ld_pwd: password)

        AF.request(API.loginURL, method: .post, parameters: loginData, encoder: JSONParameterEncoder.default)
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
            }
            .store(in: &cancellables)
    }
}
