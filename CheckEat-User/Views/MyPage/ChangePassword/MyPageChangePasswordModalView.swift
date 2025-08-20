//
//  MyPageChangePasswordModalView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/14/25.
//

import SwiftUI

struct MyPageChangePasswordModalView: View {
    
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var isNewPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    
    @State private var isLengthValid: Bool = false
    @State private var isUpperLowerNumberSpecialValid: Bool = false
    
    @State private var isPasswordAgreement: Bool = false
    
    @State private var editable: Bool = false
    @State private var showCompleteModal = false
    
    @FocusState private var isNewPasswordFocused: Bool
    @FocusState private var isConfirmPasswordFocused: Bool
    @StateObject private var viewModel = ChangePwdViewModel()
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                Text("action_change_password")
                    .bold20()
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image("xmark")
                }
            }
            .padding(.vertical)
            
            Text("password_new_title")
                .semibold16()
            HStack {
                Group {
                    if isNewPasswordVisible {
                        UnderLinedTextField(placeholder: "password_new_placeholder", text: $newPassword)
                            .focused($isNewPasswordFocused)
                            .textContentType(.newPassword)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                    } else {
                        UnderLinedTextField(placeholder: "password_new_placeholder", isSecure: true, text: $newPassword)
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
                    Text("password_match")
                        .foregroundColor(isPasswordAgreement ? .green : .gray)
                }
            }
            .regular12()
            .padding(.vertical, 8)
            .padding(.bottom, 24)
            
            Button {
                if isLengthValid && isUpperLowerNumberSpecialValid && isPasswordAgreement {
                       viewModel.newPwd = newPassword
                       viewModel.changePwd {
                           showCompleteModal = true
                       }
                   }
            } label: {
                Text("password_change_button")
                    .primaryButtonStyle(isEnabled: (isLengthValid && isUpperLowerNumberSpecialValid && isPasswordAgreement))
                    .semibold16()
            }
            .disabled(!(isLengthValid && isUpperLowerNumberSpecialValid && !confirmPassword.isEmpty))
        }
        .padding(.horizontal)
        .onChange(of: newPassword) {
            validatePassword()
        }
        .onChange(of: confirmPassword) {
            validatePassword()
        }
        .tapToDismissKeyboard()
        .sheet(isPresented: $showCompleteModal) {
            MyPageChangePasswordCompleteModalView {
                dismiss()
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(350)])
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
}

//#Preview {
//    MyPageChangePasswordModalView()
//}
