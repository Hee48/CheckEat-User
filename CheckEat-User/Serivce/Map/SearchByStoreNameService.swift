//
//  SearchByStoreNameService.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/10/25.
//

import Foundation
import Alamofire

class SearchByStoreNameService {
    
    func searchByStoreName(storeName: String, latitude: String, longitude: String, language: String, radius: String) async throws -> [Stores] {
        
        let params: [String: String] = [
            "sto_name": storeName,
            "user_la": latitude,
            "user_long": longitude,
            "lang": language,
            "radius": radius
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(MainAPI.mapByStoreName,
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [Stores].self) { response in
                switch response.result {
                case .success(let stores):
                    print("✅ 가게명으로 검색한 가게 목록 가져오기 성공")
                    continuation.resume(returning: stores)
                case .failure(let error):
                    print("🚨 가게명으로 검색한 가게 목록 가져오기 실패 \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
