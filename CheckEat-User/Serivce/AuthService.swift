//
//  AuthService.swift
//  CheckEat-User
//
//  Created by Hee  on 8/10/25.
//

import Alamofire
import Combine
import Foundation

final class AuthService {
    enum RefreshError: Error { case missingRefreshToken, missingLogId }

    static let shared = AuthService()
    private init() {}

    func refreshPublisher() -> AnyPublisher<RefreshResponse, Error> {
        guard let logId = UserDefaults.standard.string(forKey: "logId"), !logId.isEmpty else {
            return Fail(error: RefreshError.missingLogId).eraseToAnyPublisher()
        }
        guard let rt = TokenManager.shared.getRefreshToken() else {
            return Fail(error: RefreshError.missingRefreshToken).eraseToAnyPublisher()
        }

        let body = RefreshRequest(log_Id: logId, refreshToken: rt)
        return AF.request(AuthAPI.refreshURL,
                          method: .post,
                          parameters: body,
                          encoder: JSONParameterEncoder.default)
            .publishDecodable(type: RefreshResponse.self)
            .value()
            .handleEvents(receiveOutput: { res in
                TokenManager.shared.save(accessToken: res.accessToken, refreshToken: res.refreshToken)
                AuthViewModel.shared.checkToken()
                print("🔁 refresh ok in service: \(res)")
            })
            .mapError { error in
                print("🔁 Refresh failed:", error.localizedDescription)
                return error
            }
            .eraseToAnyPublisher()
    }
}
