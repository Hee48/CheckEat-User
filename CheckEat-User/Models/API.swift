//
//  Untitled.swift
//  CheckEat-User
//
//  Created by Hee  on 7/18/25.

import Foundation

enum API {
    //베이스 URL
    static let endPoint = "http://localhost:3000/"
    //로그인 URL
    static let loginURL = endPoint + "auth/login"
    //아이디중복 URL
    static let checkIDUniqueURL = endPoint + "auth/check-id-unique"
    //이메일중복 URL
    static let checkEmailUniqueURL = endPoint + "auth/check-email-unique"
    //이메일토큰발송 URL
    static let sendEmailTokenURL = endPoint + "auth/send-email-token"
    //이메일토큰검증 URL
    static let checkEmailTokenURL = endPoint + "auth/check-email-token"
    //회원가입 URL
    static let signUpURL = endPoint + "auth/signup/user"
    //아이디찾기 토큰발송 URL
    static let FindIdURL = endPoint + "auth/find-id-sendtoken"
    //아이디찾기 토큰검증 URL
    static let FindIdTokenURL = endPoint + "auth/find-id-verify-token"
}
