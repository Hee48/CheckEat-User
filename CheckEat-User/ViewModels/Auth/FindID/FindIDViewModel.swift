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
    
    @Published var findIdTokenSuccess: Bool = false
    @Published var foundUserId: String = ""
    @Published var languageCode: String = Locale.preferredLanguages.first?.components(separatedBy: "-").first ?? "ko"
    
    private var cancellables = Set<AnyCancellable>()
    
    func findId(email: String, language: String? = nil) {
        let lang = language ?? languageCode
        let findIdData = FindIdTokenRequest(email: email, language: lang)
        
        AF.request(AuthAPI.findIdURL, method: .post, parameters: findIdData, encoder: JSONParameterEncoder.default)
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
    
    func checkFindId(email: String, token: String, completion: @escaping (Bool) -> Void) {
        let checkTokenData = CheckIdTokenRequest(email: email, token: token)

        AF.request(AuthAPI.findIdTokenURL, method: .post, parameters: checkTokenData, encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CheckIdTokenResponse.self) { response in
                switch response.result {
                case .success(let data):
                    print("아이디 찾기 토큰 인증성공 ✅")
                    self.findIdTokenSuccess = true
                    self.foundUserId = data.log_id.ld_log_id
                    completion(true)
                case .failure(let error):
                    print("토큰 확인 실패 ❌❌❌ \(error.localizedDescription)")
                    self.findIdTokenSuccess = false
                    completion(false)
                }
            }
    }

}
