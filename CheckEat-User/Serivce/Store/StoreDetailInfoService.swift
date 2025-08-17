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
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(MainAPI.storeDetailInfo,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default)
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
