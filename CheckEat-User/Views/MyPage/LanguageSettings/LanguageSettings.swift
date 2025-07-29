//
//  Lan.swift
//  CheckEat-User
//
//  Created by Hee  on 7/29/25.
//

import SwiftUI

struct LanguageSettings: View {
    @Environment(\.dismiss) private var dismiss
    let languages = ["English", "한국어", "عربي"]
    @State private var selectedLanguage: String = "English"
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .leading) {
                    Text("언어를 선택해 주세요.")
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
                    
                } label: {
                    Text("변경하기")
                        .primaryButtonStyle()
                        .semibold16()
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .navigationTitle("언어 설정")
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
#Preview {
    LanguageSettings()
}
