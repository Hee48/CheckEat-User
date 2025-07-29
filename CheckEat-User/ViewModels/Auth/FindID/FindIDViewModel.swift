//
//  FindIDViewModel.swift
//  CheckEat-User
//
//  Created by Hee  on 7/17/25.
//

import Foundation
import Alamofire
import Combine

class FindIDViewModel: ObservableObject {
    
    @Published var findIdTokenSuccess: Bool? = nil
    @Published var foundUserId: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func findId(email: String, language: String) {
        let findIdData = FindIdTokenRequest(email: email, language: "ko")
        
        AF.request(API.FindIdURL, method: .post, parameters: findIdData, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    print("아이디 찾기 토큰 발송 성공 ✅")
                case .failure(let error):
                    print("아이디 찾기 실패 ❌❌❌ \(error.localizedDescription)")
                }
            }
    }
    
    func checkFindId(email: String, token: String) {
        let checkTokenData = CheckIdTokenRequest(email: email, token: token)
 
        AF.request(API.FindIdTokenURL, method: .post, parameters: checkTokenData, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: CheckIdTokenResponse.self)
            .value()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("토큰 확인 실패 ❌❌❌ \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { data in
                print("아이디 찾기 토큰 인증성공 ✅")
                self.findIdTokenSuccess = true
                self.foundUserId = data.log_id.ld_log_id
            }
            .store(in: &cancellables)
    }

}
