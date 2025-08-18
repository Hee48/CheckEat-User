//
//  ManageFavoriteService.swift
//  CheckEat-User
//
//  Created by 최준영 on 8/12/25.
//

import SwiftUI
import Combine
import Alamofire

private struct FavoriteToggleRequest: Encodable {
    let sto_id: String
}

class ManageFavoriteService: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    func toggleFavorite(storeId: Int, isCurrentlyFavorite: Bool) -> AnyPublisher<Bool, Error> {
        guard let accessToken = TokenManager.shared.getAccessToken(),
              !accessToken.isEmpty else {
            print("🚫 억세스 토큰이 없음!")
            return Fail(error: NetworkError.unauthorized)
                .eraseToAnyPublisher()
        }
        
        let endpoint = isCurrentlyFavorite
        ? FavoriteAPI.deleteFavoriteStore
        : FavoriteAPI.regiFavoriteStore
        
        let body = FavoriteToggleRequest(sto_id: String(storeId))
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        return AF.request(endpoint,
                          method: .post,
                          parameters: body,
                          encoder: JSONParameterEncoder.default,
                          headers: headers)
        .validate()
        .publishDecodable(type: FavoriteStore.self)
        .tryMap { response in
            if let value = response.value {
                print("✅ 즐겨찾기 응답 성공:", value)
                return value.status == "success"
            } else {
                if let data = response.data,
                   let rawString = String(data: data, encoding: .utf8) {
                    print("🧾 Raw JSON:", rawString)
                }
                throw NetworkError.invalidResponse
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchFavoriteStores() -> AnyPublisher<[Int], Error> {
        guard let accessToken = TokenManager.shared.getAccessToken(),
              !accessToken.isEmpty else {
            print("🚫 억세스 토큰이 없음! 빈 배열 반환")
            return Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        
        return AF.request(FavoriteAPI.favoriteStoreList,
                          method: .post,
                          headers: headers)
        .validate()
        .publishDecodable(type: FavoriteStoreListResponse.self)
        .tryMap { response in
            if let value = response.value {
                print("✅ 즐겨찾기 목록 가져오기 성공: \(value.stores.count)개")
                print("📋 가져온 가게들:")
                for store in value.stores {
                    print("  - ID: \(store.sto_id), 이름: \(store.sto_name)")
                }
                // store_id만 추출해서 반환
                return value.stores.map { $0.sto_id }
            } else {
                if let data = response.data,
                   let rawString = String(data: data, encoding: .utf8) {
                    print("🧾 Raw JSON:", rawString)
                }
                if let error = response.error {
                    print("❌ 디코딩 에러:", error.localizedDescription)
                }
                throw NetworkError.invalidResponse
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchFavoriteStoreItems() -> AnyPublisher<[FavoriteStoreItem], Error> {
        guard let accessToken = TokenManager.shared.getAccessToken(),
              !accessToken.isEmpty else {
            print("🚫 억세스 토큰이 없음! 빈 배열 반환")
            return Just([])
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]

        return AF.request(FavoriteAPI.favoriteStoreList,
                          method: .post,
                          headers: headers)
            .validate()
            .publishDecodable(type: FavoriteStoreListResponse.self)
            .tryMap { response in
                if let value = response.value {
                    print("✅ 즐겨찾기 전체 목록 가져오기 성공: \(value.stores.count)개")
                    return value.stores
                } else {
                    if let data = response.data,
                       let rawString = String(data: data, encoding: .utf8) {
                        print("🧾 Raw JSON:", rawString)
                    }
                    if let error = response.error {
                        print("❌ 디코딩 에러:", error.localizedDescription)
                    }
                    throw NetworkError.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
}

enum NetworkError: Error {
    case unauthorized
    case invalidResponse
    case serverError
}
