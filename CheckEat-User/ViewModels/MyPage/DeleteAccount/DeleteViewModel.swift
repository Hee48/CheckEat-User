//
//  DeleteViewModel.swift
//  CheckEat-User
//
//  Created by Hee  on 7/31/25.
//

import Foundation
import Combine
import Alamofire

class DeleteViewModel: ObservableObject {
    
    func withdrawUser() -> AnyPublisher<Void, Error> {
        guard let token = TokenManager.shared.getAccessToken() else {
            return Fail(error: NSError(domain: "TokenError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Access token is missing."]))
                .eraseToAnyPublisher()
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        return AF.request(MyPageAPI.deleteAccountURL, method: .post, headers: headers)
            .validate()
            .publishData()
            .tryMap { response in
                if let error = response.error {
                    print("❌ 탈퇴 실패: \(error.localizedDescription)")
                    throw error
                } else {
                    print("✅ 탈퇴 요청 성공")
                }
            }
            .eraseToAnyPublisher()
    }
}

