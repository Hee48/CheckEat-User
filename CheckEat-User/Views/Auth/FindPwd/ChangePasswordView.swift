//
//  ChangePasswordView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/5/25.
//

import SwiftUI

struct ChangePasswordView: View {
    
    // MARK: 스크린 상태 값
    @Binding var showFindPwd: Bool
    @Binding var showFindID: Bool
    // MARK: 하위 경로 스택
    @Binding var path: [FindPwdRoute]
    
    //MARK: 비밀번호 변경시 필요한 필드
    @Binding var userEmail: String
    //MARK: 변경할 비밀번호
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
    
    //MARK: 뷰 모델
    @ObservedObject var viewModel: FindPwdViewModel
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading) {
                Text("reset_password_instruction")
                    .bold20()
                    .padding(.top, 35)
                Text("new_password_instruction")
                    .regular16()
                    .padding(.top, 1)
                    .padding(.bottom, 35)
                
                Text("new_password_label")
                    .semibold16()
                HStack {
                    Group {
                        if isNewPasswordVisible {
                            UnderLinedTextField(placeholder: "new_password_placeholder", text: $newPassword)
                                .focused($isNewPasswordFocused)
                                .textContentType(.newPassword)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        } else {
                            UnderLinedTextField(placeholder: "new_password_placeholder", isSecure: true, text: $newPassword)
                                .focused($isNewPasswordFocused)
                                .textContentType(.newPassword)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                    }
                    .overlay(alignment: .trailing) {
                        Button {
                            isNewPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isNewPasswordVisible ? "eye" : "eye.slash")
                                .frame(width: 16, height: 16)
                                .foregroundColor(.buttonOP50)
                                .padding(.bottom, 30)
                                .padding(.trailing, 8)
                                .contentShape(Rectangle())
                        }
                    }
                }
                .regular14()
                
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: isLengthValid ? "checkmark" : "checkmark")
                            .foregroundColor(isLengthValid ? .green : .gray)
                        Text("password_rule_minlen")
                            .foregroundColor(isLengthValid ? .green : .gray)
                        
                        Image(systemName: isUpperLowerNumberSpecialValid ? "checkmark" : "checkmark")
                            .foregroundColor(isUpperLowerNumberSpecialValid ? .green : .gray)
                        Text("password_rule_complexity")
                            .foregroundColor(isUpperLowerNumberSpecialValid ? .green : .gray)
                    }
                }
                .regular12()
                .padding(.vertical, 8)
                
                Text("password_confirm_title")
                    .semibold16()
                    .padding(.top)
                
                HStack {
                    Group {
                        if isConfirmPasswordVisible {
                            UnderLinedTextField(placeholder: "password_confirm_placeholder", text: $confirmPassword)
                                .focused($isConfirmPasswordFocused)
                                .textContentType(.newPassword)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        } else {
                            UnderLinedTextField(placeholder: "password_confirm_placeholder", isSecure: true, text: $confirmPassword)
                                .focused($isConfirmPasswordFocused)
                                .textContentType(.newPassword)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                    }
                    
                    .overlay(alignment: .trailing) {
                        Button {
                            isConfirmPasswordVisible.toggle()
                        } label: {
                            Image(systemName: isConfirmPasswordVisible ? "eye" : "eye.slash")
                                .frame(width: 16, height: 16)
                                .foregroundColor(.buttonOP50)
                                .padding(.bottom, 30)
                                .padding(.trailing, 8)
                                .contentShape(Rectangle())
                        }
                    }
                }
                .regular14()
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: isPasswordAgreement ? "checkmark" : "checkmark")
                            .foregroundColor(isPasswordAgreement ? .green : .gray)
                        Text("password_match")
                            .foregroundColor(isPasswordAgreement ? .green : .gray)
                    }
                }
                .regular12()
                .padding(.vertical, 8)
                .padding(.bottom, 24)
                
                Button {
                    
                    viewModel.changePassword(email: userEmail, newPassword: newPassword) { result in
                        if result == true {
                            path.append(.findPwdComplete)
                        } else if result == false {
                            ToastManager.shared.showToast(message: "reset_password_failed")
                        }
                    }
                } label: {
                    Text("reset_password_title")
                        .primaryButtonStyle(isEnabled: (isLengthValid && isUpperLowerNumberSpecialValid && isPasswordAgreement))
                        .semibold16()
                }
                .disabled(!(isLengthValid && isUpperLowerNumberSpecialValid && !confirmPassword.isEmpty))
            }
            .tapToDismissKeyboard()
        }
        .padding(.horizontal)
        .navigationTitle("reset_password_title")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: newPassword) {
            validatePassword()
        }
        .onChange(of: confirmPassword) {
            validatePassword()
        }
    }
    
    private func validatePassword() {
        isLengthValid = newPassword.count >= 8
        isUpperLowerNumberSpecialValid = containsUpperLowerNumberSpecial(newPassword)
        
        if (!newPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
            isPasswordAgreement = newPassword.trimmingCharacters(in: .whitespacesAndNewlines) ==
            confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
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

import Combine
class ToastManager: ObservableObject {
    static let shared = ToastManager()
    @Published var message: String? = nil
    
    func showToast(message: String) {
        self.message = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.message = nil
        }
    }
}
