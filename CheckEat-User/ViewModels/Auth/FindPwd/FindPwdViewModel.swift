//
//  FindPwdViewModel.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/5/25.
//

import Foundation
import Combine
import Alamofire

class FindPwdViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var logId: String = ""
    @Published var token: String = ""
    @Published var newPassword: String = ""
    @Published var alertMessage: String = ""
    
    @Published var languageCode: String = Locale.preferredLanguages.first?.components(separatedBy: "-").first ?? "ko"
    private var cancellables = Set<AnyCancellable>()
    
    //이메일 인증 토큰 발송
    func sendEmailToken(email: String, logId: String) {
        let request = FindPwTokenRequest(email: email, log_id: logId, language: languageCode)
        
        AF.request(AuthAPI.findPwURL, method: .post, parameters: request, encoder: JSONParameterEncoder.default)
            .validate()
            .publishDecodable(type: FindPwTokenResponse.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("이메일 인증토큰 발송 완료 ✅")
                case .failure(let error):
                    print("이메일 인증토큰 발송 실패 ❌❌❌ \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                if let value = response.value {
                    if value.status?.lowercased() == "success" {
                        print("이메일 발송 성공 ✅")
                    } else {
                        print("이메일 발송 실패: \(value.message ?? "????")")
                    }
                } else {
                    if let data = response.data,
                       let rawString = String(data: data, encoding: .utf8) {
                        print("🧾 Raw JSON:", rawString)
                    } else {
                        print("❌ 응답 디코딩 실패: 데이터 없음")
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    //이메일 인증 토큰 확인
    func verifyEmailToken(email: String, token: String, completion: @escaping (Bool) -> Void) {
        let request = CheckPwTokenRequest(email: email, token: token)
        
        AF.request(AuthAPI.findPwTokenURL, method: .post, parameters: request, encoder: JSONParameterEncoder.default)
            .validate()
            .publishDecodable(type: CheckPwTokenResponse.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("✅ 인증 토큰 확인 완료")
                case .failure(let error):
                    print("❌ 인증 토큰 확인 실패: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                if let value = response.value {
                    if value.status.lowercased() == "success" {
                        print("✅ 토큰 일치")
                        completion(true)
                    } else {
                        print("❌ 인증 실패: \(value.message)")
                        completion(false)
                    }
                } else {
                    print("❌ 응답 디코딩 실패")
                    completion(false)
                    self?.alertMessage = "잘못된 인증코드입니다. 다시 시도해주세요."
                }
            }
            .store(in: &cancellables)
    }
    //비밀번호 변경 함수
    func changePassword(email: String, newPassword: String, completion: @escaping (Bool) -> Void) {
        let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let request = FindPwChangeRequest(ld_email: cleanEmail, new_pwd: newPassword)
        
        AF.request(AuthAPI.findEditPwURL, method: .post, parameters: request, encoder: JSONParameterEncoder.default)
            .validate()
            .publishDecodable(type: FindPwChangeResponse.self)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("✅ 비밀번호 변경 요청 완료")
                case .failure(let error):
                    print("❌ 비밀번호 변경 실패: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] response in
                if let value = response.value {
                    if value.status.lowercased() == "success" {
                        print("✅ 비밀번호 변경 성공")
                        completion(true)
                    } else {
                        print("❌ 비밀번호 변경 실패: \(value.message)")
                        completion(false)
                    }
                } else {
                    if let data = response.data,
                       let rawString = String(data: data, encoding: .utf8) {
                        print("🧾 Raw JSON:", rawString)
                    } else {
                        print("❌ 응답 디코딩 실패: 데이터 없음")
                    }
                    completion(false)
                }
            }
            .store(in: &cancellables)
    }
}
