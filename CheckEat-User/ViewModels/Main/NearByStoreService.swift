//
//  NearByStoreService.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/9/25.
//

import Foundation
import Alamofire

class NearByStoreService {
    
    func fetchNearByStores(latitude: String, longitude: String, radius: String) async throws -> [Stores] {
        
        let params: [String: String] = [
            "user_la": latitude,
            "user_long": longitude,
            "radius": radius
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(MainAPI.mapFromUserLocation,
                      method: .post,
                      parameters: params,
                      encoder: JSONParameterEncoder.default)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: [Stores].self) { response in
                    switch response.result {
                    case .success(let stores):
                        print("✅ 사용자 반경 가게 목록 가져오기 성공")
                        continuation.resume(returning: stores)
                    case .failure(let error):
                        print("🚨 사용자 반경 가게 목록 가져오기 실패 \(error.localizedDescription)")
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
