//
//  MyPageViewModel.swift
//  CheckEat-User
//
//  Created by Hee  on 8/6/25.
//
import Foundation
import JWTDecode
import Combine

class MyPageViewModel: ObservableObject {
    
    @Published var userInfo: UserInfo?
    @Published var parsedAllergyIDs: [Int] = []
    @Published var parsedCustomAllergy: String = ""
    
    //토큰에서 마이페이지 닉네임,이메일 추출
    func loadUserInfoFromToken() {
        guard let token = TokenManager.shared.getAccessToken() else { return }
        do {
            let jwt = try decode(jwt: token)
            let email = jwt.claim(name: "email").string ?? ""
            let nickName = jwt.claim(name: "user_nick").string ?? ""
            self.userInfo = UserInfo(email: email, nickName: nickName)
        } catch {
            print("❌ JWT 디코딩 실패: \(error)")
        }
    }
    //토큰에서 마이페이지 알러지수정정보 추출 
    func loadAllergiesFromToken() -> UserAllergy? {
        guard let token = TokenManager.shared.getAccessToken() else { return nil }

        do {
            let jwt = try decode(jwt: token)
            let payload = jwt.body
            
            // 공통 알러지 파싱
            var commonAllergies: [CommonAllergy] = []
            var idList: [Int] = []

            if let commonArray = payload["user_allergy_common"] as? [[String: Any]] {
                for item in commonArray {
                    if let id = item["coal_id"] as? Int,
                       let name = item["coal_name"] as? String {
                        let allergy = CommonAllergy(coal_id: id, coal_name: name)
                        commonAllergies.append(allergy)
                        idList.append(id)
                    }
                }
            } else {
                print("❌ user_allergy_common 파싱 실패 또는 없음")
            }

            let directAllergy = payload["user_allergy"] as? String ?? ""

            DispatchQueue.main.async {
                self.parsedAllergyIDs = idList
                self.parsedCustomAllergy = directAllergy
            }

            return UserAllergy(directAllergy: directAllergy, commonAllergies: commonAllergies)

        } catch {
            print("❌ JWT 디코딩 실패: \(error)")
            return nil
        }
    }

}
