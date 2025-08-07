//
//  Untitled.swift
//  CheckEat-User
//
//  Created by Hee  on 7/18/25.

import Foundation

//베이스 URL
let endPoint = "http://192.168.219.102:3000/"


//192.168.100.141 강의실
enum AuthAPI {
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
    static let findIdURL = endPoint + "auth/find-id-sendtoken"
    //아이디찾기 토큰검증 URL
    static let findIdTokenURL = endPoint + "auth/find-id-verify-token"
    //비밀번호 찾기 토큰발송 URL
    static let findPwURL = endPoint + "auth/change-pwd-send-token"
    //비밀번호 찾기 토큰검증 URL
    static let findPwTokenURL = endPoint + "auth/find-pwd-verify-token"
    //비밀번호 찾기 - 비번밀번호변경 URL
    static let findEditPwURL = endPoint + "auth/find-pwd"
}

enum MyPageAPI {
    //회원탈퇴 URL
    static let deleteAccountURL = endPoint + "auth/delete-account"
    //닉임변경 URL
    static let nickChangeURL = endPoint + "user/nick-change"
    //비밀번호 변경 URL
    static let pwChangeURL = endPoint + "auth/change-pwd"
    //이용한가게 - 리뷰작성
    static let retrieveReviewedStoresURL = endPoint + "user/my-reviews"
    //이용한가게 - 리뷰미작성
    static let unreviewedStoresURL = endPoint + "user/my-pending-reviews"
    //언어변경
    static let languageURL = endPoint + "user/update-lang"
}

enum OCRAPI {
    //OCRAzure URL
    static let ocrURL = endPoint + "azure-document-ocr/receipt"
}

enum ReviewAPI {
    //우리어플에 등록된 가게인지 확인 URL
    static let reviewCanWriteURL = endPoint + "review/can-write"
    //리뷰 다음에등록시에 나중에쓰기 등록URL
    static let registLaterURL = endPoint + "review/regist-later"
    //리뷰작성시 필요한 가게 음식데이터URL
    static let registPageURL = endPoint + "review/regist-page"
    //리뷰등록 URL
    static let registerReview = endPoint + "review/register"
}

