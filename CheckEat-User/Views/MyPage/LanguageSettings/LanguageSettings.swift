//
//  Lan.swift
//  CheckEat-User
//
//  Created by Hee  on 7/29/25.
//

import SwiftUI

struct LanguageSettings: View {
    private var selectedLanguageCode: String {
        switch selectedLanguage {
        case "English": return "en"
        case "한국어": return "ko"
        case "عربي": return "ar"
        default: return "en" 
        }
    }
    @Environment(\.dismiss) private var dismiss
    let languages = ["English", "한국어", "عربي"]
    @State private var selectedLanguage: String = ""
    @StateObject var viewModel = LanguageSettingsViewModel()
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("language_setting_description".localized)
                    .bold20()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 30)
            .padding(.leading, 20)
            ForEach(languages, id: \.self) { lang in
                Button {
                    selectedLanguage = lang
                } label: {
                    HStack {
                        Text(lang)
                            .foregroundColor(.black)
                        Spacer()
                        if selectedLanguage == lang {
                            Image(systemName: "checkmark")
                                .foregroundColor(.orange)
                        }
                    }
                    .padding()
                    .frame(height: 56)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(selectedLanguage == lang ? Color("Button_Enable") : Color.gray.opacity(0.2), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
            }
            Spacer()
            Button {
                viewModel.languageSettings(language: selectedLanguageCode) { success in
                    if success {
                        dismiss()
                    }
                }
            } label: {
                Text("language_setting_button".localized)
                    .primaryButtonStyle()
                    .semibold16()
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
        }
        .onAppear {
            setupInitialLanguage()
        }
        .navigationTitle("language_setting_title".localized)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func setupInitialLanguage() {
        let currentLanguageCode = LanguageSettingsViewModel.getCurrentLanguage() // 뷰모델의 static 함수 호출
        selectedLanguage = LanguageSettingsViewModel.getLanguageDisplayName(currentLanguageCode) // 뷰모델의 static 함수 호출
        print("🎬 언어 설정 뷰 초기화: \(currentLanguageCode) -> \(selectedLanguage)")
    }
}
