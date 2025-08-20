//
//  UnderLinedTextField.swift
//  CheckEat-Business
//
//  Created by Hee  on 7/5/25.
//

import SwiftUI

struct UnderLinedTextField: View {
    let placeholder: String
    var isSecure: Bool = false
    @Binding var text: String

    @FocusState private var isFocused: Bool
    @State private var currentLanguage = LanguageSettingsViewModel.getCurrentLanguage()

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if isSecure {
                SecureField(
                    "",
                    text: $text,
                    prompt: Text(placeholder.localized)
                )
                .textContentType(.newPassword)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.vertical, 8)
                .focused($isFocused)
            } else {
                TextField(
                    "",
                    text: $text,
                    prompt: Text(placeholder.localized)
                )
                .textContentType(.password)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.vertical, 8)
                .focused($isFocused)
            }

            Rectangle()
                .frame(height: 1)
                .foregroundColor(isFocused || !text.isEmpty ? .black : Color(red: 0.85, green: 0.85, blue: 0.85))
                .animation(.easeInOut(duration: 0.1), value: isFocused)
        }
        // 언어 변경 시 강제 리빌드 (플레이스홀더 문자열도 재평가)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
            currentLanguage = LanguageSettingsViewModel.getCurrentLanguage()
        }
        .id(currentLanguage)
    }
}

struct AuthCodeTextField: View {
    let placeholder: String
    @Binding var text: String

    @FocusState private var isFocused: Bool
    @State private var currentLanguage = LanguageSettingsViewModel.getCurrentLanguage()

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField(
                "",
                text: $text,
                prompt: Text(placeholder.localized)
            )
            .autocapitalization(.allCharacters)
            .disableAutocorrection(true)
            .padding(.vertical, 8)
            .focused($isFocused)
            .onChange(of: text) { _, newValue in
                text = newValue.uppercased()
            }

            Rectangle()
                .frame(height: 1)
                .foregroundColor(isFocused || !text.isEmpty ? .black : Color(red: 0.85, green: 0.85, blue: 0.85))
                .animation(.easeInOut(duration: 0.1), value: isFocused)
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
            currentLanguage = LanguageSettingsViewModel.getCurrentLanguage()
        }
        .id(currentLanguage)
    }
}
