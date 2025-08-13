//
//  ReviewViewModel.swift
//  CheckEat-User
//
//  Created by Hee  on 8/5/25.
//

import Foundation
import Combine
import Alamofire
import UIKit

class ReviewViewModel: ObservableObject {
    @Published var storeName: String = ""
    @Published var storeAddress: String = ""
    @Published var canWrite: Bool = false
    @Published var storeId: Int?
    @Published var isStoreNotFound: Bool = false
    @Published var menuList: [StoreMenuItem] = []
    @Published var registerSuccess: Bool = false
    
    
    private var cancellables = Set<AnyCancellable>()
    
    //가게 확인 - 리뷰등록가능한지 가게이름, 가게주소로 검증 -> storeID를 보내줌
    func checkCanWriteReview(storeName: String, storeAddress: String) {
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            print("억세스 토큰이 없음!!!!!")
            return
        }
        let request = CanWriteReviewRequest(sto_name: storeName, sto_address: storeAddress)
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        AF.request(ReviewAPI.reviewCanWriteURL, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .publishDecodable(type: CanWriteReviewResponse.self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("❌ 가게 확인 실패: \(error.localizedDescription)")
                    self.canWrite = false
                case .finished:
                    break
                }
            } receiveValue: { response in
                if let value = response.value {
                    if value.status.lowercased() == "success" {
                        print("✅ 가게 확인 성공: \(value.message)")
                        self.storeId = value.sto_id
                        print("🆔 받은 storeId: \(value.sto_id)")
                        self.canWrite = true
                    } else {
                        print("❌ 가게 확인 실패: \(value.message)")
                        self.canWrite = false
                        self.isStoreNotFound = true
                    }
                } else {
                    self.canWrite = false
                }
            }
            .store(in: &cancellables)
    }
    //storeID기준으로 리뷰 나중에 등록하는 기능
    func registLaterReview(storeId: Int) {
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            print("억세스 토큰이 없음!!!!!")
            return
        }
        print("📤 등록 요청할 storeId: \(storeId)")
        
        let request = RegisterLaterRequest(sto_id: storeId)
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        AF.request(ReviewAPI.registLaterURL, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: RegisterLaterResponse.self) { response in
                switch response.result {
                case .success(let value):
                    print("✅ 리뷰 나중에 등록 요청 성공: \(value.message), 리뷰 ID: \(value.review_id)")
                case .failure(let error):
                    print("❌ 리뷰 나중에 등록 요청 실패: \(error.localizedDescription)")
                }
            }
    }
    //리뷰등록에 내가먹은 가게 메뉴 불러오는 함수
    func registPageStroeMenu(storeId: Int) {
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            print("억세스 토큰이 없음!!!!!")
            return
        }
        let request = RegisterMenuPageRequest(sto_id: storeId)
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        AF.request(ReviewAPI.registPageURL, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: RegisterMenuPageResponse.self) { response in
                switch response.result {
                case .success(let value):
                    print("✅ 메뉴 등록 성공: \(value.count)개 메뉴 수신됨")
                    self.menuList = value
                case .failure(let error):
                    print("❌ 메뉴 등록 실패: \(error.localizedDescription)")
                }
            }
        
    }
    //리뷰등록 함수
    func registerReview(foodIDs: [Int], storeID: Int, reviewContent: String, veganLevel: Int, recommendStep: Int, status: Int,  images: [UIImage] = []) {
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            print("억세스 토큰이 없음!!!!!")
            return
        }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        print("📸 업로드할 이미지 개수: \(images.count)")
        AF.upload(multipartFormData: { multipartFormData in
            for id in foodIDs {
                multipartFormData.append(Data("\(id)".utf8), withName: "food_ids")
            }
            multipartFormData.append(Data("\(storeID)".utf8), withName: "store_id")
            multipartFormData.append(Data(reviewContent.utf8), withName: "revi_content")
            multipartFormData.append(Data("\(veganLevel)".utf8), withName: "revi_reco_vegan")
            multipartFormData.append(Data("\(recommendStep)".utf8), withName: "revi_reco_step")
            multipartFormData.append(Data("\(status)".utf8), withName: "revi_status")
            
            for (index, image) in images.prefix(4).enumerated() {
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    multipartFormData.append(
                        imageData,
                        withName: "images",
                        fileName: "image\(index).jpg",
                        mimeType: "image/jpeg"
                    )
                }
            }
        }, to: ReviewAPI.registerReviewURL, method: .post, headers: headers)
        .validate()
        .responseDecodable(of: RegisterReviewResponse.self) { response in
            switch response.result {
            case .success(let data):
                print("✅ 리뷰 등록 성공: \(data)")
                self.registerSuccess = true
            case .failure(let error):
                print("❌ 리뷰 등록 실패: \(error.localizedDescription)")
                if let data = response.data {
                    print("에러 응답 데이터: \(String(data: data, encoding: .utf8) ?? "인코딩 실패")")
                }
                
                if let statusCode = response.response?.statusCode {
                    print("상태 코드: \(statusCode)")
                }
            }
        }
    }    
}
