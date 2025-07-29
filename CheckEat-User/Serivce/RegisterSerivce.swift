//
//  RegisterSerivce.swift
//  CheckEat-User
//
//  Created by Hee  on 7/18/25.
//

import Foundation
import Combine
import Alamofire


class RegisterSerivce: ObservableObject {
    
    // 아이디 중복확인 API
    static func checkIDUnique(id: String) -> AnyPublisher<IDUniqueResponse, AFError> {
        let url =  API.checkIDUniqueURL
        let params: [String: String] = ["id": id]
        return AF.request(url,
                          method: .post,
                          parameters: params,
                          encoding: JSONEncoding.default)
        .validate()
        .publishDecodable(type: IDUniqueResponse.self)
        .value()
        .eraseToAnyPublisher()
    }
    
    //이메일 중복확인 API
    static func checkEmailUnique(email: String) -> AnyPublisher<EmailUniqueResponse, AFError> {
        let url = API.checkEmailUniqueURL
        let params = EmailUniqueRequest(email: email)
        return AF.request(url,
                          method: .post,
                          parameters: params,
                          encoder: JSONParameterEncoder.default)
        .validate()
        .publishDecodable(type: EmailUniqueResponse.self)
        .value()
        .eraseToAnyPublisher()
    }
    
    //이메일 인증 토큰 발송 API
    static func sendEmailToken(email: String, language: String = "ko") -> AnyPublisher<EmailUniqueResponse, AFError> {
        let url = API.sendEmailTokenURL
        let params = SendEmailTokenRequest(email: email, language: language)
        return AF.request(url,
                          method: .post,
                          parameters: params,
                          encoder: JSONParameterEncoder.default)
        .validate()
        .publishDecodable(type: EmailUniqueResponse.self)
        .value()
        .eraseToAnyPublisher()
    }
    
    //이메일 인증 토큰 확인 API
    static func checkEmailToken(email: String, token: String) -> AnyPublisher<CheckEmailTokenResponse, AFError> {
        let url = API.checkEmailTokenURL
        let params = CheckEmailTokenRequest(email: email, token: token)
        return AF.request(url,
                          method: .post,
                          parameters: params,
                          encoder: JSONParameterEncoder.default)
        .validate()
        .publishDecodable(type: CheckEmailTokenResponse.self)
        .value()
        .eraseToAnyPublisher()
    }
    
    //회원가입 API
    static func signUp(request: RegisterRequest) -> AnyPublisher<RegisterResponse, AFError> {
        let url = API.signUpURL
        return AF.request(url,
                          method: .post,
                          parameters: request,
                          encoder: JSONParameterEncoder.default)
        .publishDecodable(type: RegisterResponse.self)
        .value()
        .eraseToAnyPublisher()
    }
}
