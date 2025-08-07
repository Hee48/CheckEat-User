//
//  LanguageSettingsViewModel.swift
//  CheckEat-User
//
//  Created by Hee  on 8/8/25.
//

import SwiftUI
import Combine
import Alamofire

class LanguageSettingsViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    func languageSettings(language: String, completion: @escaping (Bool) -> Void) {
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            print("억세스 토큰이 없음!!!!!")
            return
        }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        let request = UpdateLanguageRequest(new_lang: language)
        
        AF.request(MyPageAPI.languageURL, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .publishDecodable(type: UpdateLanguageResponse.self)
            .sink { completionResult in
                switch completionResult {
                case .failure(let error):
                    print("에러 발생: \(error.localizedDescription)")
                    completion(false)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let data = response.value else {
                    print("데이터 파싱 실패 또는 응답 없음")
                    completion(false)
                    return
                }
                print("✅ 언어 업데이트 성공: \(data.message)")
                if data.status == "success" {
                    if !data.accessToken.isEmpty {
                        TokenManager.shared.saveAccessToken(accessToken: data.accessToken)
                    }
                    completion(true)
                } else {
                    completion(false)
                }
            }
            .store(in: &cancellables)
    }
}
