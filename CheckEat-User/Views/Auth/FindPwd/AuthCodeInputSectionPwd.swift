//
//  AuthCodeInputSectionPwd.swift
//  CheckEat-Business
//
//  Created by 최준영 on 8/6/25.
//

import SwiftUI

struct AuthCodeInputSectionPwd: View {
    
    @ObservedObject var viewModel: FindPwdViewModel
    @Binding var path: [FindPwdRoute]
    
    @Binding var userId: String
    @Binding var userEmail: String
    
    @Binding var authCode: String
    @Binding var authCodeIsValid: Bool?
    var canRequestAuthCode: Bool
    
    @FocusState.Binding var fieldIsFocused: Bool
    
    var timerActive: Bool
    var timeRemaining: Int
    var formatTime: (Int) -> String
    
    var resendCode: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("인증코드")
                .semibold16()
            AuthCodeTextField(placeholder: "인증코드를 입력해주세요", text: $authCode)
                .regular14()
                .focused($fieldIsFocused)
            
            if authCodeIsValid == false && !viewModel.alertMessage.isEmpty {
                Text(viewModel.alertMessage)
                    .regular12()
                    .foregroundStyle(.red)
                    .padding(.vertical, 8)
            }
            
            if timerActive {
                HStack {
                    Spacer()
                    Button {
                        resendCode()
                    } label: {
                        Text("인증코드 다시 보내기")
                            .bold14()
                            .foregroundStyle(.buttonAuth)
                    }
                    Text(formatTime(timeRemaining))
                        .monospacedDigit()
                        .regular14()
                    Spacer()
                }
                .padding(.vertical, 24)
            } else {
                HStack {
                    Spacer()
                    Text("인증코드를 받지 못했어요")
                        .regular14()
                    Button {
                        authCode = ""
                        authCodeIsValid = nil
                        resendCode()
                    } label: {
                        Text("인증코드 다시 받기")
                            .bold14()
                            .foregroundStyle(.buttonAuth)
                    }
                    Spacer()
                }
                .padding(.vertical, 24)
            }
            
            HStack {
                Button {
                    viewModel.verifyEmailToken(email: userEmail, token: authCode) { completion in
                        if completion == true {
                            authCodeIsValid = true
                            path.append(.inputNewPwd)
                        } else if completion == false {
                            authCodeIsValid = false
                        }
                    }
                } label: {
                    Text("완료")
                        .primaryButtonStyle(isEnabled: canRequestAuthCode)
                        .semibold16()
                }
                .disabled(authCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
    }
}
