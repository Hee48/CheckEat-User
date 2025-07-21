//
//  ContactVerificationSection.swift
//  CheckEat-Business
//
//  Created by Hee  on 7/9/25.
//

import SwiftUI

struct ContactVerificationSection: View {

    @Binding var email: String
    @State private var isEmailValid: Bool = false
    @Binding var verificationCode: String
    @Binding var didSendCode: Bool
    private let correctAuthCode = "1234"
    @State private var isVerificationCodeValid: Bool = false
    @State private var hasSentOnce: Bool = false
    @ObservedObject var viewModel: RegisterViewModel
    var body: some View {
        VStack(alignment: .leading){
            Text("이메일")
                .semibold14()
                .padding(.leading, 17)
                .padding(.top, 10)
            ZStack(alignment: .trailing) {
                UnderLinedTextField(placeholder: "이메일을 입력해 주세요", text: $email)
                    .regular14()
                    .padding(.horizontal, 20)
                    .padding(.top, 5)
                    .onChange(of: email) { newValue in
                        isEmailValid = isValidEmailAddress(email: newValue)
                    }
                    .disabled(didSendCode)
                Button {
                    //이메일 중복확인 검사
                    viewModel.checkEmailUnique(email: email) {
                        print("✅ 인증코드 전송 시작됨")
                        didSendCode = true
                        hasSentOnce = true
                    }
                } label: {
                    Text(didSendCode ? "재전송" : "중복 확인")
                        .frame(width: 97, height: 34)
                        .bold14()
                        .foregroundColor(.black)
                        .background(Color(didSendCode ? "Button_OP20" : "Button_soft"))
                        .cornerRadius(5)
                        .padding(.bottom, 13)
                        .padding(.trailing, 20)
                }
                .disabled(!isEmailValid || hasSentOnce)

            }
            if didSendCode {
                Text("인증코드")
                    .semibold14()
                    .padding(.leading, 17)
                    .padding(.top, 10)
                ZStack(alignment: .trailing) {
                    UnderLinedTextField(placeholder: "인증코드를 입력해 주세요.", text: $verificationCode)
                        .regular14()
                        .padding(.leading, 17)
                        .padding(.top, 5)
                        .onChange(of: verificationCode) { newValue in
                            isVerificationCodeValid = (newValue == correctAuthCode)
                        }
                    Button {
                        //인증코드 인증부분
                        viewModel.verifyEmailToken(email: email, token: verificationCode)
                    } label: {
                        Text("인증하기")
                            .frame(width: 97, height: 34)
                            .bold14()
                            .foregroundColor(.black)
                            .background(Color("Button_soft"))
                            .cornerRadius(5)
                            .padding(.bottom, 13)
                            .padding(.trailing, 20)
                    }
                }
            }
        }
        Text("채식 구분 선택")
            .semibold14()
            .padding(.leading, 17)
            .padding(.top, 10)
    }
    func isValidEmailAddress(email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@(?:[A-Za-z0-9-]+\\.)+[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
