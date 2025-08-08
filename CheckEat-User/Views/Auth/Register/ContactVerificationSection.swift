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
//    private let correctAuthCode = "1234"
    @State private var isVerificationCodeValid: Bool = true
    @State private var showCodeErrorMessage: Bool = false
    @State private var hasSentOnce: Bool = false
    @ObservedObject var viewModel: RegisterViewModel
    @Binding var selectedVeganType: VeganLevel
    @State private var isHalal: Bool? = nil
    @State private var allergy: Bool? = nil
    @Binding var showAllergy19: Bool
    @Binding var selectedHalalStatus: HalaStatus
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
                        .padding(.horizontal, 20)
                        .padding(.top, 5)
                    Button {
                        //인증코드 인증부분
                        viewModel.verifyEmailToken(email: email, token: verificationCode) { isSuccess in
                            isVerificationCodeValid = isSuccess
                            showCodeErrorMessage = !isSuccess
                        }
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
                if showCodeErrorMessage {
                    Text("잘못된 코드입니다. 다시 시도해 주세요.")
                        .foregroundColor(.red)
                        .font(.system(size: 12))
                        .padding(.leading, 17)
                        .padding(.top, 2)
                }
            }
        }
        VeganDropDown(selected: $selectedVeganType)
            .padding(.top, 10)
        Text("할랄 여부")
            .semibold14()
            .padding(.leading, 17)
            .padding(.top, 10)
        HStack(spacing: 12) {
            Button {
                isHalal = true
                selectedHalalStatus = .yes
            } label: {
                Text("O")
                    .foregroundColor(isHalal == true ? .white : .black)
                    .frame(width: 175, height: 56)
                    .background(isHalal == true ? Color("Button_Enable") : Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isHalal == true ? Color.clear : Color.black, lineWidth: 1)
                    )
            }
            
            Button {
                isHalal = false
                selectedHalalStatus = .no
            } label: {
                Text("X")
                    .foregroundColor(isHalal == false ? .white : .black)
                    .frame(width: 175, height: 56)
                    .background(isHalal == false ? Color("Button_Enable") : Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isHalal == false ? Color.clear : Color.black, lineWidth: 1)
                    )
            }
        }
        .padding(.leading, 17)
        .padding(.top, 10)
        
        Text("알러지 여부")
            .semibold14()
            .padding(.leading, 17)
            .padding(.top, 10)
        HStack(spacing: 12) {
            Button {
                showAllergy19 = true
                allergy = true
            } label: {
                Text("O")
                    .foregroundColor(allergy == true ? .white : .black)
                    .frame(width: 175, height: 56)
                    .background(allergy == true ? Color("Button_Enable") : Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(allergy == true ? Color.clear : Color.black, lineWidth: 1)
                    )
            }

            Button {
                allergy = false
            } label: {
                Text("X")
                    .foregroundColor(allergy == false ? .white : .black)
                    .frame(width: 175, height: 56)
                    .background(allergy == false ? Color("Button_Enable") : Color.white)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(allergy == false ? Color.clear : Color.black, lineWidth: 1)
                    )
            }
        }
        .padding(.leading, 17)
        .padding(.top, 10)
    }
    func isValidEmailAddress(email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@(?:[A-Za-z0-9-]+\\.)+[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
//#Preview {
//    ContactVerificationSection(
//        email: .constant("test@example.com"),
//        verificationCode: .constant(""),
//        didSendCode: .constant(true),
//        viewModel: RegisterViewModel(), showAllergy19: .constant(true), isHalalValue: .constant(0)
//    )
//}
