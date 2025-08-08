//
//  EditAllergiesViewModel.swift
//  CheckEat-User
//
//  Created by Hee  on 8/8/25.
//

import Foundation
import Combine
import Alamofire

class EditAllergiesViewModel: ObservableObject {
    @Published var isSuccess = false
    private var cancellables = Set<AnyCancellable>()
    
    func editAllergies(commonIDs: [Int], personalAllergy: String) {
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            print("오류: 액세스 토큰이 존재하지 않습니다.")
            return
        }
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        let request = AllergyUpdateRequest(common_al: commonIDs, personal_al: personalAllergy)
        
        AF.request(MyPageAPI.allergyChangeURL, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers)
            .publishDecodable(type: AllergyUpdateResponse.self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("❌네트워크 요청 실패: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                if let token = response.value?.accessToken {
                    TokenManager.shared.saveAccessToken(accessToken: token)
                    self?.isSuccess = true
                    print("✅ 억세스 토큰 저장 성공")
                } else {
                    print("❌오류: 서버 응답이 유효하지 않거나 토큰이 없음.")
                }
            }
            .store(in: &cancellables)
    }
}
