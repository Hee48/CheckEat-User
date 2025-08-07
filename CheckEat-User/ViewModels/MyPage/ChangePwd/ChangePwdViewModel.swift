//
//  ChangePwdViewModel.swift
//  CheckEat-User
//
//  Created by Hee  on 8/3/25.
//

import SwiftUI
import Combine
import Alamofire


class ChangePwdViewModel: ObservableObject {
    @Published var newPwd: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    func changePwd(onSuccess: @escaping () -> Void) {
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            print("억세스 토큰이 없음!!!!!")
            return
        }
        let parameters: [String: Any] = ["newPwd": newPwd]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        AF.request(MyPageAPI.pwChangeURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .publishDecodable(type: ChangePasswordResponse.self)
            .sink { completion in
                switch completion {
                case .finished:
                    print("비밀번호 변경 성공")
                case .failure(let error):
                    print("비밀번호 변경 실패:", error.localizedDescription)
                }
            } receiveValue: { response in
                if let value = response.value {
                    print("✅ 서버 응답 성공:")
                    print("message:", value.message)
                    print("status:", value.status)
                    if value.status.lowercased() == "success" {
                        onSuccess()
                    }
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
