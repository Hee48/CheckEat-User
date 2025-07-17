//
//  ChangePasswordView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/5/25.
//

import SwiftUI

struct ChangePasswordView: View {
    
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var isNewPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    
    @State private var isLengthValid: Bool = false
    @State private var isUpperLowerNumberSpecialValid: Bool = false
    
    @State private var isPasswordAgreement: Bool = false
    
    @State private var editable: Bool = false
    
    @FocusState private var isNewPasswordFocused: Bool
    @FocusState private var isConfirmPasswordFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("비밀번호를 재설정 해주세요.")
                        .bold20()
                        .padding(.top, 35)
                    Text("새로운 비밀번호를 입력해주세요.")
                        .regular16()
                        .padding(.top, 1)
                        .padding(.bottom, 35)
                    
                    Text("새로운 비밀번호")
                        .semibold16()
                    HStack {
                        Group {
                            if isNewPasswordVisible {
                                UnderLinedTextField(placeholder: "새로운 비밀번호를 입력해주세요", text: $newPassword)
                                    .focused($isNewPasswordFocused)
                                    .textContentType(.newPassword)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            } else {
                                UnderLinedTextField(placeholder: "새로운 비밀번호를 입력해주세요", isSecure: true, text: $newPassword)
                                    .focused($isNewPasswordFocused)
                                    .textContentType(.newPassword)
                            }
                        }
                        
                        Button {
                            isNewPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isNewPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                                .padding(8)
                                .contentShape(Rectangle())
                        }
                    }
                    .regular14()
                    
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: isLengthValid ? "checkmark" : "checkmark")
                                .foregroundColor(isLengthValid ? .green : .gray)
                            Text("8자 이상")
                                .foregroundColor(isLengthValid ? .green : .gray)
                            
                            Image(systemName: isUpperLowerNumberSpecialValid ? "checkmark" : "checkmark")
                                .foregroundColor(isUpperLowerNumberSpecialValid ? .green : .gray)
                            Text("대소문자, 숫자, 특수문자 포함")
                                .foregroundColor(isUpperLowerNumberSpecialValid ? .green : .gray)
                        }
                    }
                    .regular12()
                    .padding(.vertical, 8)
                    
                    Text("비밀번호 확인")
                        .semibold16()
                        .padding(.top)
                    
                    HStack {
                        Group {
                            if isConfirmPasswordVisible {
                                UnderLinedTextField(placeholder: "비밀번호를 한 번 더 입력해주세요", text: $confirmPassword)
                                    .focused($isConfirmPasswordFocused)
                                    .textContentType(.newPassword)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            } else {
                                UnderLinedTextField(placeholder: "비밀번호를 한 번 더 입력해주세요", isSecure: true, text: $confirmPassword)
                                    .focused($isConfirmPasswordFocused)
                                    .textContentType(.newPassword)
                            }
                        }
                        
                        Button {
                            isConfirmPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isConfirmPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                                .padding(8)
                                .contentShape(Rectangle())
                        }
                    }
                    .regular14()
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: isPasswordAgreement ? "checkmark" : "checkmark")
                                .foregroundColor(isPasswordAgreement ? .green : .gray)
                            Text("비밀번호 일치")
                                .foregroundColor(isPasswordAgreement ? .green : .gray)
                        }
                    }
                    .regular12()
                    .padding(.vertical, 8)
                    .padding(.bottom, 24)
                    
                    Button {
                        resetPassword()
                        editable = (isLengthValid && isUpperLowerNumberSpecialValid && isPasswordAgreement)
                    } label: {
                        Text("비밀번호 재설정")
                            .primaryButtonStyle(isEnabled: (isLengthValid && isUpperLowerNumberSpecialValid && isPasswordAgreement))
                            .semibold16()
                    }
                    .disabled(!(isLengthValid && isUpperLowerNumberSpecialValid && !confirmPassword.isEmpty))
                }
                .tapToDismissKeyboard()
            }
            .padding(.horizontal)
            .navigationTitle("비밀번호 재설정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
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
            .onChange(of: newPassword) {
                validatePassword()
            }
            .onChange(of: confirmPassword) {
                validatePassword()
            }
            .fullScreenCover(isPresented: $editable) {
                ChangePasswordCompleteView()
            }
        }
    }
    
    private func validatePassword() {
        isLengthValid = newPassword.count >= 8
        isUpperLowerNumberSpecialValid = containsUpperLowerNumberSpecial(newPassword)
        
        if (!newPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            isPasswordAgreement = (newPassword == confirmPassword)
        }
        
    }
    
    private func containsUpperLowerNumberSpecial(_ password: String) -> Bool {
        let uppercase = CharacterSet.uppercaseLetters
        let lowercase = CharacterSet.lowercaseLetters
        let digits = CharacterSet.decimalDigits
        let special = CharacterSet.punctuationCharacters.union(.symbols)
        
        let hasUpper = password.rangeOfCharacter(from: uppercase) != nil
        let hasLower = password.rangeOfCharacter(from: lowercase) != nil
        let hasDigit = password.rangeOfCharacter(from: digits) != nil
        let hasSpecial = password.rangeOfCharacter(from: special) != nil
        
        return hasUpper && hasLower && hasDigit && hasSpecial
    }
    
    private func resetPassword() {
        print("비밀번호가 성공적으로 재설정되었습니다: \(newPassword)")
    }
}

#Preview {
    ChangePasswordView()
}

