//
//  UnderLinedTextField.swift
//  CheckEat-Business
//
//  Created by Hee  on 7/5/25.
//

import SwiftUI

struct UnderLinedTextField: View {
    let placeholder: LocalizedStringKey
    var isSecure: Bool = false
    @Binding var text: String
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            if isSecure {
                SecureField("", text: $text, prompt: Text(placeholder))
                    .padding(.vertical, 8)
                    .focused($isFocused)
            } else {
                TextField("", text: $text, prompt: Text(placeholder))
                    .padding(.vertical, 8)
                    .focused($isFocused)
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(isFocused || !text.isEmpty ? .black : Color(red: 0.85, green: 0.85, blue: 0.85))
                .animation(.easeInOut(duration: 0.1), value: isFocused)
        }
    }
}

struct AuthCodeTextField: View {
    let placeholder: LocalizedStringKey
    @Binding var text: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            TextField(placeholder, text: $text)
                .autocapitalization(.allCharacters) // 키보드에서 대문자 제안
                .disableAutocorrection(true) // 자동 수정 비활성화
                .padding(.vertical, 8)
                .focused($isFocused)
                .onChange(of: text) { oldValue, newValue in
                    // 입력된 텍스트를 강제로 대문자로 변환
                    text = newValue.uppercased()
                }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(isFocused || !text.isEmpty ? .black : Color(red: 0.85, green: 0.85, blue: 0.85))
                .animation(.easeInOut(duration: 0.1), value: isFocused)
        }
    }
}
