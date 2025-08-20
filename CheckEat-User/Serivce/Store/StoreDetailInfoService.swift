//
//  StoreDetailInfoService.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/11/25.
//

import Foundation
import Alamofire

//MARK: 요청 객체 인코딩
private struct StoreDetailRequest: Encodable {
    let sto_id: Int
    let user_lang: String
}

class StoreDetailInfoService {
    func loadStoreDetailInfo(storeId: Int, language: String) async throws -> StoreDetailInfo {
        let params = StoreDetailRequest(sto_id: storeId, user_lang: language)

        // 회원 여부에 따른 헤더 구성 (TokenManager 유지)
        var headers: HTTPHeaders = ["Content-Type": "application/json"]
        if let accessToken = TokenManager.shared.getAccessToken(), !accessToken.isEmpty {
            headers.add(name: "Authorization", value: "Bearer \(accessToken)")
        } else {
            print("ℹ️ 토큰 없음 → 비회원 헤더로 요청")
        }

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                MainAPI.storeDetailInfo,
                method: .post,
                parameters: params,
                encoder: JSONParameterEncoder.default,
                headers: headers
            )
            .validate(statusCode: 200..<300)
            .responseDecodable(of: StoreDetailInfo.self) { response in
                switch response.result {
                case .success(let storeInfo):
                    print("✅ 상세 정보 가져오기 성공")
                    continuation.resume(returning: storeInfo)
                case .failure(let error):
                    print("🚨 상세 정보 가져오기 실패 \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
