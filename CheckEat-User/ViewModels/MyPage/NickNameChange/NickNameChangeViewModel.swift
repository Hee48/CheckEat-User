//
//  NickNameChangeViewModel.swift
//  CheckEat-User
//
//  Created by Hee  on 8/3/25.
//

import SwiftUI
import Combine
import Alamofire

class NickNameChangeViewModel: ObservableObject {
    @Published var newNickName: String = ""
    @Published var didUpdateNickname = false
    private var cancellables = Set<AnyCancellable>()
    
    func updateNickName() {
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            print("억세스 토큰이 없음!!!!!")
            return
        }
        let parameters: [String: Any] = ["nickname": newNickName]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        AF.request(MyPageAPI.nickChangeURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .publishDecodable(type: UpdateNickNameResponse.self)
            .sink { completion in
                switch completion {
                case .finished:
                    print("닉네임 변경 완료")
                case .failure(let error):
                    print("닉네임 변경 실패:", error.localizedDescription)
                }
            } receiveValue: { response in
                if let value = response.value {
                       print("✅ 서버 응답 성공:")
                       print("message:", value.message)
                       print("status:", value.status)
                   } else {
                       if let data = response.data,
                          let rawString = String(data: data, encoding: .utf8) {
                           print("🧾 Raw JSON:", rawString)
                       } else {
                           print("❌ response.value도 없고 data도 디코딩 안됨")
                       }
                   }
            }
            .store(in: &cancellables)
    }
}
