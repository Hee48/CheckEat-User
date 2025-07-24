//
//  JoinView.swift
//  CheckEat-Business
//
//  Created by Hee  on 7/7/25.
//

import SwiftUI

struct JoinView: View {
    @State private var id: String = ""
    @State private var password: String = ""
    @State private var isPasswordValid: Bool = false
    @State private var passwordConfirm: String = ""
    @State private var isLengthValid: Bool = false
    @State private var isComplexValid: Bool = false
    @State private var isPasswordVisible: Bool = false
    @State private var isPasswordConfirmVisible: Bool = false
    @State private var verificationCode:String = ""
    @FocusState private var isPasswordFocused: Bool
    @FocusState private var isPasswordConfirmFocused: Bool
    @State private var nickName = ""
    @State private var didSendCode: Bool = false
    @State private var email: String = ""
    @State private var isChecked: Bool = false
    @State private var isChecked2:Bool = false
    @State private var isChecked3:Bool = false
    @State private var goUserRegistrationComplete = false
    @Environment(\.dismiss) private var dismiss
    private var isFormValid: Bool {
        return !id.isEmpty && !password.isEmpty && !passwordConfirm.isEmpty && !email.isEmpty && !verificationCode.isEmpty && isChecked && isChecked2 && isChecked3
    }
    var body: some View {
        NavigationStack {
            GeometryReader { _ in
                ScrollView {
                    VStack(alignment: .leading, spacing: 4){
                        HStack {
                            Text("기본 정보 입력")
                                .semibold16()
                                .foregroundColor(.buttonEnable)
                                .padding(.top, 20)
                                .padding(.leading, 17)
                            Spacer()
                            StepCircle(number: 1, fillColor: .buttonEnable, textColor: .white)
                            StepCircle(number: 2, fillColor: .buttonSoft, textColor: .buttonEnable)
                                .padding(.trailing, 20)
                        }
                        //아이디,닉네임,비밀번호,비밀번호확인
                        JoinBasicInfoSection(id: $id, password: $password, passwordConfirm: $passwordConfirm, isPasswordVisible: $isPasswordVisible, isPasswordConfirmVisible: $isPasswordConfirmVisible, isPasswordValid: $isPasswordValid, isLengthValid: $isLengthValid, nickName: $nickName, isPasswordFocused: $isPasswordFocused, isPasswordConfirmFocused: $isPasswordConfirmFocused)
                        //이메일,인증코드
                        ContactVerificationSection(email: $email, verificationCode: $verificationCode, didSendCode: $didSendCode)
                        
                        HStack {
                            CheckBoxButton(isChecked: $isChecked) {
                                isChecked2 = isChecked
                                isChecked3 = isChecked
                            }
                            .padding(.top, 20)
                            .padding(.leading, 20)
                            Text("모두 동의합니다.")
                                .padding(.top, 20)
                                .padding(.leading, 5)
                                .semibold14()
                        }
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color("Button_OP"))
                                .frame(width: 362, height: 85)
                                .cornerRadius(5)
                                .padding(.leading, 20)
                                .padding(.top, 10)
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 8) {
                                    CheckBoxButton(isChecked: $isChecked2, onToggle: updateAllCheckBox)
                                        .padding(.top, 10)
                                    Text("[필수] 서비스이용약관에 동의합니다.")
                                        .font(.system(size: 14, weight: .medium))
                                        .padding(.top, 10)
                                }
                                HStack(spacing: 8) {
                                    CheckBoxButton(isChecked: $isChecked3, onToggle: updateAllCheckBox)
                                        .padding(.top, 10)
                                    Text("[필수] 만 14세 이상입니다.")
                                        .font(.system(size: 14, weight: .medium))
                                        .padding(.top, 5)
                                }
                            }
                            .padding(.leading, 35)
                            
                        }
                        Button {
                            goUserRegistrationComplete = true
                        } label: {
                            Text("다음")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 362, height: 56, alignment: .center)
                                .background(isFormValid ? Color("Button_Enable") : Color("Button_Disable"))
                                .cornerRadius(6)
                                .padding(.top, 30)
                                .padding(.leading, 20)
                        }
                        .disabled(!isFormValid)
                        NavigationLink(destination: UserRegistrationComplete(), isActive: $goUserRegistrationComplete) {
                            EmptyView()
                        }
                        
                        Spacer()
                        
                    }
                    .navigationTitle("회원가입")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "chevron.backward")
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                }
            }
        }
    }

    func updateAllCheckBox() {
        isChecked = isChecked2 && isChecked3
    }
}

//#Preview {
//    JoinView()
//}
