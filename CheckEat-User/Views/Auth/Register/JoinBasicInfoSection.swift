//
//  JoinBasicInfoSection.swift
//  CheckEat-Business
//
//  Created by Hee  on 7/9/25.
//

import SwiftUI

struct JoinBasicInfoSection: View {
    @Binding var id: String
    @Binding var password: String
    @Binding var passwordConfirm: String
    @Binding var isPasswordVisible: Bool
    @Binding var isPasswordConfirmVisible: Bool
    @Binding var isPasswordValid: Bool
    @Binding var isLengthValid: Bool
    @Binding var nickName: String
    @FocusState.Binding var isPasswordFocused: Bool
    @FocusState.Binding var isPasswordConfirmFocused: Bool
    @ObservedObject var viewModel: RegisterViewModel
    var body: some View {
        VStack(alignment: .leading) {
            Text("아이디")
                .font(.system(size: 14, weight: .semibold))
                .padding(.leading, 17)
                .padding(.top, 25)
            ZStack(alignment: .trailing) {
                VStack {
                    UnderLinedTextField(placeholder: "아이디를 입력해 주세요.", text: $id)
                        .font(.system(size: 14))
                        .padding(.horizontal, 20)
                }
                .keyboardType(.asciiCapable)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                Button {
                    viewModel.checkIdUnique(id: id)
                } label: {
                    Text("중복 확인")
                        .frame(width: 83, height: 34)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                        .background(Color("Button_soft"))
                        .cornerRadius(5)
                        .padding(.bottom, 13)
                        .padding(.trailing, 20)
                    
                }
            }
            Text("닉네임")
                .semibold14()
                .padding(.leading, 17)
                .padding(.top, 15)
            UnderLinedTextField(placeholder: "닉네임을 입력해 주세요.", text: $nickName)
                .font(.system(size: 14))
                .padding(.horizontal, 20)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)

            Text("비밀번호")
                .semibold14()
                .padding(.leading, 17)
                .padding(.top, 15)
            ZStack(alignment: .trailing) {
                Group {
                    if isPasswordVisible {
                        TextField("비밀번호를 입력해 주세요.", text: $password)
                    } else {
                        SecureField("비밀번호를 입력해 주세요", text: $password)
                    }
                }
                .font(.system(size: 14))
                .padding(.horizontal, 20)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)

                .focused($isPasswordFocused)
                .frame(height: 36)
                .onChange(of: password) { newVaule in
                    isPasswordValid = isValidPassword(newVaule)
                    isLengthValid = newVaule.count >= 8
                }
                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                        .frame(width: 16, height: 16)
                        .foregroundColor(.buttonOP50)
                        .padding(.trailing, 30)
                }
            }
            Rectangle()
                .frame(width: 356, height: 1)
                .padding(.leading, 17)
                .foregroundColor(isPasswordFocused || !password.isEmpty ? .black : Color(red: 0.85, green: 0.85, blue: 0.85))
                .animation(.easeInOut(duration: 0.1), value: isPasswordFocused)
            HStack {
                Image(systemName: "checkmark")
                    .frame(width: 16, height: 16)
                    .foregroundColor(isLengthValid ? .green : .buttonOP20)
                    .padding(.leading, 20)
                Text("8자 이상")
                    .font(.system(size: 12))
                    .foregroundColor(isLengthValid ? .green : .buttonOP20)
                Image(systemName: "checkmark")
                    .frame(width: 16, height: 16)
                    .foregroundColor(isPasswordValid ? .green : .buttonOP20)
                    .padding(.leading)
                Text("대소문자, 숫자, 특수문자 포함")
                    .font(.system(size: 12))
                    .foregroundColor(isPasswordValid ? .green : .buttonOP20)
            }
            .padding(.top, 10)
            Text("비밀번호 확인")
                .semibold14()
                .padding(.leading, 17)
                .padding(.top, 15)
            ZStack(alignment: .trailing) {
                Group {
                    if isPasswordConfirmVisible {
                        TextField("비밀번호를 한번더 입력해주세요.", text: $passwordConfirm)
                    } else {
                        SecureField("비밀번호를 한번더 입력해주세요", text: $passwordConfirm)
                    }
                }
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .font(.system(size: 14))
                .padding(.horizontal, 20)
                .padding(.top, 5)
                .focused($isPasswordConfirmFocused)
                .frame(height: 40)
                Button {
                    isPasswordConfirmVisible.toggle()
                } label: {
                    Image(systemName: isPasswordConfirmVisible ? "eye" : "eye.slash")
                        .frame(width: 16, height: 16)
                        .foregroundColor(.buttonOP50)
                        .padding(.trailing, 30)
                }
            }
            Rectangle()
                .frame(width: 356, height: 1)
                .padding(.leading, 17)
                .foregroundColor(isPasswordConfirmFocused || !passwordConfirm.isEmpty ? .black : Color(red: 0.85, green: 0.85, blue: 0.85))
                .animation(.easeInOut(duration: 0.1), value: isPasswordConfirmFocused)
            if !passwordConfirm.isEmpty {
                HStack{
                    if password == passwordConfirm {
                        Image(systemName: "checkmark")
                            .frame(width: 16, height: 16)
                            .foregroundColor(.green)
                        Text("비밀번호 일치")
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "xmark")
                            .frame(width: 8, height: 8)
                            .foregroundColor(.red)
                        Text("비밀번호 불일치")
                            .font(.system(size: 12))
                            .foregroundColor(.red)
                    }
                }
                .padding(.leading, 17)
                .padding(.top, 5)
            }
        }
        .tapToDismissKeyboard()
        
    }
    func isValidPassword(_ password: String) -> Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+=\\{}|\\[\\]:;\"'<>,.?/\\-]).{8,50}$"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: password)
    }
}

