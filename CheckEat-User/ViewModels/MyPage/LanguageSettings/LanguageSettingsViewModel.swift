//
//  LanguageSettingsViewModel.swift
//  CheckEat-User
//
//  Created by Hee  on 8/8/25.
//

import SwiftUI
import Combine
import Alamofire

class LanguageSettingsViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    // 현재 언어 가져오기 (우선순위 적용)
    static func getCurrentLanguage() -> String {
        if let saved = UserDefaults.standard.string(forKey: "app_selected_language") {
//            print("📱 저장된 앱 언어 사용: \(saved)")
            return saved // 앱에서 설정한 언어
        }
        
        let deviceLang = getDeviceLanguage()
        print("🔧 기기 언어 사용: \(deviceLang)")
        return deviceLang // 기기 언어
    }
    
    // 기기 언어 감지
    private static func getDeviceLanguage() -> String {
        let preferredLanguage = Locale.preferredLanguages.first ?? "en"
        let languageCode = String(preferredLanguage.prefix(2))
        
        print("🌍 기기 기본 언어: \(preferredLanguage) -> 코드: \(languageCode)")
        
        // 지원하는 언어만 반환 (한국어, 영어, 아랍어)
        switch languageCode {
        case "ko":
            return "ko" // 한국어
        case "en":
            return "en" // 영어
        case "ar":
            return "ar" // 아랍어
        default:
            print("⚠️ 지원하지 않는 언어(\(languageCode)) - 영어로 대체")
            return "en" // 지원하지 않는 언어는 영어로
        }
    }
    
    // 언어 코드를 화면 표시용 텍스트로 변환
    static func getLanguageDisplayName(_ code: String) -> String {
        switch code {
        case "ko": return "한국어"
        case "en": return "English"
        case "ar": return "عربي"
        default: return "English"
        }
    }
    
    // 화면 표시 텍스트를 언어 코드로 변환
    static func getLanguageCode(from displayName: String) -> String {
        switch displayName {
        case "한국어": return "ko"
        case "English": return "en"
        case "عربي": return "ar"
        default: return "en"
        }
    }
    
    func languageSettings(language: String, completion: @escaping (Bool) -> Void) {
        
        // UserDefaults에 저장 (로컬 저장이 우선)
        UserDefaults.standard.set(language, forKey: "app_selected_language")
        print("💾 언어 설정 로컬 저장: \(language)")
        
        // 다른 뷰들에게 언어 변경 알림
        NotificationCenter.default.post(
            name: NSNotification.Name("LanguageChanged"),
            object: language
        )
        
        guard let accessToken = TokenManager.shared.getAccessToken() else {
            print("⚠️ 억세스 토큰이 없음 - 로컬에만 저장됨")
            completion(true) // 로컬 저장은 성공했으므로 true
            return
        }
        
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        let request = UpdateLanguageRequest(new_lang: language)
        
        AF.request(MyPageAPI.languageURL, method: .post, parameters: request, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .publishDecodable(type: UpdateLanguageResponse.self)
            .sink { completionResult in
                switch completionResult {
                case .failure(let error):
                    print("❌ 서버 언어 설정 실패: \(error.localizedDescription)")
                    print("💡 하지만 로컬에는 저장되었음")
                    completion(true) // 로컬 저장은 성공했으므로 true
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let data = response.value else {
                    print("❌ 데이터 파싱 실패 또는 응답 없음")
                    completion(true) // 로컬 저장은 성공했으므로 true
                    return
                }
                
                print("✅ 서버 언어 업데이트 성공: \(data.message)")
                
                if data.status == "success" {
                    if !data.accessToken.isEmpty {
                        TokenManager.shared.saveAccessToken(accessToken: data.accessToken)
                    }
                    completion(true)
                } else {
                    print("⚠️ 서버 응답 실패하지만 로컬에는 저장됨")
                    completion(true) // 로컬 저장은 성공했으므로 true
                }
            }
            .store(in: &cancellables)
    }
}
