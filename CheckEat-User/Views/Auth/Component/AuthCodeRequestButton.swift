//
//  AuthCodeRequestButton.swift
//  CheckEat-Business
//
//  Created by 최준영 on 8/7/25.
//

import SwiftUI

struct AuthCodeRequestButton: View {
    var isUserEmailValid: Bool
    @Binding var infoMsg: String
    @Binding var isFieldVisible: Bool
    @Binding var authCodeIsValid: Bool?
    var resendCode: () -> Void
    
    var body: some View {
        Button {
            infoMsg = "입력하신 이메일로 인증코드를 전송했습니다."
            isFieldVisible = true
            authCodeIsValid = nil
            resendCode()
        } label: {
            Text("인증코드 받기")
                .primaryButtonStyle(isEnabled: isUserEmailValid)
                .semibold16()
        }
        .disabled(!isUserEmailValid)
        .padding(.top, 24)
    }
}
