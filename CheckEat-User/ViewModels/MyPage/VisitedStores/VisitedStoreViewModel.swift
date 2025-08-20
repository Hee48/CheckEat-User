//
//  VisitedStoreViewModel.swift
//  CheckEat-User
//
//  Created by Hee  on 8/6/25.
//

import Foundation
import Combine
import Alamofire

class VisitedStoreViewModel: ObservableObject {
    @Published var myReviews: [MyReview] = []
    @Published var unreviewedStores: [UnwrittenStore] = []
    private var cancellables = Set<AnyCancellable>()
    
    //이용한 가게 - 리뷰작성 부분
    func fetchReviewedStores() {
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            print("억세스 토큰이 없음!!!!!")
            return
        }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        AF.request(MyPageAPI.retrieveReviewedStoresURL, method: .post, headers: headers)
            .validate()
            .publishDecodable(type: MyReviewsResponse.self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("에러 발생: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let data = response.value else {
                    print("데이터 파싱 실패 또는 응답 없음")
                    return
                }
                self?.myReviews = data.reviews
                print("✅ 리뷰 데이터 불러오기 성공: \(data.reviews.count)개")
            }
            .store(in: &cancellables)
    }
    //이용한 가게 - 리뷰 미작성 부분
    func pendingReviewStores() {
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            print("억세스 토큰이 없음!!!!!")
            return
        }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        AF.request(MyPageAPI.unreviewedStoresURL, method: .post, headers: headers)
            .validate()
            .responseString { response in
                print("📡 Raw response body:", response.value ?? "nil")
            }
            .publishDecodable(type: UnwrittenReviewsResponse.self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("에러 발생: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let data = response.value else {
                    print("데이터 파싱 실패 또는 응답 없음")
                    return
                }
                self?.unreviewedStores = data.stores
                print("✅ 리뷰 안쓴 데이터 불러오기 성공: \(data.stores.count)개")
            }
            .store(in: &cancellables)
    }
}
