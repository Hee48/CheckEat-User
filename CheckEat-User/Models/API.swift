//
//  Untitled.swift
//  CheckEat-User
//
//  Created by Hee  on 7/18/25.

import Foundation

enum API {
    static let endPoint = "http://localhost:3000/"
    static let loginURL = endPoint + "auth/login"
    static let checkIDUniqueURL = endPoint + "auth/check-id-unique"
    static let checkEmailUniqueURL = endPoint + "auth/check-email-unique"
    static let sendEmailTokenURL = endPoint + "auth/send-email-token"
    static let checkEmailTokenURL = endPoint + "auth/check-email-token"
    static let signUpURL = endPoint + "auth/signup/user"
}
