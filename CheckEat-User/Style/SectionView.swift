//
//  SectionView.swift
//  CheckEat-Business
//
//  Created by 최준영 on 7/14/25.
//

import SwiftUI

struct SectionView: View {
    let title: String
    let buttons: [(title: String, destination: SettingDestination)]
    var onButtonTap: (SettingDestination) -> Void

    @State private var currentLanguage = LanguageSettingsViewModel.getCurrentLanguage()

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title.localized)
                .semibold14()
                .foregroundStyle(.buttonOP20)

            ForEach(buttons, id: \.destination) { button in
                Button {
                    onButtonTap(button.destination)
                } label: {
                    Text(button.title.localized)
                        .medium16()
                        .foregroundStyle(.buttonAuth)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("LanguageChanged"))) { _ in
            currentLanguage = LanguageSettingsViewModel.getCurrentLanguage()
        }
        .id(currentLanguage)
    }
}

